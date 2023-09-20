import "package:flutter/material.dart";

class CropSelection extends StatelessWidget {
const CropSelection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crop Aid",
          // center the text
          textAlign: TextAlign.right,
          ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/plant_recogniser");
              },
              child: const Text("Mung Bean"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/plant_recogniser");
              },
              child: const Text("Mustard"),
            ),
          ],
        )
      )
    );
  }
}