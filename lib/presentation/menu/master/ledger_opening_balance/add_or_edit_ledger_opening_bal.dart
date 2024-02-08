
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

class AddOrEditLedgerOpeningBal extends StatefulWidget {
  final AddOrEditItemOpeningBalInterface mListener;
  final dynamic editproduct;

  const AddOrEditLedgerOpeningBal({super.key, required this.mListener, required this.editproduct});
  @override
  State<AddOrEditLedgerOpeningBal> createState() => _AddOrEditItemOpeningBalState();
}

class _AddOrEditItemOpeningBalState extends State<AddOrEditLedgerOpeningBal> {

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode() ;

  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();

  TextEditingController amount = TextEditingController();


  FocusNode searchFocus = FocusNode() ;
  //
  // _onChangeHandler(value ) {
  //   const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
  //   if (searchOnStoppedTyping != null) {
  //     setState(() => searchOnStoppedTyping.cancel()); // clear timer
  //   }
  //   setState(() => searchOnStoppedTyping =  Timer(duration, () => search(value)));
  // }
  //
  // search(value) {
  //   searchFocus.unfocus();
  //   isApiCall = false;
  //   page = 0;
  //   isPagination = true;
  //   callGetNoticeListingApi(page,value,true);
  //   print('hello world from search . the value is $value');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['itemName'];
        unit.text=widget.editproduct['unit'].toString();
        rate.text=widget.editproduct['rate'].toString();
        amount.text=widget.editproduct['amount'].toString();

      });
      await calculateRates();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*0.55,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight*.08,
                      child: const Center(
                        child: Text(
                            StringEn.LEDGER_DETAIL,
                            style: page_heading_textStyle
                        ),
                      ),
                    ),
                    getFieldTitleLayout(StringEn.LEDGER),
                    getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getFieldTitleLayout(StringEn.UNIT),


                    getUnitLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getRateAndAmount(SizeConfig.screenHeight,SizeConfig.screenWidth),


                    SizedBox(height: 10,)
                  ],
                ),
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



  Widget getRateAndAmount(double parentHeight, double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.RATE),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: rate,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.RATE,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Rate";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.AMOUNT),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: amount,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.AMOUNT,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Amt";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        )

      ],
    );
  }


  Widget getUnitLayout(double parentHeight, double parentWidth){
    return  Container(
      height: parentHeight * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CommonColor.TexField_COLOR,
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
        keyboardType: TextInputType.number,
        controller: unit,
        readOnly: true,
        decoration: textfield_decoration.copyWith(
            hintText: StringEn.UNIT,
            fillColor: CommonColor.TexField_COLOR
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Unit";
          }
          return null;
        }),
        onChanged: (value){

        },
        onTapOutside: (event) {

        },
      ),
    );
  }


  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Container(
      height: parentHeight * .055,
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
        textInputAction: TextInputAction.done,
        // autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.text,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText: "Item Name",
          prefixIcon: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
        ),
        // onChanged: _onChangeHandler,
      ),
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }


  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          // Scaffold.of(context).openDrawer();
        },
        child: Container(
          height: parentHeight*.065,
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
          ),
          child:const Center(
            child: Text(
              StringEn.CLOSE,
              textAlign: TextAlign.center,
              style: text_field_textStyle,
            ),
          ),
        ),
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
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringEn.CLOSE,
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
              "itemName":_textController.text,
              "unit":"kg",
              "rate":double.parse(rate.text),
              "amt":double.parse(amount.text),

            };
            if(widget.mListener!=null){

              widget.mListener.AddOrEditItemOpeningBalDetail(item);
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth*.45,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringEn.SAVE,
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

  calculateAmt(){
    // var amt=int.parse(quantity.text)*double.parse(rate.text);
    setState(() {
      amount.text=double.parse(rate.text).toStringAsFixed(2);
    });
  }


  calculateRates()async{
    if(rate.text!="") {
      await calculateAmt();
    }

  }

}

abstract class AddOrEditItemOpeningBalInterface{
  AddOrEditItemOpeningBalDetail(dynamic item);
}