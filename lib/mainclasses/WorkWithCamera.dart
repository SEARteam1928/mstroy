import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkWithCamera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserOptionsState();
  }
}

class UserOptionsState extends State<WorkWithCamera> {
//save the result of gallery file
  File galleryFile;

//save the result of camera file
  File cameraFile;

  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        //Max size of picture
        //  maxHeight: 50.0,
        //  maxWidth: 50.0,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {});
    }

    //display image selected from camera
    imageSelectorCamera() async {
      cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        //Max size of picture
        //  maxHeight: 50.0,
        //  maxWidth: 50.0,
      );
      print("You selected camera image : " + cameraFile.path);
      setState(() {});
    }

    return new Builder(
      builder: (BuildContext context) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new RaisedButton(
              child: new Text('Галерея'),
              onPressed: imageSelectorGallery,
            ),
            new RaisedButton(
              child: new Text('Камера'),
              onPressed: imageSelectorCamera,
            ),
            displaySelectedFile(galleryFile),
            displaySelectedFile(cameraFile)
          ],
        );
      },
    );
  }

  Widget displaySelectedFile(File file) {
    return new ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
      child: SizedBox(
        child: file == null ? null : new Image.file(file),
      ),
    );
  }
}
