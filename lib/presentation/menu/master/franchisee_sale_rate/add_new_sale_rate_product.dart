import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/serchable_drop_down_for_existing_list.dart';
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
  dynamic gst;
  dynamic rate;
  TestItem({required this.label, this.value,this.gst,this.rate});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],gst:"${json['gst']}",rate:"${json['rate']}");
  }
}
class AddProductSaleRate extends StatefulWidget {
  final AddProductSaleRateInterface mListener;
  final dynamic editproduct;
  final String dateNew;
  final id;
  final readOnly;
  final exstingList;

  const AddProductSaleRate({super.key, required this.mListener, required this.editproduct, required this.dateNew,  this.id, this.readOnly, this.exstingList});

  @override
  State<AddProductSaleRate> createState() => _AddProductSaleRateState();
}

class _AddProductSaleRateState extends State<AddProductSaleRate>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController net = TextEditingController();
  TextEditingController gstAmt = TextEditingController();

  FocusNode searchFocus = FocusNode() ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }
  ScrollController _scrollController = new ScrollController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  // fetchShows (searchstring) async {
  //   String sessionToken = await AppPreferences.getSessionToken();
  //   String companyId = await AppPreferences.getCompanyId();
  //   await AppPreferences.getDeviceId().then((deviceId) {
  //     TokenRequestModel model = TokenRequestModel(
  //       token: sessionToken,
  //     );
  //     String apiUrl = "${ApiConstants().baseUrl}${ApiConstants().item_list}?Company_ID=$companyId&name=${searchstring}&Date=${widget.dateNew}";
  //     apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
  //         onSuccess:(data)async{
  //           if(data!=null) {
  //             print("newwwww   $data");
  //             var topShowsJson = (data) as List;
  //             setState(() {
  //               itemsList=  topShowsJson.map((show) => (show)).toList();
  //             });
  //           }
  //         }, onFailure: (error) {
  //           CommonWidget.errorDialog(context, error);
  //           return [];
  //         }, onException: (e) {
  //           CommonWidget.errorDialog(context, e);
  //           return [];
  //
  //         },sessionExpire: (e) {
  //           CommonWidget.gotoLoginScreen(context);
  //           return [];
  //         });
  //   });
  // }
  //
  // var itemsList = [];
  //
  // Future<List> fetchSimpleData(searchstring) async {
  //   await Future.delayed(Duration(milliseconds: 0));
  //   await fetchShows(searchstring) ;
  //
  //   List _list = <dynamic>[];
  //   print(itemsList);
  //   //  for (var ele in data) _list.add(ele['TestName'].toString());
  //   for (var ele in itemsList) {
  //     _list.add(new TestItem.fromJson(
  //         {'label': "${ele['Name']}", 'value': "${ele['ID']}", 'gst': "${ele['GST_Rate']}", 'rate': "${ele['Rate']}"}));
  //   }
  //   return _list;
  // }


  var itemsList = [];
  var filteredItemsList = [];
  var selectedItemName="";


  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&PartyID=${widget.id}&Date=${widget.dateNew}";
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



  List insertedList=[];
  var selectedItemID =null;
  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        selectedItemName=widget.editproduct['Name']!=null?widget.editproduct['Name']:null;
       selectedItemName=widget.editproduct['Name'];
        selectedItemID=widget.editproduct['Item_ID'];
        rate.text=widget.editproduct['Rate'].toString();
        gst.text=widget.editproduct['GST']==null?"":widget.editproduct['GST'].toString();
        net.text=widget.editproduct['Net_Rate']==null?"":widget.editproduct['Net_Rate'].toString();
        gstAmt.text=widget.editproduct['GSt_Amount']==null?"":widget.editproduct['GSt_Amount'].toString();
      });
    }

    List list= widget.exstingList;
    setState(() {
      insertedList=list.map((e) =>e['Name'] ).toList();
    });
    print("###########");
    print(insertedList);
    await fetchItems();
    await calculateGstAmt();
    await calculateNetAmt();
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
              decoration: BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
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
                  getFieldTitleLayout(   ApplicationLocalizations.of(context)!.translate("item")!,),
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
    else if(rate.text!=""){
      setState(() {
        net.text=rate.text;
      });
    }
    else {
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
      title:    ApplicationLocalizations.of(context)!.translate("net_rate")!,
    );
  }

  /* widget for gst amount layout */
  Widget getGstAmountLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
      controller: gstAmt,
      title:    ApplicationLocalizations.of(context)!.translate("gst_amount")!,
    );

  }

  /* widget for product gst layout */
  Widget getProductGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      suffix:Text("%"),
      validation: (value) {
        if (value!.isEmpty) {
          return    ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("gst_percent")!;
        }
        return null;
      },
      controller: gst,
      readOnly: widget.readOnly,
      focuscontroller: null,
      focusnext: null,
      title:ApplicationLocalizations.of(context)!.translate("gst_percent")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ ApplicationLocalizations.of(context)!.translate("sale_rate")!;
        }
        return null;
      },
      controller: rate,
      focuscontroller: null,
      focusnext: null,
      readOnly: widget.readOnly,
      title:  ApplicationLocalizations.of(context)!.translate("sale_rate")!,
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

