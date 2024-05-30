
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_diable_textformfield.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

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

  const AddOrEditItemOpeningBal({super.key, required this.mListener, required this.editproduct,required this.date, this.readOnly});
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

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode() ;

  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();

  TextEditingController amount = TextEditingController();

  TextEditingController batchno = TextEditingController();

  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  final _formkey=GlobalKey<FormState>();

  var filteredItemsList = [];


  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&PartyID=null&Date=${widget.date}";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            if(data!=null) {
              var topShowsJson = (data) as List;
              setState(() {
                itemsList=  topShowsJson.map((show) => (show)).toList();
                filteredItemsList=topShowsJson.map((show) => (show)).toList();
              });
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);
            return [];
            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);
            return [];

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            return [];
            // widget.mListener.loaderShow(false);
          });

    });
  }

  Future<List> fetchSimpleData(searchstring) async {
    print(searchstring);
    List<dynamic> _list = [];
    List<dynamic> results = [];
    if (searchstring.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = filteredItemsList;
    } else {

      results = filteredItemsList
          .where((user) =>
          user["Name"]
              .toLowerCase()
              .contains(searchstring.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      itemsList = results;
    });

    print(itemsList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in filteredItemsList) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
    }
    return _list;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        oldItemID=widget.editproduct['Item_ID'];
        selectedItemID=widget.editproduct['Item_ID'];
        selectedItemName=widget.editproduct['Name']!=null?widget.editproduct['Name']:_textController.text;
        batchno.text=widget.editproduct['Batch_ID']!=null?widget.editproduct['Batch_ID']:batchno.text;
        unit.text=widget.editproduct['Unit'].toString();
        quantity.text=widget.editproduct['Quantity'].toString();
        rate.text =  widget.editproduct['Rate']==null?"0": widget.editproduct['Rate'].toString();
        amount.text=widget.editproduct['Amount'].toString();
      });
      await calculateRates();
    }
    await fetchItems();

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
                      getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("item_name")!),

                      getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                      getBatchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
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
      suffix: Text("${unit.text}"),
      validation: (value) {
        if (value!.isEmpty) {
          return  ApplicationLocalizations.of(context)!.translate("enter")! + " "+ApplicationLocalizations.of(context)!.translate("quantity")!;
        }
        return null;
      },
      controller: quantity,
      focuscontroller: null,
      focusnext: null,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("quantity")!,
      callbackOnchage: (value)async {
        setState(() {
          quantity.text = value;
        });
        await calculateRates();
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ./]')),
    );


  }

  /* widget for product rate layout */
  Widget getBatchLayout(double parentHeight, double parentWidth) {
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
        parentWidth: (parentWidth),
        validation: (value) {
          if (value!.isEmpty) {
            return StringEn.ENTER + StringEn.QUANTITY;
          }
          return null;
        },
        controller: rate,
        focuscontroller: null,
        readOnly: widget.readOnly,
        focusnext: null,
        title: ApplicationLocalizations.of(context)!.translate("rate")!,
        callbackOnchage: (value) async {
          setState(() {
            rate.text = value;
            amountedited=false;
          });
          await calculateRates();
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ./]')),
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
            return StringEn.ENTER + StringEn.QUANTITY;
          }
          return null;
        },
        controller: amount,
        readOnly: widget.readOnly,
        focuscontroller: null,
        focusnext: null,
        title: ApplicationLocalizations.of(context)!.translate("amount")!,
        callbackOnchage: (value) async {
          print("########### $value");
          setState(() {
            amount.text = value;
            amountedited=true;
          });
          // await calculateRates();
          // await calculateRates();
        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ./]')),
      ),
      /* GetDisableTextFormField(
          parentWidth: (parentWidth),
          title: ApplicationLocalizations.of(context)!.translate("amount")!,
          controller: amount)*/
    ]);
  }

  //
  // Widget getRateAndAmount(double parentHeight, double parentWidth){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       GetDisableTextFormField(
  //           parentWidth: (parentWidth),
  //           title: ApplicationLocalizations.of(context)!.translate("rate")!,
  //           controller: rate
  //       ),
  //       GetDisableTextFormField(
  //           parentWidth: (parentWidth),
  //           title:ApplicationLocalizations.of(context)!.translate("amount")!,
  //           controller: amount
  //       ),
  //
  //
  //     ],
  //   );
  // }

  var selectedItemName="";

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return SearchableDropdownWithObject(
      name: selectedItemName,
      status:  "edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=null&Date=${widget.date}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item)async{
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['ID'].toString();
          selectedItemName=item['Name'].toString();
          unit.text=item['Unit'];
          rate.text =item['Rate']==null?"0":item['Rate'].toString();
        });
        await calculateRates();
      },

    );

      Container(
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
        child: TextFieldSearch(
          minStringLength: 0,
            label: 'Item',
            controller: _textController,
            decoration: textfield_decoration.copyWith(
              hintText: ApplicationLocalizations.of(context)!.translate("item_name")!,
              prefixIcon: Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
            ),
            textStyle: item_regular_textStyle,
            getSelectedValue: (v) {
              setState(() {
                selectedItemID = v.value;
                unit.text=v.unit;
                rate.text=v.rate;
                itemsList = [];
              });
            },
            future: () {
              if (_textController.text != "")
                return fetchSimpleData(
                    _textController.text.trim());
            })

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
            if(selectedItemID==null){
              var snackBar = const SnackBar(content: Text('Select Item Fisrt'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              var isValid = _formkey.currentState?.validate();

              print(isValid);

              if (isValid == true && selectedItemID != null) {
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
                      "Quantity": double.parse(quantity.text),
                      "Unit": unit.text,
                      "Rate": rate.text,
                      "Amount": amount.text
                    };
                  }
                  else {
                    item = {
                      "Seq_No": widget.editproduct['Seq_No'],
                      "Item_ID": selectedItemID,
                      "Name": selectedItemName,
                      "Store_ID": null,
                      "Batch_ID": batchno.text == "" ? null : batchno.text,
                      "Quantity": double.parse(quantity.text),
                      "Unit": unit.text,
                      "Rate": rate.text,
                      "Amount": amount.text
                    };
                  }
                }
                else {
                  item = {
                    "Item_ID": selectedItemID,
                    "Name": selectedItemName,
                    "Store_ID": null,
                    "Batch_ID": batchno.text,
                    "Quantity": double.parse(quantity.text),
                    "Unit": unit.text,
                    "Rate": rate.text,
                    "Amount": amount.text
                  };
                }
                if (widget.mListener != null) {
                  widget.mListener.AddOrEditItemOpeningBalDetail(
                      item);
                  Navigator.pop(context);
                }
              }
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
    var amt=double.parse(quantity.text)*double.parse(rate.text);
    setState(() {
      amount.text=amt.toStringAsFixed(2);
    });
  }


  calculateRates()async{
    if (amountedited && quantity.text != "") {
      var amt = double.parse(amount.text) / double.parse(quantity.text);

      setState(() {
        rate.text = amt.toStringAsFixed(2);
      });
    }
    if(quantity.text!=""&&rate.text!="") {
      // if (amountedited == false) {
        await calculateAmt();
      // }
    }

  }

}


abstract class AddOrEditItemOpeningBalInterface{
  AddOrEditItemOpeningBalDetail(dynamic item);
}