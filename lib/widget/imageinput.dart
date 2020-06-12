import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;
  ImageInput(this.onSelectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;
  final picker = ImagePicker();
  Future getCameraPicture() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future getGalleryPicture() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
    widget.onSelectedImage();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: _image == null
              ? Center(
                  child: Text('Add Post'),
                )
              : Image.file(_image),
          height: 600,
          width: 300,
          margin: EdgeInsets.all(2),

        ),
        Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () => getCameraPicture(),
              child: Text('Take Picture'),
            ),
            RaisedButton(
              onPressed: () => getGalleryPicture(),
              child: Text('Select Picture'),
            ),
          ],
        )
      ],
    );
  }
}
