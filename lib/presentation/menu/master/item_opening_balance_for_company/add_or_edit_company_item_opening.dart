
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
class AddOrEditItemOpeningBalForCompany extends StatefulWidget {
  final AddOrEditItemOpeningBalForCompanyInterface mListener;
  final dynamic editproduct;

  const AddOrEditItemOpeningBalForCompany({super.key, required this.mListener, required this.editproduct});
  @override
  State<AddOrEditItemOpeningBalForCompany> createState() => _AddOrEditItemOpeningBalForCompanyState();
}

class _AddOrEditItemOpeningBalForCompanyState extends State<AddOrEditItemOpeningBalForCompany> {

  bool isLoaderShow = false;

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

  fetchShows (searchstring) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + ApiConstants().search_item+"?name=${searchstring}";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            if(data!=null) {
              var topShowsJson = (data) as List;
              setState(() {
                itemsList=  topShowsJson.map((show) => (show)).toList();
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
    await Future.delayed(Duration(milliseconds: 0));
    await fetchShows(searchstring) ;

    List _list = <dynamic>[];
    print(itemsList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in itemsList) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate']}));
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
        selectedItemID=widget.editproduct['Item_ID'];
        _textController.text=widget.editproduct['Item_Name'];
        batchno.text=widget.editproduct['Batch_ID'];
        unit.text=widget.editproduct['Unit'].toString();
        quantity.text=widget.editproduct['Quantity'].toString();
        rate.text=widget.editproduct['Rate'].toString();
        amount.text=widget.editproduct['Amount'].toString();
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
      title: ApplicationLocalizations.of(context)!.translate("quantity")!,
      callbackOnchage: (value)async {
        setState(() {
          quantity.text = value;
        });
        await calculateRates();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
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


  Widget getRateAndAmount(double parentHeight, double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title: ApplicationLocalizations.of(context)!.translate("rate")!,
            controller: rate
        ),
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title:ApplicationLocalizations.of(context)!.translate("amount")!,
            controller: amount
        ),


      ],
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
        child: TextFieldSearch(
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
                  item = {
                    "Seq_No": widget.editproduct['Seq_No'],
                    "Item_ID": selectedItemID,
                    "Item_Name": _textController.text,
                    "Store_ID": null,
                    "Batch_ID": batchno.text == "" ? null : batchno.text,
                    "Quantity": int.parse(quantity.text),
                    "Unit": unit.text,
                    "Rate": rate.text,
                    "Amount": amount.text
                  };
                }
                else {
                  item = {
                    "Item_ID": selectedItemID,
                    "Item_Name": _textController.text,
                    "Store_ID": null,
                    "Batch_ID": null,
                    "Quantity": int.parse(quantity.text),
                    "Unit": unit.text,
                    "Rate": rate.text,
                    "Amount": amount.text
                  };
                }
                if (widget.mListener != null) {
                  widget.mListener.AddOrEditItemOpeningBalForCompanyDetail(
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
    var amt=int.parse(quantity.text)*double.parse(rate.text);
    setState(() {
      amount.text=amt.toStringAsFixed(2);
    });
  }


  calculateRates()async{
    if(quantity.text!=""&&rate.text!="") {
      await calculateAmt();
    }

  }

}

abstract class AddOrEditItemOpeningBalForCompanyInterface{
  AddOrEditItemOpeningBalForCompanyDetail(dynamic item);
}