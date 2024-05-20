import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/string_en.dart';

class GetSingleImage extends StatefulWidget{
  late final picImage;
  final height;
  final width;
  final readOnly;
  final Function(File?) callbackFile;
  
  GetSingleImage({required this.picImage, required this.callbackFile, required this.height,this.width, this.readOnly});

  @override
  State<GetSingleImage> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<GetSingleImage> with     SingleTickerProviderStateMixin,  ImagePickerDialogPostInterface,
    ImagePickerListener,
    ImagePickerDialogInterface {

  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  double opacityLevel = 1.0;
  Null bytes =null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _Controller);
    imagePicker.setListener(this);
    imagePicker.init(context);
    // if( widget.picImage == null) {
    //   setState(() {
    //     uint8List = Uint8List.fromList(widget.picImage);
    //   });
    // }
    getByts();
  }

  getByts()async{
    if(widget.picImage!=null) {
      Uint8List bytes = await imageFileToByte(widget.picImage);
      return bytes;
    }
  }

  @override
  userImage(File image, String comeFrom)async {
    // TODO: implement userImage
    Uint8List? bytes = await image?.readAsBytes();
    print(bytes);
    widget.callbackFile(image);
  }

  Future<Uint8List> imageFileToByte(File imageFile) async {
    // Read the image file as bytes
    Uint8List bytes = await imageFile.readAsBytes();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            widget.picImage == null
                ? Container(
              height: widget.height,
              width: widget.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/placeholder.png'), // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            )
                : Stack(
                  children: [
                    Container(
                                  height: widget.height,
                                  width: widget.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                        image: FileImage(widget.picImage!),
                        fit: BoxFit.cover,
                      )
                                  ),
                                  // child: ImageMemory(bytes: bytes),
                                ),

                    Positioned(
                      top: 0,
                      right: 15,
                      child: Container(
                        height: (SizeConfig.screenHeight) * .03,
                        width: (SizeConfig.screenHeight) * .03,
                        child:IconButton(onPressed: (){
                          widget.callbackFile(null);
                        },
                          icon: Icon(Icons.cancel,color: Colors.red,),
                        ),
                      ),
                    ),
                  ],
                ),
            GestureDetector(
              onTap: () {
    if(widget.readOnly==false){
    var snackBar = SnackBar(content: Text('user not have a edit rights'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
                if (mounted) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AnimatedOpacity(
                          opacity: opacityLevel,
                          duration: const Duration(seconds: 2),
                          child: ImagePickerDialogPost(
                            imagePicker,
                            _Controller,
                            context,
                            this,
                            isOpenFrom: '',
                          ),
                        );
                      },
                    );
                  });
                }}
              },
              child: Padding(
                padding: EdgeInsets.only(left: (SizeConfig.screenWidth) * .08),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: (SizeConfig.screenHeight) * .05,
                      width: (SizeConfig.screenHeight) * .05,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .white, // Change the color to your desired fill color
                      ),
                      /*     decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/edit_post.png'), // Replace with your image asset path
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),*/
                    ),


                    Container(
                        height: (SizeConfig.screenHeight) * .03,
                        width: (SizeConfig.screenHeight) * .03,
                        child: const Image(
                          image: AssetImage("assets/images/edit_post.png"),
                          fit: BoxFit.contain,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImageMemory extends StatelessWidget {
  const ImageMemory({
    super.key,
    required this.imageBytes,
  });

  final Uint8List imageBytes;


  @override
  Widget build(BuildContext context) {
    return Image.memory(imageBytes);
  }
}