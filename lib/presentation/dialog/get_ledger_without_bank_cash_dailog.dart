import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

import '../../core/app_preferance.dart';
import '../../core/common.dart';
import '../../data/api/constant.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/commonRequest/get_toakn_request.dart';

class LedgerWithoutBankCashDialog extends StatefulWidget {
  final LedgerWithoutBankCashInterface mListener;

  const LedgerWithoutBankCashDialog({super.key, required this.mListener});

  @override
  State<LedgerWithoutBankCashDialog> createState() => _LedgerWithoutBankCashDialogState();
}

class _LedgerWithoutBankCashDialogState extends State<LedgerWithoutBankCashDialog>{
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetBankCashLedger();
  }
  List<dynamic> bankCashLedgerList = [];

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
              height: SizeConfig.screenHeight*.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.08,
                    child: Center(
                      child: Text(
                          ApplicationLocalizations.of(context)!.translate("ledger_without_bank_cash")!,
                          style: page_heading_textStyle
                      ),
                    ),
                  ),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  Container(
                      height: SizeConfig.screenHeight*.32,
                      child: getList(SizeConfig.screenHeight,SizeConfig.screenWidth)),

                ],
              ),
            ),
          ),
          getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
        ],
      ),
    );
  }


  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Padding(
      padding:  EdgeInsets.only(bottom: parentHeight*.015,left: parentWidth*.04,right: parentWidth*.04),
      child: Container(
        height: parentHeight*.05,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          color: CommonColor.GRAY_COLOR.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(050)),
        ),
        child:  Padding(
          padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(searchFocus);
                },
                child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(right: parentWidth * .015),
                      child:Image(
                        image:  AssetImage("assets/images/search.png"),
                        height: parentHeight * .025,
                        fit: BoxFit.contain,
                        color: CommonColor.SEARCH_TEXT_COLOR,
                      ),
                    )),
              ),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  // autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  controller: _textController,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: searchFocus,
                  style: text_field_textStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    border: InputBorder.none,
                    hintText:ApplicationLocalizations.of(context)!.translate("search")!,
                    hintStyle: TextStyle(
                        color: CommonColor.SEARCH_TEXT_COLOR,
                        fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                        fontFamily: 'Inter_Medium_Font',
                        fontWeight: FontWeight.w400),
                  ),
                  // onChanged: _onChangeHandler,
                ),
              ),
              Visibility(
                visible: _textController.text.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    _textController.clear();
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.cancel,
                        color: CommonColor.SEARCH_TEXT_COLOR,
                        size: SizeConfig.screenHeight * .03,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget getList(double parentHeight,double parentWidth){
    return Padding(
      padding:EdgeInsets.only(top: parentHeight*.01),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: bankCashLedgerList.length,
          itemBuilder:(BuildContext context, int index){
            return Padding(
              padding:EdgeInsets.only(left: parentWidth*.1,right: parentWidth*.1),
              child: GestureDetector(
                onTap: (){
                  if(widget.mListener!=null){
                    widget.mListener.selectedLedgerWithoutBankCashInterface(bankCashLedgerList[index]['ID'].toString(),bankCashLedgerList[index]['Name']);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: parentHeight*.06,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: CommonColor.PROFILE_BORDER,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bankCashLedgerList[index]['Name'],
                        style: text_field_textStyle,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
            color: CommonColor.THEME_COLOR,
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



  callGetBankCashLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + ApiConstants().getLedgerWithoutBankCash+"?Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            if(data!=null) {
              setState(() {
                bankCashLedgerList = data;
              });
              print("  LedgerLedger  $data ");
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);

            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });

    });
  }
}


abstract class LedgerWithoutBankCashInterface{
  selectedLedgerWithoutBankCashInterface(String id,String name);
}