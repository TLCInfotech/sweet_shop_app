import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';
import '../../../core/localss/application_localizations.dart';
import '../../common_widget/signleLine_TexformField.dart';
import '../../common_widget/singleLine_TextformField_without_double.dart';
import '../../dashboard/dashboard_activity.dart';

class DomainLinkActivity extends StatefulWidget {
  const DomainLinkActivity({super.key});
  // final DomainLinkActivityInterface mListener;
  @override
  State<DomainLinkActivity> createState() => _DomainLinkActivityState();
}

class _DomainLinkActivityState extends State<DomainLinkActivity> {



  final _domainLinkFocus = FocusNode();
  final _companyIdFocus = FocusNode();
  final domainLinkController = TextEditingController();
  final companyId = TextEditingController();

  bool disableColor = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localData();
  }
 localData()async{
    companyId.text=await AppPreferences.getCompanyId();
    // domainLinkController.text=await AppPreferences.getDomainLink();
    domainLinkController.text=ApiConstants().baseUrl;
    setState(() {

    });
 }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
             child: AppBar(
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                title:  Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              String sessionToken =await AppPreferences.getSessionToken();
                              setState(() {
                                if(sessionToken!="") {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => DashboardActivity()));
                                }
                                else{
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => LoginActivity()));
                                }
                              });
                            },
                            child: FaIcon(Icons.arrow_back),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context).translate("domain_link"),
                                style: appbar_text_style,),
                            ),
                          ),
                        ],
                      ),
                    ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: getAllTextFormFieldLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ),
            Container(
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeUsedHeight * .08,
                child: getSaveAndFinishButtonLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
          ],
        ),
      ),
    );
  }


  double opacityLevel = 1.0;


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: parentWidth * 0.04,
          right: parentWidth * 0.04,
          top: parentHeight * 0.01,
          bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: parentWidth * .01, right: parentWidth * .01),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey,width: 1),
                ),
                child: Column(children: [
                  getDomainLinkLayout(parentHeight, parentWidth),
                  getCompanyId(parentHeight, parentWidth),
                ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  /* Widget for domain Link text from field layout */
  Widget getDomainLinkLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: parentHeight * .5,
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
                child: Padding(
                  padding: EdgeInsets.only(top: parentHeight * .01),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.sentences,
                    scrollPadding: EdgeInsets.only(bottom: parentHeight * .2),
                    focusNode: _domainLinkFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 20,
                    maxLength: 500,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: parentWidth * .04),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText:  ApplicationLocalizations.of(context)!.translate("domain_link")!,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: domainLinkController,
                    validator: (value){
                      setState(() {
                        domainLinkController.text=value!;
                    print("hdghghdgh  $value");

                      });
                    },
                    onEditingComplete: () {


                      _domainLinkFocus.unfocus();
                    },
                    style: text_field_textStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


Widget getCompanyId(double parentHeight, double parentWidth){
    return    SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("company_id")!;
        }
        return null;
      },
      controller: companyId,
      focuscontroller: _companyIdFocus,
      focusnext: _companyIdFocus,
      title:     ApplicationLocalizations.of(context)!.translate("company_id")!,
      callbackOnchage: (value) {
        setState(() {
          companyId.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.digitsOnly,
    );
}
  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: parentWidth * .04,
              right: parentWidth * 0.04,
              top: parentHeight * .015),
          child: GestureDetector(
            onTap: () async{
              if (mounted && companyId.text!="" && domainLinkController.text!="") {
                String sessionToken =await AppPreferences.getSessionToken();
                setState(() {
                  disableColor = true;
                  CommonWidget.getPlayerId();
                  AppPreferences.setDomainLink(domainLinkController.text);
                  AppPreferences.setCompanyId(companyId.text);
                  var snackBar = SnackBar(content: Text('Domain save succesfully!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  if(sessionToken!="") {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DashboardActivity()));
                  }
                  else{

                    callGetCompany();
                  }
                });
              }
              else{
                var snackBar = SnackBar(content: Text('Fill all the necessary field!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            onDoubleTap: () {},
            child: Container(
              height: parentHeight * .06,
              decoration: BoxDecoration(
                color: disableColor == true
                    ? CommonColor.THEME_COLOR.withOpacity(.5)
                    : CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .005),
                    child:  Text(
                      ApplicationLocalizations.of(context)!.translate("save")!,
                      style: page_heading_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> _arrList = [];
  File? picImage;
  callGetCompany() async {
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    String lang = await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected) {
        String apiUrl =
            "$baseurl${ApiConstants().companyImage}?Company_ID=$companyId&${StringEn.lang}=$lang";
        print("newwww  $apiUrl   $baseurl ");
        //  "?pageNumber=$page&PageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, "", "",
            onSuccess: (data) {
          if(data!=null){
            _arrList = data;
            print("hjfhjfhghg  $_arrList");
            setData();

            print("  LedgerLedger  $data ");
          }else{
            Navigator.pop(context);
          }

            }, onFailure: (error) {

              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              var val = CommonWidget.errorDialog(context, e);

              print("YES");
              if (val == "yes") {
                print("Retry");
              }
            }, sessionExpire: (e) {

              CommonWidget.gotoLoginScreen(context);

      });
    } else {
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setData()async{
    File ?f;
    if (_arrList[0]['Photo'] != null &&
        _arrList[0]['Photo']['data'] != null &&
        _arrList[0]['Photo']['data'].length > 10) {
      f = await CommonWidget.convertBytesToFile(
          _arrList[0]['Photo']['data']);
    }
    picImage=f ?? picImage;
    print(" yuyuuij    ${picImage!.path}");
    AppPreferences.setCompanyName(_arrList[0]['Name']);
    if (picImage != null) {
      AppPreferences.setCompanyUrl(picImage!.path);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginActivity()));
    }

  var _openResult = 'Unknown';

  Future<void> openFile() async {

    final filePath = 'http://61.2.227.173:3000/excels/order_20349.xlsx';
    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }
}

abstract class DomainLinkActivityInterface {
  backToLogin();
}
