import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getStyleImage() async {
    final pickstyleimage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    styleimage = File(pickstyleimage!.path);
    final pickobjectimage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    objectimage = File(pickobjectimage!.path);
    setState(() {});
  }

  File? styleimage;
  File? objectimage;
  String? message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Style Transfer"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: styleimage == null
                  ? Text("Please pick a style image to upload")
                  : Image.file(styleimage!),
            ),
            Expanded(
              child: objectimage == null
                  ? Text("Please pick an object image to upload")
                  : Image.file(objectimage!),
            ),
            styleimage == null && objectimage == null
                ? TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                    onPressed: () => {},
                    icon: Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Upload Image",
                      style: TextStyle(color: Colors.white),
                    ))
                : TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                    onPressed: () => {
                          //call python api
                        },
                    icon: Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Mix Styles!",
                      style: TextStyle(color: Colors.white),
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getStyleImage();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
