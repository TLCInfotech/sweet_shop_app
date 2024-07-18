import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
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
class AddOrEditItemOpeningBalForCompany extends StatefulWidget {
  final AddOrEditItemOpeningBalForCompanyInterface mListener;
  final dynamic editproduct;
  final date;
  final readOnly;
  final existList;

  const AddOrEditItemOpeningBalForCompany({super.key, required this.mListener, required this.editproduct, this.date, this.readOnly, this.existList});
  @override
  State<AddOrEditItemOpeningBalForCompany> createState() => _AddOrEditItemOpeningBalForCompanyState();
}

class _AddOrEditItemOpeningBalForCompanyState extends State<AddOrEditItemOpeningBalForCompany> {

  bool isLoaderShow = false;

  var itemsList = [];
  var selectedItemID =null;
  
  var oldItemID=null;


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


  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().item_list}?Company_ID=$companyId&PartyID=null&Date=${widget.date}";
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
    print("rfkjfrjfr");
  }
  List insertedList=[];
  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        oldItemID=widget.editproduct['Item_ID'];
        selectedItemID=widget.editproduct['Item_ID']!=null?widget.editproduct['Item_ID']:"";
        selectedItemName=widget.editproduct['Item_Name']!=null?widget.editproduct['Item_Name']:"";
        batchno.text=widget.editproduct['Batch_ID']!=null?widget.editproduct['Batch_ID']:batchno.text;
        unit.text=widget.editproduct['Unit'].toString();
        quantity.text=widget.editproduct['Quantity']!="" &&widget.editproduct['Quantity']!=null?double.parse(widget.editproduct['Quantity'].toString()).toStringAsFixed(2):"";
        rate.text  =widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        previousRate=widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";

      });

      await fetchItems();
      await calculateRates();
    }
    List list= widget.existList;
    setState(() {
      insertedList=list.map((e) =>e['Item_Name'] ).toList();
    });
    print("###########");
    print(insertedList);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
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
          return  "";
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
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );


  }

  /* widget for product rate layout */
  Widget getBatchLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {

        return null;
      },
      controller: batchno,
      readOnly: widget.readOnly,
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
        readOnly: widget.readOnly,

        title: ApplicationLocalizations.of(context)!.translate("rate")!,
        callbackOnchage: (value) async {
          setState(() {
            quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
            amount.text=amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
            rate.text = value;
            previousRate=value;
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
            return StringEn.ENTER + StringEn.QUANTITY;
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
      /* GetDisableTextFormField(
          parentWidth: (parentWidth),
          title: ApplicationLocalizations.of(context)!.translate("amount")!,
          controller: amount)*/
    ]);
  }

  var selectedItemName="";

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return SearchableDropdownWithExistingList(
      mandatory: true,
      txtkey: _itemKey,
      name: selectedItemName,
      focusnext: quantityFocus,
      focuscontroller: itemFocus,
      come: widget.editproduct!=null?"disable":"",
      status: selectedItemName==""?"":"edit",
      apiUrl:"${ApiConstants().item_list}?Date=${widget.date}&",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      insertedList:insertedList,
      callback: (item) async {

        if(insertedList.contains(item['Name'])){
          CommonWidget.errorDialog(context,"Already Exist");
          setState(() {
            selectedItemName="";
            selectedItemID="";
          });
        }
        else {
          setState(() {
            selectedItemID = item['ID'].toString();
            selectedItemName=item['Name'].toString();
            unit.text = item['Unit']!=null?item['Unit']:null;
            rate.text = item['Rate'] == null? "":item['Rate'].toString();
            previousRate=item['Rate'] == null? "" : item['Rate'].toString();
          });
        }
        print("########### ${item['Rate']}");
        print("########### ${rate.text}");

        await calculateRates();
        _itemKey.currentState!.validate();
        _rateKey.currentState!.validate();
        print("########### ${rate.text}");

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
    return widget.readOnly==false? GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onDoubleTap: () {},
      child: Container(
        height:parentHeight*.05,
        width: parentWidth*.90,
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
    ):Row(
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
            if (selectedItemID!=null && v && q && r) {
                var item = {};
                if (widget.editproduct != null) {
                  if( widget.editproduct['Seq_No']!=null){
                    item = {
                      "Seq_No": widget.editproduct['Seq_No'],
                      "Item_ID": oldItemID,
                      "New_Item_ID":selectedItemID,
                      "Item_Name":selectedItemName,
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
                      "Item_Name": selectedItemName,
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
                    "Item_Name": selectedItemName,
                    "Store_ID": null,
                    "Batch_ID": null,
                    "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                    "Unit": unit.text!=""?unit.text:null,
                    "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                    "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  };
                }
                if (widget.mListener != null) {
                  widget.mListener.AddOrEditItemOpeningBalForCompanyDetail(
                      item);
                  Navigator.pop(context);
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
  var previousRate="";


  calculateRates()async{
    // if (amountedited && quantity.text != "") {
    //   var amt = double.parse(amount.text) / double.parse(quantity.text);
    //
    //   setState(() {
    //     rate.text = amt.toStringAsFixed(2);
    //   });
    // }
    // if(quantity.text!=""&&rate.text!="") {
    //   if (amountedited == false) {
    //     await calculateAmt();
    //   }
    //  }

     if(amountedited && quantity.text!=""){
      if(amount.text!="" && quantity.text!="") {
        var amt = double.parse(amount.text) / double.parse(quantity.text);

        setState(() {
          rate.text = amt.toStringAsFixed(2);
        });
      }
      if(amount.text==""){
        setState(() {
          rate.text=double.parse(previousRate).toStringAsFixed(2);
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

abstract class AddOrEditItemOpeningBalForCompanyInterface{
  AddOrEditItemOpeningBalForCompanyDetail(dynamic item);
}