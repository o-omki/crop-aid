import "dart:io";

import "package:flutter/material.dart";
import "package:image/image.dart" as img;
import "package:image_picker/image_picker.dart";
import "../classifier.dart";
import "../styles.dart";
import "./plant_photo_view.dart";

const _labelsFilePath = "assets/mung_bean_labels.txt";
const _modelFilePath = "new_mustard_mobilenetv3.tflite";

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser({super.key});

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = "";
  double _plantConfidence = 0.0;

  late Classifier? _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      "Loading classifier with "
      "labels file: $_labelsFilePath, "
      "model file: $_modelFilePath",
    );

    final classifier = await Classifier.loadWith(
      labelsFilePath: _labelsFilePath,
      modelFilePath: _modelFilePath,
    );
    _classifier = classifier;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: _buildTitle(),
          ),
          const SizedBox(height: 20.0),
          _buildPhotoView(),
          const SizedBox(height: 110.0),
          _buildResultView(),
          const Spacer(flex: 5),
          _buildPickPhotoButton(
            title: "Pick a photo",
            source: ImageSource.camera,
          ),
          _buildPickPhotoButton(
            title: "Pick from gallery",
            source: ImageSource.gallery,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPhotoView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text(
      "Analyzing Image...",
      style: kAnalyzingTextStyle,
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Mustard Disease Recogniser",
      style: kTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: kColorBrown,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: kButtonFont,
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
              color: kColorLightYellow,
            ),
          ),
        ),
      ),
    );
  }

  void _setAnalyzing(bool isAnalyzing) {
    setState(() {
      (_isAnalyzing = isAnalyzing);
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final selectedFile = await picker.pickImage(source: source);

    if (selectedFile == null) {
      return;
    }

    final imageFile = File(selectedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });
    // _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    final resultCategory = _classifier!.predict(imageInput);
    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;

    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _plantConfidence = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = "";

    if (_resultStatus == _ResultStatus.notFound) {
      title = "Failed to recognize the disease";
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = "";
    }

    var accuracyLabel = "";
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel =
          "Accuracy: ${(_plantConfidence * 100).toStringAsFixed(2)}%";
    }

    return Column(
      children: [
        Text(
          title, 
          style: kResultTextStyle,
        ),
        const SizedBox(height: 10.0),
        Text(
          accuracyLabel,
          style: kResultRatingTextStyle,
        ),
      ],
    );
  }
}
