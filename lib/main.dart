import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:style_transfer/mixed_image.dart';

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

  uploadImage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://bb0a-27-0-178-125.ngrok.io/upload"));

    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
      'styleimage',
      styleimage!.readAsBytes().asStream(),
      styleimage!.lengthSync(),
      filename: styleimage!.path.split("/").last,
    ));
    request.files.add(http.MultipartFile(
      'objectimage',
      objectimage!.readAsBytes().asStream(),
      objectimage!.lengthSync(),
      filename: objectimage!.path.split("/").last,
    ));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowImage()))
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
