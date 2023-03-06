import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final imagePicker = ImagePicker();
  XFile? _photo;

  void _pickImage() {
    imagePicker
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    )
        .then((photo) {
      if (photo != null) {
        setState(() {
          _photo = photo;
        });
        widget.imagePickFn(File(_photo!.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 52,
          backgroundColor: Colors.pink,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _photo != null
                ? FileImage(
                    File(_photo!.path),
                  )
                : null,
            backgroundColor: Colors.white,
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
