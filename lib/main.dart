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
  getImage() async {
    final pickimage = await ImagePicker().getImage(source: ImageSource.gallery);
    selectedimg = File(pickimage!.path);
    setState(() {});
  }

  File? selectedimg;
  String? message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Style Transfer"),
      ),
      body: Column(
        children: [
          selectedimg == null
              ? Text("Please pick an image to upload")
              : Image.file(selectedimg!),
          TextButton.icon(
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
              )),
        ],
      ),
    );
  }
}
