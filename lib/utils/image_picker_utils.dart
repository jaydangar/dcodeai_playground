import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'const_utils.dart';

class ImagePickerUtils {
  BuildContext context;

  ImagePickerUtils({@required this.context});

  Future<File> _imgFromSource(ImageSource source) async {
    final _imagePicker = ImagePicker();
    PickedFile _pickedFile = await _imagePicker.getImage(source: source);

    if (_pickedFile != null) {
      return File(_pickedFile.path);
    }

    return null;
  }

  Future<File> showImagePickerOptions() async {
    File _file;

    return await showModalBottomSheet<File>(
        context: this.context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text(ConstUtils.gallery_option),
                      onTap: () async {
                        _file = await _imgFromSource(ImageSource.gallery);
                        Navigator.pop(
                          context,
                          _file,
                        );
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text(ConstUtils.camera_option),
                    onTap: () async {
                      _file = await _imgFromSource(ImageSource.camera);
                      Navigator.pop(
                        context,
                        _file,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
