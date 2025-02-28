// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart'; // For 3D rendering

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CameraScreen(cameras: cameras),
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   CameraScreen({required this.cameras});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   Interpreter? _interpreter;
//   bool _isModelLoading = true;
//   String? _detectedObject;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       print("Error initializing camera: $e");
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//       setState(() {
//         _isModelLoading = false;
//       });
//     } catch (e) {
//       print("Failed to load model: $e");
//     }
//   }

//   Future<void> _detectObjects() async {
//     if (_controller == null || !_controller!.value.isInitialized || _interpreter == null) return;

//     final image = await _controller!.takePicture();
//     var inputImage = await _preprocessImage(image.path);

//     // Adjust output shape based on your model
//     var output = List.filled(1 * 10 * 4, 0).reshape([1, 10, 4]);

//     _interpreter!.run(inputImage, output);

//     // Process output to get detected objects (Replace with actual logic)
//     setState(() {
//       _detectedObject = "sandakadapahana"; // Placeholder, replace with real detection output
//     });
//   }

//   Future<List<List<double>>> _preprocessImage(String imagePath) async {
//     // Placeholder for image preprocessing (resize, normalize, etc.)
//     List<List<double>> processedImage = List.generate(
//       224,
//       (i) => List.generate(
//         224 * 3, // Flattened channel dimension
//         (j) => 0.0, // Fill with zeros initially
//       ),
//     );
//     return Future.value(processedImage);
//   }

//   String _getGLBPath(String? detectedObject) {
//     Map<String, String> objectToGLB = {
//       "sandakadapahana": "assets/sandakadapahana.glb",
//       "muragala": "assets/muragala.glb",
//       "korawakgala": "assets/korawakgala.glb",
//       "wamanarupa": "assets/waman_rupa.glb",
//     };
//     return objectToGLB[detectedObject] ?? "assets/waman_rupa.glb";
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized || _isModelLoading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("Object Detection App")),
//       body: Column(
//         children: [
//           Expanded(
//             child: CameraPreview(_controller!),
//           ),
//           ElevatedButton(
//             onPressed: _detectObjects,
//             child: Text("Detect Object"),
//           ),
//           if (_detectedObject != null)
//             Expanded(
//               child: Flutter3DViewer(
//                 src: _getGLBPath(_detectedObject),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _interpreter?.close();
//     super.dispose();
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart'; // For 3D rendering
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CameraScreen(cameras: cameras),
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   CameraScreen({required this.cameras});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   Interpreter? _interpreter;
//   bool _isModelLoading = true;
//   String? _detectedObject;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       print("Error initializing camera: $e");
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//       setState(() {
//         _isModelLoading = false;
//       });
//     } catch (e) {
//       print("Failed to load model: $e");
//     }
//   }

//   Future<void> _detectObjects() async {
//     if (_controller == null || !_controller!.value.isInitialized || _interpreter == null) return;

//     final image = await _controller!.takePicture();
//     var inputImage = await _preprocessImage(image.path);

//     if (inputImage.isEmpty) {
//       print("Image preprocessing failed.");
//       return;
//     }

//     // Convert input image to proper format
//     var input = [inputImage]; // Wrap it in another list to match model input

//     // Define output shape (change according to your model)
//     var output = List.filled(1 * 10 * 4, 0.0).reshape([1, 10, 4]);

//     // Run the model
//     _interpreter!.run(input, output);

//     // Extract detection results (Update this logic based on your model's output format)
//     double highestConfidence = 0.0;
//     String? detectedClass;

//     for (var i = 0; i < 10; i++) {
//       double confidence = output[0][i][2]; // Assuming confidence score is stored at index 2
//       if (confidence > highestConfidence) {
//         highestConfidence = confidence;
//         detectedClass = _mapClassToLabel(output[0][i][0].toInt()); // Assuming class index is stored at 0
//       }
//     }

//     if (highestConfidence > 0.5) { // Confidence threshold
//       setState(() {
//         _detectedObject = detectedClass;
//       });
//     } else {
//       setState(() {
//         _detectedObject = "No object detected";
//       });
//     }

//     print("Model Output: $output");
//     print("Highest Confidence: $highestConfidence");
//     print("Detected Class: $detectedClass");
//   }

//   Future<List<List<List<double>>>> _preprocessImage(String imagePath) async {
//     File imageFile = File(imagePath);
//     Uint8List imageBytes = await imageFile.readAsBytes();

//     img.Image? image = img.decodeImage(imageBytes);
//     if (image == null) {
//       print("Error: Unable to decode image");
//       return [];
//     }

//     img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

//     List<List<List<double>>> inputImage = List.generate(
//       224,
//       (y) => List.generate(
//         224,
//         (x) {
//           img.Pixel pixel = resizedImage.getPixel(x, y);
//           return [
//             pixel.r.toDouble() / 255.0, // Normalize Red
//             pixel.g.toDouble() / 255.0, // Normalize Green
//             pixel.b.toDouble() / 255.0  // Normalize Blue
//           ];
//         },
//       ),
//     );

//     return Future.value(inputImage);
//   }

//   String _mapClassToLabel(int classIndex) {
//     Map<int, String> classLabels = {
//       0: "sandakadapahana",
//       1: "muragala",
//       2: "korawakgala",
//       3: "wamanarupa",
//     };
//     return classLabels[classIndex] ?? "Unknown";
//   }

