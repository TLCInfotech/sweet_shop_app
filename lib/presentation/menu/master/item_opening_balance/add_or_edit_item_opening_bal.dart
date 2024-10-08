import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/serchable_drop_down_for_existing_list.dart';

class TestItem {
  String label;
  dynamic value;
  dynamic unit;
  dynamic rate;
  TestItem({required this.label, this.value,this.unit,this.rate});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],unit:"${json['unit']}",rate:"${json['rate']}");
  }
}
class AddOrEditItemOpeningBal extends StatefulWidget {
  final AddOrEditItemOpeningBalInterface mListener;
  final dynamic editproduct;
  final date;
  final readOnly;
  final existList;
  final franchiseeID;

  const AddOrEditItemOpeningBal({super.key, required this.mListener, required this.editproduct,required this.date, this.readOnly, this.existList, this.franchiseeID});
  @override
  State<AddOrEditItemOpeningBal> createState() => _AddOrEditItemOpeningBalState();
}

class _AddOrEditItemOpeningBalState extends State<AddOrEditItemOpeningBal> {
  bool isLoaderShow = false;

  var oldItemID=null;

  var itemsList = [];
  var selectedItemID =null;


  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode() ;
  final _itemKey = GlobalKey<FormFieldState>();

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode() ;
  final _quantityKey = GlobalKey<FormFieldState>();

  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();
  FocusNode rateFocus = FocusNode();
  final _rateKey = GlobalKey<FormFieldState>();

  TextEditingController amount = TextEditingController();
  FocusNode amountFocus = FocusNode();

  TextEditingController batchno = TextEditingController();

  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  final _formkey=GlobalKey<FormState>();

