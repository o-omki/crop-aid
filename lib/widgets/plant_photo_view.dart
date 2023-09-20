import "dart:io";
import "package:flutter/material.dart";

import "../styles.dart";

class PlantPhotoView extends StatelessWidget {
  final File? file;
  const PlantPhotoView({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      color: Colors.blueGrey,
      child: (file == null)
          ? _buildEmptyView()
          : Image.file(
              file!,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildEmptyView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image,
          size: 100,
        ),
        SizedBox(height: 20),
        Text(
          "No image selected",
          style: kAnalyzingTextStyle,
        ),
      ],
    );
  }
}
