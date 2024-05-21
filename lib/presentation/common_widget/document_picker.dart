import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/string_en.dart';

class PickDocument extends StatefulWidget{
  final title;
  final Function(String) callbackOnchage;
  late final documentFile;
  final Function(File?) callbackFile;
  final controller;
  final focuscontroller;
  final focusnext;
  final readOnly;

  PickDocument({required this.title,required this.callbackOnchage,required this.documentFile, required this.callbackFile,required this.controller,required this.focuscontroller,required this.focusnext, this.readOnly});

  @override
  State<PickDocument> createState() => _PickDocumentState();
}

class _PickDocumentState extends State<PickDocument> {
  
  final _fileFocus = FocusNode();

  final fileController = TextEditingController();

  getDocumentFile()async{
    File file=await CommonWidget.pickDocumentFromfile();
    widget.callbackFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: item_heading_textStyle,
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: (SizeConfig.screenHeight) * .055,
              width: (SizeConfig.screenWidth)*.65,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: TextFormField(
                readOnly: widget.readOnly!=false?false:true,
                maxLength: widget.title==ApplicationLocalizations.of(context)!.translate("adhar_number")!?12:widget.title==ApplicationLocalizations.of(context)!.translate("pan_number")!?10:
                widget.title==ApplicationLocalizations.of(context)!.translate("gst_number")!?15:100,
                keyboardType: widget.title==ApplicationLocalizations.of(context)!.translate("adhar_number")!?TextInputType.number:TextInputType.text,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left:  (SizeConfig.screenHeight) * .015, right:  (SizeConfig.screenWidth) * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText: widget.title,
                  hintStyle: hint_textfield_Style,
                ),
                focusNode:widget.focuscontroller,
                controller: widget.controller,
                onChanged: (value){
                  print(value);
                  widget.callbackOnchage(value);
                },
                onEditingComplete: () {
                  widget.focuscontroller.unfocus();
                  FocusScope.of(context).requestFocus(widget.focusnext);
                },
                style: text_field_textStyle,
              ),
            ),
            GestureDetector(
              onTap: (){
              if(widget.readOnly==false){
             }else{ getDocumentFile();}
              },
              child: Padding(
                padding:  EdgeInsets.only(right: (SizeConfig.screenWidth)*.0),
                child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.fileArrowUp,color: Colors.white,size: 20,),
                        Text(ApplicationLocalizations.of(context)!.translate("upload")!,style: subHeading_withBold)
                      ],
                    )
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        widget.documentFile!=null?
        Stack(
          children: [
            widget.documentFile!.uri.toString().contains(".pdf")?
            Container(
                height: 100,
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.filePdf,color: Colors.redAccent,),
                    Text(widget.documentFile!.uri.toString().split('/').last,style: item_heading_textStyle,),
                  ],
                )
            ): Container(
              height: 100,
              margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  image: DecorationImage(
                    image: FileImage(widget.documentFile!),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Positioned(
                right: 1,
                top: 1,
                child: IconButton(
                    onPressed: (){
                      if(widget.title==ApplicationLocalizations.of(context)!.translate("adhar_number")!){
                        widget.callbackFile(null);
                      }
                      else if(widget.title==ApplicationLocalizations.of(context)!.translate("pan_number")!){
                        setState(() {
                          widget.callbackFile(null);
                        });
                      }
                      else  if(widget.title==ApplicationLocalizations.of(context)!.translate("gst_number")!){
                        setState(() {
                          widget.callbackFile(null);
                        });
                      }
                    },
                    icon: Icon(Icons.remove_circle_sharp,color: Colors.red,)))
          ],
        ):Container()
      ],
    );
  }
}