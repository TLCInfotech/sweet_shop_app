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
import '../../../common_widget/signleLine_TexformField.dart';
class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}
class AddOrEditLedgerForContra extends StatefulWidget {
  final AddOrEditLedgerForContraInterface mListener;
  final dynamic editproduct;
  final newDate;
  final franId;
  const AddOrEditLedgerForContra({super.key, required this.mListener, required this.editproduct, this.newDate, this.franId});
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

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var itemsList = [];
  var selectedItemID =null;
  var oldItemId=0;


  fetchShows (searchstring) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = ApiConstants().baseUrl + ApiConstants().getBankCashLedger+"?Company_ID=$companyId&name=${searchstring}";
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
      _list.add( TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal(){
    print(widget.editproduct);
    if(widget.editproduct!=null){
      setState(() {
        selectedItemID=widget.editproduct['Ledger_ID']!=null?widget.editproduct['Ledger_ID']:null;
        _textController.text=widget.editproduct['Ledger_Name'];
        amount.text=widget.editproduct['Amount'].toString();
        narration.text=widget.editproduct['Remark']!=null?widget.editproduct['Remark'].toString():narration.text;
      });
      print(oldItemId);
    }
  }

/*  setVal(){
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['ledgerName'];
        amount.text=widget.editproduct['amount'].toString();
        narration.text=widget.editproduct['narration'].toString();
      });
    }
  }*/

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
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.08,
                    child: Center(
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

                  /*   SizedBox(height: 20,),
                  getButtonLayout()*/

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



  /* widget for product gst layout */
  Widget getLedgerNarrationLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(

      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.NARRATION;
        }
        return null;
      },
      controller: narration,
      focuscontroller: null,
      focusnext: null,
      title:   ApplicationLocalizations.of(context)!.translate("narration")!,
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

  /* widget for product rate layout */
  Widget getILedgerAmountyLayout(double parentHeight, double parentWidth) {
    return      SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.AMOUNT;
        }
        return null;
      },
      controller: amount,
      focuscontroller: null,
      focusnext: null,
      title:    ApplicationLocalizations.of(context)!.translate("amount")!,
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
              hintText: ApplicationLocalizations.of(context)!.translate("ledger_name")!,
              prefixIcon: Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
            ),
            textStyle: item_regular_textStyle,
            getSelectedValue: (v) {
              setState(() {

                if(widget.franId==v.value){
                  _textController.clear();
                  CommonWidget.errorDialog(context, "You can not select same ledger.");
                }
                else{
                  setState(() {
                    selectedItemID = v.value;
                  });
                }
                print("newwww  ${widget.franId}   $selectedItemID");
                itemsList = [];
              });
            },
            minStringLength: 0,
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
          onTap: () {
            var item={};
            if(widget.editproduct!=null){
              item = {
                "New_Ledger_ID": selectedItemID,
                "Ledger_Name": _textController.text,
                "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                "Ledger_ID": widget.editproduct['Ledger_ID'],
                "Amount": double.parse(amount.text),
                "Date": widget.newDate,
                "Remark": narration.text,
              };
            }
            else {
              item = {
                "Ledger_Name": _textController.text,
                "Date": widget.newDate,
                //  "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                "Ledger_ID": selectedItemID,
                "Amount": double.parse(amount.text),
                "Remark": narration.text,
              };
            }

            if(widget.mListener!=null){
              widget.mListener.AddOrEditLedgerForContraDetail(item);
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
            child: Row(
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