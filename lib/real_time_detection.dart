import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class RealTimeObjectDetection extends StatefulWidget {
  @override
  _RealTimeObjectDetectionState createState() =>
      _RealTimeObjectDetectionState();
}

class _RealTimeObjectDetectionState extends State<RealTimeObjectDetection> {
  late CameraController _cameraController;
  late Interpreter _interpreter;
  late List<CameraDescription> cameras;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initializeCamera();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image) {
      if (!isDetecting) {
        isDetecting = true;
        _processCameraImage(image);
      }
    });
    setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      var input = await _preprocessImage(image);

      var output = List.filled(1 * 10 * 10 * 4, 0).reshape([1, 10, 10, 4]);
      _interpreter.run(input, output);

      _processDetectionResults(output);

      setState(() {});
    } catch (e) {
      print("Error during object detection: $e");
    } finally {
      isDetecting = false;
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(CameraImage image) async {
    var imgBytes = _convertYUV420ToRGB(image);
    img.Image imgImage = img.decodeImage(Uint8List.fromList(imgBytes))!;
    imgImage = img.copyResize(imgImage, width: 224, height: 224);

    List<List<List<List<double>>>> processedImage = [];
    for (int i = 0; i < imgImage.height; i++) {
      List<List<double>> row = [];
      for (int j = 0; j < imgImage.width; j++) {
        int pixel = imgImage.getPixel(j, i);
        double red = (img.getRed(pixel)) / 255.0;
        double green = (img.getGreen(pixel)) / 255.0;
        double blue = (img.getBlue(pixel)) / 255.0;
        row.add([red, green, blue]);
      }
      processedImage.add(row);
    }
    return processedImage;
  }

  List<int> _convertYUV420ToRGB(CameraImage image) {
    return [];
  }

  void _processDetectionResults(List<List<List<List<double>>>> output) {
    for (var detection in output) {
      double confidence = detection[0][0][0];
      if (confidence > 0.5) {
        double left = detection[0][1][0];
        double top = detection[0][2][0];
        double right = detection[0][3][0];
        double bottom = detection[0][4][0];
        
        print("Bounding Box: [$left, $top, $right, $bottom], Confidence: $confidence");
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-time Object Detection")),
      body: Stack(
        children: [
          _cameraController.value.isInitialized
              ? CameraPreview(_cameraController)
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
