import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog? imagePicker;
  late AnimationController _controller;
  ImagePickerListener _listener;
  late ImagePickerDialogInterface _mListener;

  ImagePickerHandler(this._listener,this._controller);

  late ImagePicker _picker = ImagePicker();

  void setListener(ImagePickerDialogInterface listener) {
    _mListener = listener;
  }


  openCamera(String comeFrom) async {
    imagePicker?.dismissDialog();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (imageFile != null) {
      _listener.userImage(File(imageFile.path), comeFrom);
    }
  }

  openGallery(String comeFrom) async {
    imagePicker?.dismissDialog();
    XFile? imageFile;

    imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      _listener.userImage(File(imageFile.path), comeFrom);
    }
  }
  openVideoGallery(String comeFrom) async {
    imagePicker?.dismissDialog();
    XFile? imageFile;

    imageFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      _listener.userImage(File(imageFile.path), comeFrom);
    }
  }

  void init(BuildContext context) {
    imagePicker = ImagePickerDialog(
      this,
      _controller,
      _mListener,
      context,
      "",
      "",
    );
    imagePicker?.initState();
  }

  showDialog(BuildContext context) {
    imagePicker?.getImage(context);
  }

  showBannerDialog(BuildContext context) {
    imagePicker?.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File image, String comeFrom);
}
