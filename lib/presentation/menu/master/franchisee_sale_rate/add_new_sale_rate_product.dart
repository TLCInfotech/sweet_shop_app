import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/serchable_drop_down_for_existing_list.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_diable_textformfield.dart';
import '../../../common_widget/signleLine_TexformField.dart';

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
  FocusNode itemFocus = FocusNode();
  final _itemKey = GlobalKey<FormFieldState>();

  TextEditingController rate = TextEditingController();
  FocusNode rateFocus = FocusNode();
  final _rateKey = GlobalKey<FormFieldState>();

  TextEditingController gst = TextEditingController();
  FocusNode gstFocus = FocusNode();

  TextEditingController net = TextEditingController();
  TextEditingController gstAmt = TextEditingController();

  FocusNode searchFocus = FocusNode() ;
  TextEditingController unit = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }
  ScrollController _scrollController = new ScrollController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  var itemsList = [];
  var filteredItemsList = [];
  var selectedItemName="";






  List insertedList=[];
  var selectedItemID =null;
  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        selectedItemName=widget.editproduct['Name']!=null?widget.editproduct['Name']:null;
       selectedItemName=widget.editproduct['Name'];
        selectedItemID=widget.editproduct['Item_ID'];
        rate.text  =widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        gst.text =widget.editproduct['GST']!=0 &&widget.editproduct['GST']!="" &&widget.editproduct['GST']!=null?double.parse( widget.editproduct['GST'].toString()).toStringAsFixed(2):"";
        net.text =widget.editproduct['Net_Rate']!=0 &&widget.editproduct['Net_Rate']!="" &&widget.editproduct['Net_Rate']!=null?double.parse( widget.editproduct['Net_Rate'].toString()).toStringAsFixed(2):"";
        gstAmt.text =widget.editproduct['GSt_Amount']!=0 &&widget.editproduct['GSt_Amount']!="" &&widget.editproduct['GSt_Amount']!=null?double.parse( widget.editproduct['GSt_Amount'].toString()).toStringAsFixed(2):"";
        unit.text= widget.editproduct['Unit']!="" &&widget.editproduct['Unit']!=null? widget.editproduct['Unit']:"";
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
                  // getFieldTitleLayout(   ApplicationLocalizations.of(context)!.translate("item")!,),
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
          return    "";
        }
        return null;
      },
      controller: gst,
      readOnly: widget.readOnly,
      focuscontroller: gstFocus,
      focusnext: null,
      title:ApplicationLocalizations.of(context)!.translate("gst_percent")!,
      callbackOnchage: (value) async{
        print("here");
        setState(() {
          rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
          gst.text = value;
        });
        await calculateNetAmt();
        // await calculateOriginalAmt();
        await calculateGstAmt();
      },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );

  }
  calculateGstAmt(){
    var taxbleAmunt = rate.text == "" ? null : double.parse(rate.text);
    var gstText = gst.text == "" ? null : double.parse(gst.text);

    if(rate!=null && gstText!=null) {
      var gstAmtt = taxbleAmunt! * (gstText / 100);
      setState(() {
        gstAmt.text = gstAmtt.toStringAsFixed(2);
      });
    }
    if(gstText==null){
      setState(() {
        gstAmt.clear();
      });
    }

  }

  /* widget for product rate layout */
  Widget getProductRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      suffix: Text(unit.text),
        mandatory: true,
        txtkey: _rateKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
        controller: rate,
        focuscontroller: rateFocus,
        focusnext: gstFocus,
      readOnly: widget.readOnly,
      title:  ApplicationLocalizations.of(context)!.translate("sale_rate")!,
      callbackOnchage: (value)async {
        print("#");
        setState(() {
          gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
          rate.text = value;
        });
        await calculateNetAmt();
        await calculateGstAmt();
        _rateKey.currentState!.validate();
      },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
      maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
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
      mandatory: true,
      txtkey: _itemKey,
      focusnext: rateFocus,
      name: selectedItemName,
      come: widget.editproduct!=null?"disable":"",
      status: selectedItemName==""?"":"edit",
      apiUrl:"${ApiConstants().salePartyItem}?PartyID=${widget.id}&Date=${widget.dateNew}&",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      insertedList:insertedList,
      callback: (item) async {
  print("fjfjfjjngbn   ${insertedList.contains(item['Name'])}");
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
            rate.text = item['Rate'] == null? "" : item['Rate'].toString();
            gst.text = item['GST_Rate'] != null ? item['GST_Rate'] : "";
            unit.text= item['Unit'] != null ? item['Unit'] : "";

          });
        }
        await calculateGstAmt();
        await calculateNetAmt();
        _itemKey.currentState!.validate();
        _rateKey.currentState!.validate();
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
            bool v=_itemKey.currentState!.validate();
            bool r=_rateKey.currentState!.validate();
            if ( selectedItemID!=null&& v &&  r) {
              var item = {};
              if (widget.editproduct != null && widget.editproduct['ID']!=null) {
                item = {
                  "Item_ID": widget.editproduct['Item_ID'],
                  "ID": widget.editproduct['ID'],
                  "Name": selectedItemName,
                  "New_Item_ID": selectedItemID,
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "GST": gst.text!=""?double.parse(double.parse(gst.text).toStringAsFixed(2)):null,
                  "GST_Amount":gstAmt.text!=""?double.parse(double.parse(gstAmt.text).toStringAsFixed(2)):null,
                  "Net_Rate": net.text!=""?double.parse(double.parse(net.text).toStringAsFixed(2)):null,
                  "Unit":unit.text!=""?unit.text:null,
                };
              }
              else if(widget.editproduct != null){
                  item = {
                  "Item_ID": selectedItemID,
                  "Name": selectedItemName,
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "GST": gst.text!=""?double.parse(double.parse(gst.text).toStringAsFixed(2)):null,
                  "GST_Amount":gstAmt.text!=""?double.parse(double.parse(gstAmt.text).toStringAsFixed(2)):null,
                  "Net_Rate": net.text!=""?double.parse(double.parse(net.text).toStringAsFixed(2)):null,
                  "Unit":unit.text!=""?unit.text:null,
                  };

              }
              else {
                item = {
                  "Name": selectedItemName,
                  "Item_ID": selectedItemID,  
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "GST": gst.text!=""?double.parse(double.parse(gst.text).toStringAsFixed(2)):null,
                  "GST_Amount":gstAmt.text!=""?double.parse(double.parse(gstAmt.text).toStringAsFixed(2)):null,
                  "Net_Rate": net.text!=""?double.parse(double.parse(net.text).toStringAsFixed(2)):null,
                  "Unit":unit.text!=""?unit.text:null,

                };
              }

              if (widget.mListener != null) {

                print("********************************* \n ${item}");
                widget.mListener.addProductSaleRateDetail(item);
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

  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&${StringEn.lang}=$lang&PartyID=${widget.id}&Date=${widget.dateNew}";
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

}


abstract class AddProductSaleRateInterface{
  addProductSaleRateDetail(dynamic item);
}