
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_diable_textformfield.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class TestItem {
  String label;
  dynamic value;
  dynamic unit;
  dynamic gst;
  TestItem({required this.label, this.value,this.unit,this.gst});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],unit:"${json['unit']}",gst:"${json['gst']}");
  }
}

class AddProductPurchaseRate extends StatefulWidget {
  final AddProductPurchaseRateInterface mListener;
  final dynamic editproduct;
  final date;
  final id;

  const AddProductPurchaseRate({super.key, required this.mListener, required this.editproduct, this.date,this.id});

  @override
  State<AddProductPurchaseRate> createState() => _AddProductPurchaseRateState();
}

class _AddProductPurchaseRateState extends State<AddProductPurchaseRate>{

  bool isLoaderShow = false;
  var oldItemID=null;
  var selectedItemID =null;
  var selectedItemName="";

  TextEditingController _textController = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController net = TextEditingController();
  TextEditingController gstAmt = TextEditingController();
  String unit="";

  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  final _formkey1=GlobalKey<FormState>();

  // fetchShows (searchstring) async {
  //   String companyId = await AppPreferences.getCompanyId();
  //   String sessionToken = await AppPreferences.getSessionToken();
  //   String baseurl=await AppPreferences.getDomainLink();
  //   await AppPreferences.getDeviceId().then((deviceId) {
  //     TokenRequestModel model = TokenRequestModel(
  //       token: sessionToken,
  //     );
  //     String apiUrl = baseurl + ApiConstants().item_list+"?Company_ID=$companyId&name=${searchstring}&Date=${widget.date}";
  //     apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
  //         onSuccess:(data)async{
  //           if(data!=null) {
  //             var topShowsJson = (data) as List;
  //             setState(() {
  //               itemsList=  topShowsJson.map((show) => (show)).toList();
  //             });
  //           }
  //         }, onFailure: (error) {
  //           CommonWidget.errorDialog(context, error);
  //           return [];
  //           // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
  //           //  widget.mListener.loaderShow(false);
  //           //  Navigator.of(context, rootNavigator: true).pop();
  //         }, onException: (e) {
  //           CommonWidget.errorDialog(context, e);
  //           return [];
  //
  //         },sessionExpire: (e) {
  //           CommonWidget.gotoLoginScreen(context);
  //           return [];
  //           // widget.mListener.loaderShow(false);
  //         });
  //
  //   });
  // }
  //
  // Future<List> fetchSimpleData(searchstring) async {
  //   await Future.delayed(const Duration(milliseconds: 0));
  //   await fetchShows(searchstring) ;
  //
  //   List _list = <dynamic>[];
  //   print(itemsList);
  //   //  for (var ele in data) _list.add(ele['TestName'].toString());
  //   for (var ele in itemsList) {
  //     _list.add(new TestItem.fromJson(
  //         {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"gst":ele['GST_Rate']}));
  //   }
  //   return _list;
  // }