  var filteredItemsList = [];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();

  }
  List insertedList=[];
  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        oldItemID=widget.editproduct['Item_ID'];
        selectedItemID=widget.editproduct['Item_ID'];
        selectedItemName=widget.editproduct['Name']!=null?widget.editproduct['Name']:_textController.text;
        batchno.text=widget.editproduct['Batch_ID']!=null?widget.editproduct['Batch_ID']:batchno.text;
        unit.text = widget.editproduct['Unit'].toString();
        quantity.text=widget.editproduct['Quantity']!="" &&widget.editproduct['Quantity']!=null?double.parse(widget.editproduct['Quantity'].toString()).toStringAsFixed(2):"";
        rate.text  =widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
      });
      await calculateRates();
    }
    List list= widget.existList;
    setState(() {
      insertedList=list.map((e) =>e['Name'] ).toList();
    });
    print("###########");
    print(insertedList);


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
              height: SizeConfig.screenHeight*0.6 ,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight*.08,
                        child:  Center(
                          child: Text(
                              ApplicationLocalizations.of(context)!.translate("item_detail")!,
                              style: page_heading_textStyle
                          ),
                        ),
                      ),
                      // getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("item_name")!),

                      getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                      //getBatchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                      getItemQuantityLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                      getRateAndAmount(SizeConfig.screenHeight,SizeConfig.screenWidth),

                      SizedBox(height: 10,)
                    ],
                  ),
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

  /* widget for product rate layout */
  Widget getItemQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: true,
        txtkey: _quantityKey,
      suffix: Text("${unit.text}"),
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
        controller: quantity,
        focuscontroller: quantityFocus,
        focusnext: rateFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("quantity")!,
      callbackOnchage: (value)async {
        setState(() {
          rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
          // quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
          amount.text=amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
          quantity.text = value;
        });
        await calculateRates();
        _quantityKey.currentState!.validate();
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );


  }

  /* widget for product rate layout */
  Widget getBatchLayout(double parentHeight, double parentWidth) {
    print("newwwww    ${selectedItemName}");
    return SingleLineEditableTextFormField(
      validation: (value) {
        return null;
      },
      controller: batchno,
      focuscontroller: null,
      focusnext: null,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("batch_id")!,
      callbackOnchage: (value)async {
        setState(() {
          rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
          quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
          amount.text=amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
          batchno.text = value;
        });
        await calculateRates();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );


  }
  var amountedited=false;

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleLineEditableTextFormField(
          mandatory: true,
          txtkey: _rateKey,
        parentWidth: (parentWidth),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
          controller: rate,
          focuscontroller: rateFocus,
          focusnext: amountFocus,
        title: ApplicationLocalizations.of(context)!.translate("rate")!,
        callbackOnchage: (value) async {
          setState(() {
            // rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
            quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
            amount.text=amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
            rate.text = value;
            amountedited=false;
          });
          await calculateRates();
          _rateKey.currentState!.validate();
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),
      /*    SingleLineEditableTextFormField(
            parentWidth: (parentWidth),
            title: ApplicationLocalizations.of(context)!.translate("rate")!,
            controller: rate
        ),*/
      SingleLineEditableTextFormField(
        parentWidth: (parentWidth),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
          controller: amount,
          focuscontroller: amountFocus,
          focusnext: null,
        readOnly: widget.readOnly,

        title: ApplicationLocalizations.of(context)!.translate("amount")!,
        callbackOnchage: (value) async {
          print("########### $value");
          setState(() {
            rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
            quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
            // amount.text=amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
            amount.text = value;
            amountedited=true;
          });
          await calculateRates();
          // await calculateRates();
        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),
    ]);
  }


  var selectedItemName="";

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return SearchableDropdownWithExistingList(
      mandatory: true,
      txtkey: _itemKey,
      focusnext: quantityFocus,
      name: selectedItemName,
      come: widget.editproduct!=null?"disable":"",
      status: selectedItemName==""?"":"edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=${widget.franchiseeID}&Date=${widget.date}&",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      insertedList:insertedList,
      callback: (item) async {

          setState(() {
            if(item==""){
              insertedList=[];

            }
            selectedItemID = item['ID'].toString();
            selectedItemName = item['Name'].toString();
            unit.text = item['Unit']!=null?item['Unit']:null;
            rate.text = item['Rate'] != null?  item['Rate'].toString():"";
            PreviousRate=item['Rate'] != null?  item['Rate'].toString():"";
          });
          print("###############1 ${selectedItemName}");
        await calculateRates();
          _itemKey.currentState!.validate();
          _rateKey.currentState!.validate();
        print("############### ${rate.text}");
      },
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
          onTap: (){


            bool v=_itemKey.currentState!.validate();
            bool q=_quantityKey.currentState!.validate();
            bool r=_rateKey.currentState!.validate();
            if ( selectedItemID!=null&& v && q && r){
                var item = {};
                if (widget.editproduct != null) {
                  if(oldItemID!=selectedItemID){
                    item = {
                      "Seq_No": widget.editproduct['Seq_No'],
                      "Item_ID": oldItemID,
                      "New_Item_ID":selectedItemID,
                      "Name": selectedItemName,
                      "Store_ID": null,
                      "Batch_ID": batchno.text == "" ? null : batchno.text,
                      "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                      "Unit": unit.text!=""?unit.text:null,
                      "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                      "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                    };
                  }
                  else {
                    item = {
                      "Seq_No": widget.editproduct['Seq_No'],
                      "Item_ID": selectedItemID,
                      "Name": selectedItemName,
                      "Store_ID": null,
                      "Batch_ID": batchno.text == "" ? null : batchno.text,
                      "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                      "Unit": unit.text!=""?unit.text:null,
                      "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                      "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                    };
                  }
                }
                else {
                  item = {
                    "Item_ID": selectedItemID,
                    "Name": selectedItemName,
                    "Store_ID": null,
                    "Batch_ID": batchno.text,
                    "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                    "Unit": unit.text!=""?unit.text:null,
                    "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                    "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  };
                }
                if (widget.mListener != null) {
                  widget.mListener.AddOrEditItemOpeningBalDetail(
                      item);
                  Navigator.pop(context);
                }
              }else{
              var snackBar= SnackBar(content: Text(ApplicationLocalizations.of(context).translate("item_does_exist")));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  calculateAmt(){
      var amt = double.parse(quantity.text) * double.parse(rate.text);
      setState(() {
        amount.text = amt.toStringAsFixed(2);
      });
  }

  var PreviousRate="";

  calculateRates()async{
    // if (amountedited && quantity.text != "") {
    //   var amt = double.parse(amount.text) / double.parse(quantity.text);
    //
    //   setState(() {
    //     rate.text = amt.toStringAsFixed(2);
    //   });
    // }
    // if(quantity.text!=""&&rate.text!="") {
    //   // if (amountedited == false) {
    //     await calculateAmt();
    //   // }
    // }

    if(amountedited && quantity.text!=""){
      if(amount.text!="" && quantity.text!="") {
        var amt = double.parse(amount.text) / double.parse(quantity.text);

        setState(() {
          rate.text = amt.toStringAsFixed(2);
        });
      }
      if(amount.text==""){
        setState(() {
          rate.text=double.parse(PreviousRate).toStringAsFixed(2);
        });
      }
    }
    if (quantity.text != "" && rate.text != "") {
      if(amountedited==false) {
        await calculateAmt();
      }

    }
    if (quantity.text == "" || rate.text == "") {
        setState(() {
          amount.clear();
        });
    }
     // if (quantity.text == "" || amount.text == "") {
    //   setState(() {
    //     rate.clear();
    //   });
    // }
    if(quantity.text==""){
      setState(() {
        amount.clear();
      });
    }

  }

}


abstract class AddOrEditItemOpeningBalInterface{
  AddOrEditItemOpeningBalDetail(dynamic item);
}