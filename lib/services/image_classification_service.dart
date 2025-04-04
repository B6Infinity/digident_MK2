// filepath: /home/bravo6/Desktop/active_projects/DigiDent/MKI/Mobile_App/digident/lib/services/image_classification_service.dart

import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageClassificationService {
  final List<String> _labels = [
    "No Caries",
    "Intermediate Caries",
    "Advanced Caries",
  ];
  Interpreter? _interpreter;

  /// Whenever an instance of this class is created, it loads the model from assets.
  ImageClassificationService() {
    print("[LOG]: Loading TFLite model...");
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/cnn_model/tooth_classification_model.tflite',
      );
      print("[LOG]: TFLite model loaded successfully.");
    } catch (e) {
      throw Exception("Failed to load TFLite model: $e");
    }
  }

  Future<Map<String, dynamic>> classifyImage(Uint8List imageData) async {
    if (_interpreter == null) {
      throw Exception("Model is not loaded yet.");
    }

    // Preprocess the image
    final input = _preprocessImage(imageData);

    // Prepare input and output tensors
    // final inputShape = _interpreter!.getInputTensor(0).shape;
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final output = List.filled(
      outputShape[1],
      0.0,
    ).reshape([1, outputShape[1]]);

    // Run inference
    _interpreter!.run(input, output);

    // Get the predicted label
    final predictionsWithLabels = Map.fromIterables(_labels, output[0]);
    return predictionsWithLabels;
  }

  List<List<List<List<double>>>> _preprocessImage(Uint8List imageData) {
    final image = img.decodeImage(imageData);
    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    // Resize to model input size (224x224)
    final resizedImage = img.copyResize(image, width: 224, height: 224);
    // TODO: Figure out how to feed the panorama images to the model

    // Normalize and reshape to 4D tensor
    final input = List.generate(224, (y) {
      return List.generate(224, (x) {
        final pixel = resizedImage.getPixel(x, y);
        final r = pixel.rNormalized.toDouble();
        final g = pixel.gNormalized.toDouble();
        final b = pixel.bNormalized.toDouble();
        return [r, g, b]; // Shape: [224, 224, 3]
      });
    });

    return [input]; // returns [1, 224, 224, 3]
  }

  Future<void> dispose() async {
    _interpreter?.close();
  }
}
