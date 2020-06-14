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
    widget.onSelectedImage(_image);
  }

  Future getGalleryPicture() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
    widget.onSelectedImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: _image == null
              ? Center(
                  child: Text('Add Post', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                )
              : Image.file(_image),
          height: 500,
          width: 200,
          margin: EdgeInsets.all(2),
          
        ),
        Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(8),
              
              onPressed: () => getCameraPicture(),
              icon: Icon(Icons.photo_camera)
            ),
            IconButton(
              padding: EdgeInsets.all(8),
            
              onPressed: () => getGalleryPicture(),
              icon: Icon(Icons.photo),
            ),
          ],
        )
      ],
    );
  }
}