//   String _getGLBPath(String? detectedObject) {
//     Map<String, String> objectToGLB = {
//       "sandakadapahana": "assets/sandakadapahana.glb",
//       "muragala": "assets/muragala.glb",
//       "korawakgala": "assets/korawakgala.glb",
//       "wamanarupa": "assets/waman_rupa.glb",
//     };
//     return objectToGLB[detectedObject] ?? "assets/waman_rupa.glb";
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized || _isModelLoading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("Object Detection App")),
//       body: Column(
//         children: [
//           Expanded(
//             child: CameraPreview(_controller!),
//           ),
//           ElevatedButton(
//             onPressed: _detectObjects,
//             child: Text("Detect Object"),
//           ),
//           if (_detectedObject != null)
//             Expanded(
//               child: Flutter3DViewer(
//                 src: _getGLBPath(_detectedObject),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _interpreter?.close();
//     super.dispose();
//   }
// }

//********************************************************
/*import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart'; // For 3D rendering
import 'package:image/image.dart' as img; // For image processing
import 'dart:io'; // Import this to use File

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(cameras: cameras),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Interpreter? _interpreter;
  bool _isModelLoading = true;
  String? _detectedObject;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    try {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      setState(() {
        _isModelLoading = false;
      });
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> _detectObjects() async {
    if (_controller == null || !_controller!.value.isInitialized || _interpreter == null) return;

    final image = await _controller!.takePicture();
    var inputImage = await _preprocessImage(image.path);

    // Adjust output shape based on your model
    var output = List.filled(1 * 10 * 4, 0).reshape([1, 10, 4]);

    _interpreter!.run(inputImage, output);

    // Process output to get detected objects (Replace with actual logic)
    setState(() {
      _detectedObject = "sandakadapahana"; // Placeholder, replace with real detection output
    });
  }

  Future<List<List<double>>> _preprocessImage(String imagePath) async {
    // Load image bytes
    final imageBytes = await File(imagePath).readAsBytes();

    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);

    // Resize the image to 224x224 (adjust size as required by your model)
    img.Image resizedImage = img.copyResize(image!, width: 224, height: 224);

    // Process the resized image into a 2D list of pixel values
    List<List<double>> processedImage = [];
    for (int y = 0; y < resizedImage.height; y++) {
      List<double> row = [];
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        row.add(pixel.toDouble());  // Convert pixel to double (you can normalize here)
      }
      processedImage.add(row);
    }
    return processedImage;
  }

  String _getGLBPath(String? detectedObject) {
    Map<String, String> objectToGLB = {
      "sandakadapahana": "assets/sandakadapahana.glb",
      "muragala": "assets/muragala.glb",
      "korawakgala": "assets/korawakgala.glb",
      "wamanarupa": "assets/waman_rupa.glb",
    };
    return objectToGLB[detectedObject] ?? "assets/waman_rupa.glb";
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized || _isModelLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Object Detection App")),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          ElevatedButton(
            onPressed: _detectObjects,
            child: Text("Detect Object"),
          ),
          if (_detectedObject != null)
            Expanded(
              child: Flutter3DViewer(
                src: _getGLBPath(_detectedObject),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}*/


// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'dart:typed_data';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late Interpreter _interpreter;

//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   // Load the TFLite model
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//       print("Model loaded successfully.");
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }

//   // Preprocess the image for model input
//   Future<List<List<List<double>>>> _preprocessImage(XFile imageFile) async {
//     final bytes = await imageFile.readAsBytes();
//     img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
//     image = img.copyResize(image, width: 224, height: 224); // Resize to 224x224

//     // Normalize pixel values to [0, 1]
//     List<List<List<double>>> processedImage = [];
//     for (int i = 0; i < image.height; i++) {
//       List<List<double>> row = [];
//       for (int j = 0; j < image.width; j++) {
//         img.Pixel pixel = image.getPixel(j, i);
//         double red = (img.getRed(pixel)) / 255.0;
//         double green = (img.getGreen(pixel)) / 255.0;
//         double blue = (img.getBlue(pixel)) / 255.0;
//         row.add([red, green, blue]);
//       }
//       processedImage.add(row);
//     }
//     return processedImage;
//   }

//   // Detect objects in the image
//   Future<void> _detectObjects(XFile imageFile) async {
//     try {
//       // Preprocess the image
//       var input = await _preprocessImage(imageFile);

//       // Run inference on the image
//       var output = List.filled(1 * 10 * 10 * 4, 0).reshape([1, 10, 10, 4]);

//       _interpreter.run(input, output);

//       // Process the output
//       _processDetectionResults(output);
//     } catch (e) {
//       print("Error during object detection: $e");
//     }
//   }

//   // Process the detection results
//   void _processDetectionResults(List<List<List<double>>> output) {
//     // Adjust based on your model's output
//     for (var detection in output) {
//       double confidence = detection[0][0]; // Assuming confidence is at index 0
//       if (confidence > 0.5) {
//         // Process bounding box or class info
//         print('Detected with confidence: $confidence');
//         // Draw bounding box or show results
//       }
//     }
//   }

//   // Take a picture and process it
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       await _detectObjects(pickedFile);
//     }
//   }

//   @override
//   void dispose() {
//     _interpreter.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Object Detection')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _takePicture,
//           child: Text('Detect Objects'),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'real_time_detection.dart'; // Import the real-time detection widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-Time Object Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RealTimeObjectDetection(), // Start the real-time detection widget
    );
  }
}