  var itemsList = [];
  var filteredItemsList = [];


  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&PartyID=${widget.id}&Date=${widget.date}";
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
        unit=widget.editproduct['Unit'];
        selectedItemName=widget.editproduct['Name']!=null?widget.editproduct['Name']:null;
        _textController.text=widget.editproduct['Name'];
        rate.text=widget.editproduct['Rate'].toString();
        gst.text=widget.editproduct['GST'].toString();
        net.text=widget.editproduct['Net_Rate'].toString();
        gstAmt.text=widget.editproduct['ID']!=null?widget.editproduct['GSt_Amount'].toString():widget.editproduct['GST_Amount'].toString();
      });

    }
    await fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Form(
        key: _formkey1,
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
                      child: Center(
                        child: Text(
                            ApplicationLocalizations.of(context)!.translate("add_item")!,
                            style: page_heading_textStyle
                        ),
                      ),
                    ),
                    getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("item")!,    ),
                    getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getProductRateLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getProductGSTLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getGstAmountLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getProductNetLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
              child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  calculateNetAmt(){

    print("HE");
    if(rate.text!="" && gst.text!=""){
      var netAmt=double.parse(rate.text)+((double.parse(rate.text)*(double.parse(gst.text))) / 100);
      print(netAmt);
      setState(() {
        net.text=(netAmt.toStringAsFixed(2)).toString();
      });
    }
    else{
      net.clear();
    }
  }

  calculateOriginalAmt(){
    if(net.text!="" && gst.text!=""){
      var gstamt =double.parse(net.text) - (double.parse(net.text) / (1 + (double.parse(gst.text)/100)));
      var originalAmt = double.parse(net.text)- gstamt;

      setState(() {
        rate.text=(originalAmt.toStringAsFixed(2)).toString();
      });
    }
    else{
      net.clear();
    }
  }


  /* widget for product net layout */
  Widget getProductNetLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
      controller: net,
      title:     ApplicationLocalizations.of(context)!.translate("net_rate")!,
    );


  }

  /* widget for gst amount layout */
  Widget getGstAmountLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
      controller: gstAmt,
      title:     ApplicationLocalizations.of(context)!.translate("gst_amount")!,
    );


  }

  /* widget for product gst layout */
  Widget getProductGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      suffix:const Text("%"),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("gst_percent")!;
        }
        return null;
      },
      controller: gst,
      focuscontroller: null,
      focusnext: null,
      title:     ApplicationLocalizations.of(context)!.translate("gst_percent")!,
      callbackOnchage: (value) async{
        print("here");
        setState(() {
          gst.text = value;
        });
        await calculateNetAmt();
        await calculateOriginalAmt();
        await calculateGstAmt();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 $.]')),
    );


  }
  calculateGstAmt(){
    if(rate.text!="" && gst.text!="") {
      var gstAmtt = double.parse(rate.text) * (double.parse(gst.text) / 100);
      setState(() {
        gstAmt.text = gstAmtt.toStringAsFixed(2).toString();
      });
    }
  }

  /* widget for product rate layout */
  Widget getProductRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(

      validation: (value) {
        if (value!.isEmpty) {
          return  ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("purchase_rate")!;
        }
        return null;
      },
      controller: rate,
      focuscontroller: null,
      focusnext: null,
      title:   ApplicationLocalizations.of(context)!.translate("purchase_rate")!,
      callbackOnchage: (value)async {
        print("#");
        setState(() {
          rate.text = value;
        });
        await calculateNetAmt();
        await calculateGstAmt();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 $.]')),
    );

  }

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return  SearchableDropdownWithObject(
      name: selectedItemName,
      status:  "edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=${widget.id}&Date=${widget.date}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item)async{
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['ID'].toString();
          unit=item['Unit'].toString();
          rate.text=item['Rate'].toString();
          selectedItemName=item['Name'].toString();
          gst.text=item['GST_Rate']!=null?item['GST_Rate']:"";

        });

      },

    );
    //   Container(
    //     height: parentHeight * .055,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: CommonColor.WHITE_COLOR,
    //       borderRadius: BorderRadius.circular(4),
    //       boxShadow: [
    //         BoxShadow(
    //           offset: const Offset(0, 1),
    //           blurRadius: 5,
    //           color: Colors.black.withOpacity(0.1),
    //         ),
    //       ],
    //     ),
    //     child: TextFieldSearch(
    //       minStringLength: 0,
    //         label: 'Item',
    //         controller: _textController,
    //         decoration: textfield_decoration.copyWith(
    //           hintText: ApplicationLocalizations.of(context)!.translate("item_name")!,
    //           prefixIcon: Container(
    //               width: 50,
    //               padding: const EdgeInsets.all(10),
    //               alignment: Alignment.centerLeft,
    //               child: const FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
    //         ),
    //         textStyle: item_regular_textStyle,
    //         getSelectedValue: (v) {
    //           setState(() {
    //             selectedItemID = v.value;
    //             unit=v.unit;
    //             gst.text=v.gst=="null"?gst.text:v.gst;
    //             itemsList = [];
    //           });
    //         },
    //         future: () {
    //           if (_textController.text != "")
    //             return fetchSimpleData(
    //                 _textController.text.trim());
    //         })
    //
    // );
  }
  
  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
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
          onTap: () {

            if(selectedItemID==null){
              var snackBar = const SnackBar(content: Text('Select Item Fisrt'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              var isValid = _formkey1.currentState?.validate();

              print(isValid);

              if (isValid == true && selectedItemID != null) {
                var item = {};
                if (widget.editproduct != null) {
                  if(oldItemID!=selectedItemID){
                    item = {
                      "ID": widget.editproduct['ID'],
                      "Item_ID":widget.editproduct!=null?widget.editproduct['Item_ID']:"",
                      "Unit":unit,
                      "Name":selectedItemName,
                      "New_Item_ID":selectedItemID,
                      "Disc_Percent": null,
                      "Rate":double.parse(rate.text),
                      "GST":double.parse(gst.text),
                      "GST_Amount":double.parse(gstAmt.text),
                      "Net_Rate":double.parse(net.text)
                    };
                  }
                  else {
                    item = {
                      "ID": widget.editproduct['ID'],
                      "Unit":widget.editproduct['Unit'],
                      "Item_ID": selectedItemID,
                      "Name":selectedItemName,
                      "Disc_Percent": null,
                      "Rate":double.parse(rate.text),
                      "GST":double.parse(gst.text),
                      "GST_Amount":double.parse(gstAmt.text),
                      "Net_Rate":double.parse(net.text)
                    };
                  }
                }
                else {
                  item = {
                    "ID": 0,
                    "Unit":unit,
                    "Item_ID": selectedItemID,
                    "Disc_Percent": null,
                    "Name":selectedItemName,
                    "Rate":double.parse(rate.text),
                    "GST":double.parse(gst.text),
                    "GST_Amount":double.parse(gstAmt.text),
                    "Net_Rate":double.parse(net.text)
                  };
                }
                if (widget.mListener != null) {
                  widget.mListener.addProductPurchaseRateDetail(item);
                  Navigator.pop(context);
                }
              }
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


abstract class AddProductPurchaseRateInterface{
  addProductPurchaseRateDetail(dynamic item);
}