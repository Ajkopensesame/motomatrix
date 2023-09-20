import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class MachineLearningService {
  // Path to the trained model file.
  final String _modelPath;
  late tfl.Interpreter _interpreter;

  MachineLearningService(this._modelPath);

  // Load the TFLite model into memory.
  Future<void> loadModel() async {
    _interpreter = await tfl.Interpreter.fromAsset(_modelPath);
  }

  // Unload the TFLite model from memory.
  void unloadModel() {
    _interpreter.close();
  }

  // Predict the results based on single input and output.
  List<dynamic> predictSingleInput(List<dynamic> input) {
    List<double> output = List.filled(input.length, 0);
    _interpreter.run(input, output);
    return output;
  }

  // Predict the results based on multiple inputs and outputs.
  Map<int, Object> predictMultipleInputs(List<List<dynamic>> inputs, int numberOfOutputs) {
    List<double> output0 = List.filled(numberOfOutputs, 0);
    Map<int, Object> outputs = {0: output0};

    _interpreter.runForMultipleInputs(inputs, outputs);
    return outputs;
  }
}

