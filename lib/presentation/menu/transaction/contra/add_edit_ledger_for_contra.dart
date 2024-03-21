import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class AddOrEditLedgerForContra extends StatefulWidget {
  final AddOrEditLedgerForContraInterface mListener;
  final dynamic editproduct;

  const AddOrEditLedgerForContra({super.key, required this.mListener, required this.editproduct});

  @override
  State<AddOrEditLedgerForContra> createState() => _AddOrEditLedgerForContraState();
}

class _AddOrEditLedgerForContraState extends State<AddOrEditLedgerForContra>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode ledgerFocus = FocusNode() ;

  TextEditingController amount = TextEditingController();
  FocusNode amountFocus = FocusNode() ;

  TextEditingController narration = TextEditingController();
  FocusNode narrationFocus = FocusNode() ;

  FocusNode searchFocus = FocusNode() ;

  /* initialise the value*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  /* get the value layout*/
  setVal(){
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['ledgerName'];
        amount.text=widget.editproduct['amount'].toString();
        narration.text=widget.editproduct['narration'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*0.7,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.08,
                    child:  Center(
                      child: Text(
                          ApplicationLocalizations.of(context)!.translate("add_ledger")!,
                          style: page_heading_textStyle
                      ),
                    ),
                  ),
                  getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("ledger_name")!),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),


                  getILedgerAmountyLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),


                  getLedgerNarrationLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ),        ],
      ),
    );
  }



  /* widget for narration layout */
  Widget getLedgerNarrationLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(

      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.NARRATION;
        }
        return null;
      },
      controller: narration,
      focuscontroller: null,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("narration")!,
      callbackOnchage: (value)async {
        setState(() {
          narration.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z ]')),
    );

  }

  /* widget for ledger amount layout */
  Widget getILedgerAmountyLayout(double parentHeight, double parentWidth) {
    return     SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.AMOUNT;
        }
        return null;
      },
      controller: amount,
      focuscontroller: null,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("amount")!,
      callbackOnchage: (value)async {
        setState(() {
          amount.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 \.]')),
    );
  }

  /* widget for ledger search layout */
  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Container(
      height: parentHeight * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText:  ApplicationLocalizations.of(context)!.translate("ledger_name")!,
          prefixIcon: Container(
              width: 50,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: const FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
        ),
        // onChanged: _onChangeHandler,
      ),
    );
  }

  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }

  /* Widget for Buttons Layout0 */
  Widget getAddForButtonsLayout(double parentHeight,double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height:parentHeight*.05,
            width: parentWidth*.45,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("close")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            var item={
             "id":widget.editproduct!=null?widget.editproduct['id']:"",
              "ledgerName":_textController.text,
              "currentBal":100,
              "amount":double.parse(amount.text),
              "narration":narration.text,
            };
            if(widget.mListener!=null){

              widget.mListener.AddOrEditLedgerForContraDetail(item);
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth*.45,
            decoration: const BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}


abstract class AddOrEditLedgerForContraInterface{
  AddOrEditLedgerForContraDetail(dynamic item);
}