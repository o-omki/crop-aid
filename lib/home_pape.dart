// import "package:camera/camera.dart";
// import "package:flutter/material.dart";
// import "package:tflite/tflite.dart";
// import "./main.dart";

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   CameraImage? cameraImage;
//   CameraController? cameraController;
//   String predictedDisease = "";

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     loadCamera();
//   }

//   loadCamera() {
//     cameraController = CameraController(cameras![0], ResolutionPreset.medium);
//     print("cameraController: $cameraController");
//     cameraController!.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         cameraController!.startImageStream((image) => {
//               cameraImage = image,
//               predictDisease(),
//             });
//       });
//     });
//   }

//   predictDisease() async {
//     if (cameraImage != null) {
//       var prediction = await Tflite.runModelOnFrame(
//         bytesList: cameraImage!.planes.map((plane) {
//           return plane.bytes;
//         }).toList(),
//         imageHeight: cameraImage!.height,
//         imageWidth: cameraImage!.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.1,
//         asynch: true,
//       );
//       prediction!.forEach((element) {
//         setState(() {
//           predictedDisease = element["label"];
//         });
//       });
//     }
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//         model: "assets/mung_mobilenetv3.tflite",
//         labels: "assets/mung_bean_labels.txt");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Crop Aid"),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: MediaQuery.of(context).size.width,
//               child: !cameraController!.value.isInitialized
//                   ? Container()
//                   : AspectRatio(
//                       aspectRatio: cameraController!.value.aspectRatio,
//                       child: CameraPreview(cameraController!),
//                     ),
//             ),
//           ),
//           Text(
//             predictedDisease,
//             style: const TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
