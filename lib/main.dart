import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        "POST", Uri.parse("https://3afd-27-0-178-125.ngrok.io/upload"));

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
    // response.content
    // final responseData = await response.stream.bytesToString();
    http.Response res = await http.Response.fromStream(response);
// display it with the Image.memory widget
    // Image.memory(base64Decode(res.body));
    final resJson = jsonDecode(res.body);
    // File file = json.decode(res.body);
    // final decodedBytes = base64Decode(res.body);

    // final decodedImage = Image.memory(decodedBytes);
    print(resJson);

    // image = resJson['image'];
    print(res.body);
    String img = resJson['image'];
    //convert to bytes
    Uint8List bytes = base64.decode(img);
    Image finalimg = Image.memory(bytes);
    setState(() {});
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowImage(
                  img: finalimg,
                )));
  }

  File? styleimage;
  File? objectimage;
  File? image;
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
                          uploadImage(),
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