/*  Widget getAddSearchLayout(double parentHeight, double parentWidth){
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
          hintText:    ApplicationLocalizations.of(context)!.translate("item_name")!,
          prefixIcon: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
        ),
        // onChanged: _onChangeHandler,
      ),
    );
  }*/


  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    print("sadas ${selectedItemName}");
    return SearchableDropdownWithExistingList(
      name: selectedItemName,
      come: widget.editproduct!=null?"disable":"",
      status: selectedItemName==""?"":"edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=${widget.id}&Date=${widget.dateNew}&",
      titleIndicator: false,
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
            rate.text=item['Rate'].toString();
            gst.text=item['GST_Rate']!=null?item['GST_Rate']:"";
          });
        }
      },
    );
   /* return SearchableDropdownWithObject(
      name: selectedItemName,
      status:  "edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=${widget.id}&Date=${widget.dateNew}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item)async{
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['ID'].toString();
          selectedItemName=item['Name'].toString();
          rate.text=item['Rate'].toString();
          gst.text=item['GST_Rate']!=null?item['GST_Rate']:"";
        });
        await calculateGstAmt();
        await calculateNetAmt();
      },

    );*/

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
          child: Center(
            child: Text(
              ApplicationLocalizations.of(context)!.translate("close")!,
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
            if(selectedItemID!=null &&  rate.text!="") {
              var item = {};
              if (widget.editproduct != null) {
                item = {
                  "Item_ID": widget.editproduct['Item_ID'],
                  "ID": widget.editproduct['ID'],
                  "Name": selectedItemName,
                  "New_Item_ID": selectedItemID,
                  "Rate": double.parse(rate.text),
                  "GST": gst.text != "" ? double.parse(gst.text) : null,
                  "GST_Amount":gst.text != "" ? double.parse(gstAmt.text):null,
                  "Net_Rate": double.parse(net.text)
                };
              } else {
                item = {
                  "Name": selectedItemName,
                  "Item_ID": selectedItemID,
                  "Rate": double.parse(rate.text),
                  "GST": gst.text != "" ? double.parse(gst.text) : null,
                  "GST_Amount":gst.text != "" ? double.parse(gstAmt.text):null,
                  "Net_Rate": double.parse(net.text)
                };
              }

              if (widget.mListener != null) {
                widget.mListener.addProductSaleRateDetail(item);
                Navigator.pop(context);
              }
            }
            else{
              CommonWidget.errorDialog(context,
                  "Please add required fields item,rate,!");
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



}


abstract class AddProductSaleRateInterface{
  addProductSaleRateDetail(dynamic item);
}