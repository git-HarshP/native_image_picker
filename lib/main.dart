import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_image_picker/image_picker_channel.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native image picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Image Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    permission();

    super.initState();
  }

  void permission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  final ImagePicker _imagePicker = ImagePickerChannel();
  File _imageFile;

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      _imagePicker.pickImage(
          imageSource: imageSource,
          onResult: (String path) {
            setState(() {
              _imageFile = File(path);
            });
          });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile,
        fit: BoxFit.contain,
      );
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: _buildImage())),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return ConstrainedBox(
        constraints: BoxConstraints.expand(height: 64.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // _buildActionButton(
              //   key: Key('retake'),
              //   text: 'Photos',
              //   onPressed: () => captureImage(ImageSource.photos),
              // ),
              _buildActionButton(
                key: Key('upload'),
                text: 'Camera',
                onPressed: () => captureImage(ImageSource.camera),
              ),
            ]));
  }

  Widget _buildActionButton({Key key, String text, Function onPressed}) {
    return Expanded(
      child: TextButton(
          key: key,
          child: Text(text, style: TextStyle(fontSize: 20.0)),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(),
          ),
          onPressed: onPressed),
    );
  }
}
