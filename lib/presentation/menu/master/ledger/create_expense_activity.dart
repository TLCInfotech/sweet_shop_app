import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/dialog/amount_type_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_type_dialog.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/ledger/post_ledger_request_model.dart';
import '../../../../data/domain/ledger/put_ledger_request_model.dart';
import '../../../common_widget/get_country_layout.dart';
import '../../../common_widget/get_district_layout.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/get_state_value.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../../dialog/parent_ledger_group_dialoug.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../searchable_dropdowns/searchable_dropdown_for_string_array.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_obj_for_tax.dart';


class CreateExpenseActivity extends StatefulWidget {
  final CreateExpenseActivityInterface mListener;
  final   ledgerList;
  final   readOnly;
  final String logoImage;
  const CreateExpenseActivity({super.key, required this.mListener,  this.ledgerList, this.readOnly, required this.logoImage});


  @override
  State<CreateExpenseActivity> createState() => _CreateExpenseActivityState();
}

class _CreateExpenseActivityState extends State<CreateExpenseActivity>
    with
        SingleTickerProviderStateMixin, TaxDialogInterface , TaxCategoryDialogInterface, LedegerGroupDialogInterface,AmountTypeDialogInterface {

  final _formKey = GlobalKey<FormState>();

  bool checkActiveValue = false;
  final _nameFocus = FocusNode();
  final nameController = TextEditingController();
  final _nameKey = GlobalKey<FormFieldState>();

  final _ledgergroupKey = GlobalKey<FormFieldState>();


  final _addressFocus = FocusNode();
  final addressController = TextEditingController();

  final _districtCity = FocusNode();
  final districtController = TextEditingController();

  final _contactFocus = FocusNode();
  final contactController = TextEditingController();

  final _extNameFocus = FocusNode();
  final extNameController = TextEditingController();
  final _addTwoFocus = FocusNode();
  final addTwoController = TextEditingController();
  final _emailFocus = FocusNode();
  final emailController = TextEditingController();
  final _pinCodeFocus = FocusNode();
  final pinCodeController = TextEditingController();
  final _panNoFocus = FocusNode();
  final panNoController = TextEditingController();
  final _gstNoFocus = FocusNode();
  final gstNoController = TextEditingController();
  final _cinNoFocus = FocusNode();
  final cinNoController = TextEditingController();
  final _adharoFocus = FocusNode();
  final adharNoController = TextEditingController();
  final _leaderGroupFocus = FocusNode();
  final leaderGroupController = TextEditingController();
  final _langFocus = FocusNode();
  final langController = TextEditingController();
  final _contactPersonFocus = FocusNode();
  final contactPersonController = TextEditingController();
  final _outstandingLimitFocus = FocusNode();
  final outstandingLimitController = TextEditingController();
  final _taxRateFocus = FocusNode();
  final taxRateController = TextEditingController();
  final _CGSTFocus = FocusNode();
  final CGSTController = TextEditingController();
  final _SGSTFocus = FocusNode();
  final SGSTController = TextEditingController();
  final _cessFocus = FocusNode();
  final cessController = TextEditingController();
  final _hsnNoFocus = FocusNode();
  final hsnNoController = TextEditingController();
  final _accountNoFocus = FocusNode();
  final accountNoController = TextEditingController();
  final _aCHolderNameFocus = FocusNode();
  final aCHolderNameController = TextEditingController();
  final _IFSCCodeFocus = FocusNode();
  final IFSCCodeController = TextEditingController();
  final _bankBranchFocus = FocusNode();
  final bankBranchController = TextEditingController();
  final _bankNameFocus = FocusNode();
  final bankNameController = TextEditingController();
  final _addCessFocus = FocusNode();
  final addCessController = TextEditingController();
  bool isApiCall = false;
  late InternetConnectionStatus internetStatus;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoaderShow=false;

  var editedItem=null;
  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  File? picImage;
  String countryName = "";
  String countryId = "";
  String stateName = "";
  String stateId = "";
  String cityId = "";
  String taxTypeName = "";
  String taxTypeId = "";
  String taxCategoryName = "";
  String taxCategoryId = "";
  String regTypeName = "";
  String regTypeId = "";
  String parentCategory = "";
  String parentCategoryId = "";
  Color currentColor = CommonColor.THEME_COLOR;
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;


  List<int> picImageBytes=[];

  List<int> adharImageBytes=[];
  List<int> panImageBytes=[];
  List<int> gstImageBytes=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.ledgerList!=null) {
      getData();
    }
    setVal();
  }

  String langu = "en_IN";
  setVal()async{
    langu=await AppPreferences.getLang();
    setState(() {

    });
  }
  File? adharFile ;
  File? panFile ;
  File? gstFile ;
var ledgerData=null;

  getData()async{
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getLedger}/${widget.ledgerList['ID']}?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              setState(()  {

                if(data!=null){
                  setState(() {
                    ledgerData=data;
                  });
                  print("%%%%%%%%%%%%%%%%%%%%% $ledgerData");
             
                }else{
                  isApiCall=true;
                }
              
              });
              await setData();
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {

              print("Here2=> $e");

              setState(() {
                isLoaderShow=false;
              });
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setData()async{
  if(widget.ledgerList!=null){
    // await getData();
    print("#############123");
    print(ledgerData[0]);
    File ?f=null;
    File ?a=null;
    File ?p=null;
    File ?g=null;
    if(ledgerData[0]['Photo']!=null&&ledgerData[0]['Photo']['data']!=null && ledgerData[0]['Photo']['data'].length>10) {
      f = await CommonWidget.convertBytesToFile(ledgerData[0]['Photo']['data']);
    }
    if(ledgerData[0]['Adhar_Card_Image']!=null&&ledgerData[0]['Adhar_Card_Image']['data']!=null && ledgerData[0]['Adhar_Card_Image']['data'].length>10) {
      a = await CommonWidget.convertBytesToFile(ledgerData[0]['Adhar_Card_Image']['data']);
    }
    if(ledgerData[0]['PAN_Card_Image']!=null&&ledgerData[0]['PAN_Card_Image']['data']!=null && ledgerData[0]['PAN_Card_Image']['data'].length>10) {
      p = await CommonWidget.convertBytesToFile(ledgerData[0]['PAN_Card_Image']['data']);
    }
    if(ledgerData[0]['GST_Image']!=null&&ledgerData[0]['GST_Image']['data']!=null && ledgerData[0]['GST_Image']['data'].length>10) {
      g = await CommonWidget.convertBytesToFile(ledgerData[0]['GST_Image']['data']);
    }
    print("###################333");
    print(ledgerData[0]['District']);
      setState(()  {
      districtController.text=ledgerData[0]['District']!=null?ledgerData[0]['District'].toString():districtController.text;
      langController.text=ledgerData[0]['Name_Locale']!=null?ledgerData[0]['Name_Locale'].toString():langController.text.trim();
      countryName=ledgerData[0]['Country']!=null?ledgerData[0]['Country'].toString():countryName;

      stateName=ledgerData[0]['State']!=null?ledgerData[0]['State']:stateName;
      picImageBytes=(ledgerData[0]['Photo']!=null && ledgerData[0]['Photo']['data']!=null && ledgerData[0]['Photo']['data'].length>10)?(ledgerData[0]['Photo']['data']).whereType<int>().toList():[];
      picImage=f!=null?f:picImage;
      adharImageBytes=(ledgerData[0]['Adhar_Card_Image']!=null&&ledgerData[0]['Adhar_Card_Image']['data']!=null && ledgerData[0]['Adhar_Card_Image']['data'].length>10)?(ledgerData[0]['Adhar_Card_Image']['data']).whereType<int>().toList():[];
      adharFile=a!=null?a:adharFile;
      panImageBytes=(ledgerData[0]['PAN_Card_Image']!=null&&ledgerData[0]['PAN_Card_Image']['data']!=null && ledgerData[0]['PAN_Card_Image']['data'].length>10)?(ledgerData[0]['PAN_Card_Image']['data']).whereType<int>().toList():[];
      panFile=p!=null?p:panFile;
      gstImageBytes=(ledgerData[0]['GST_Image']!=null&&ledgerData[0]['GST_Image']['data']!=null && ledgerData[0]['GST_Image']['data'].length>10)?(ledgerData[0]['GST_Image']['data']).whereType<int>().toList():[];
      gstFile=g!=null?g:gstFile;
      parentCategory= ledgerData[0]['Group_Name'];
      parentCategoryId= ledgerData[0]['Group_ID'].toString();
      nameController.text= ledgerData[0]['Name'];
      contactPersonController.text=  ledgerData[0]['Contact_Person']!=null?ledgerData[0]['Contact_Person']:contactPersonController.text;
      addressController.text= ledgerData[0]['Address']!=null?ledgerData[0]['Address']:addressController.text;
      pinCodeController.text= ledgerData[0]['Pin_Code']!=null?ledgerData[0]['Pin_Code']:pinCodeController.text;
      contactController.text=  ledgerData[0]['Contact_No']!=null?ledgerData[0]['Contact_No']:contactController.text;
      emailController.text= ledgerData[0]['EMail']!=null?ledgerData[0]['EMail']: emailController.text;
      outstandingLimitController.text= ledgerData[0]['Outstanding_Limit']!=null?ledgerData[0]['Outstanding_Limit'].toString():outstandingLimitController.text;
      selectedLimitUnit= ledgerData[0]['Outstanding_Limit_Type']!=null?ledgerData[0]['Outstanding_Limit_Type'].toString():selectedLimitUnit;
      extNameController.text=ledgerData[0]['Ext_Name']!=null?ledgerData[0]['Ext_Name'].toString(): extNameController.text;
      adharNoController.text=ledgerData[0]['Adhar_No']!=null?ledgerData[0]['Adhar_No'].toString():adharNoController.text;
      panNoController.text=ledgerData[0]['PAN_No']!=null?ledgerData[0]['PAN_No'].toString():panNoController.text;
      gstNoController.text=ledgerData[0]['GST_No']!=null?ledgerData[0]['GST_No'].toString():gstNoController.text;
      hsnNoController.text=ledgerData[0]['HSN_No']!=null?ledgerData[0]['HSN_No'].toString():hsnNoController.text;
      taxRateController.text=ledgerData[0]['Tax_Rate']!=null?ledgerData[0]['Tax_Rate'].toString():taxRateController.text;
      CGSTController.text=ledgerData[0]['CGST_Rate']!=null?ledgerData[0]['CGST_Rate'].toString():CGSTController.text;
      SGSTController.text=ledgerData[0]['SGST_Rate']!=null?ledgerData[0]['SGST_Rate'].toString():SGSTController.text;
      cessController.text=ledgerData[0]['Cess_Rate']!=null?ledgerData[0]['Cess_Rate'].toString():cessController.text;
      addCessController.text=ledgerData[0]['Add_Cess_Rate']!=null?ledgerData[0]['Add_Cess_Rate'].toString():addCessController.text;
      bankNameController.text=ledgerData[0]['Bank_Name']!=null?ledgerData[0]['Bank_Name'].toString():bankNameController.text;
      bankBranchController.text=ledgerData[0]['Bank_Branch']!=null?ledgerData[0]['Bank_Branch'].toString():bankBranchController.text;
      IFSCCodeController.text=ledgerData[0]['IFSC_Code']!=null?ledgerData[0]['IFSC_Code'].toString():IFSCCodeController.text;
      accountNoController.text=ledgerData[0]['Account_No']!=null?ledgerData[0]['Account_No'].toString():accountNoController.text;
      aCHolderNameController.text=ledgerData[0]['AC_Holder_Name']!=null?ledgerData[0]['AC_Holder_Name'].toString(): aCHolderNameController.text;
      taxTypeName=ledgerData[0]['Tax_Type']!=null?ledgerData[0]['Tax_Type'].toString(): taxTypeName;
      taxCategoryName=ledgerData[0]['Tax_Category']!=null?ledgerData[0]['Tax_Category'].toString(): taxTypeName;
      isLoaderShow=false;
      });
  }
}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
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
                  // color: Colors.red,
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: FaIcon(Icons.arrow_back),
                          ),
                          widget.logoImage!=""? Container(
                            height:SizeConfig.screenHeight*.05,
                            width:SizeConfig.screenHeight*.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  image: FileImage(File(widget.logoImage)),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ):Container(),
                          Expanded(
                            child: widget.ledgerList!=null? Center(
                              child: Text(
                               ApplicationLocalizations.of(context)!.translate("ledger")!,
                                style: appbar_text_style,
                              ),
                            )
                                : Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("ledger")!,
                                style: appbar_text_style,
                              ),
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
                  child: isLoaderShow?Center(child: CircularProgressIndicator(color: Colors.transparent,)):Container(
                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllTextFormFieldLayout(
                          SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                widget.readOnly==false?Container():    Container(
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
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }


  List<String> LimitDataUnit = ["Cr","Dr"];

  var selectedLimitUnit = null;

  double opacityLevel = 1.0;


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():ListView(
      shrinkWrap: true,
      controller: _scrollController,
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    getImageLayout(parentHeight, parentWidth),
                    SizedBox(height: 20,),
                    getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("basic_information")!, ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: Column(children: [
                        getNameLayout(parentHeight, parentWidth),
                        langu=="en_IN"?Container():  getNameLangLayout(parentHeight, parentWidth),
                        getParentGroupLayout(parentHeight, parentWidth),
                        getContactPersonLayout(parentHeight, parentWidth),
                        getAddressLayout(parentHeight, parentWidth),
                        // Row(
                        //   children: [
                        //     getLeftLayout(parentHeight, parentWidth),
                        //     getRightLayout(parentHeight, parentWidth),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getDistrictCityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                            SizedBox(width: 5,),
                            getPinCodeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          ],
                        ),
                        getStateLayout(parentHeight, parentWidth),
                        getCountryLayout(parentHeight, parentWidth),
                        getContactNoLayout(parentHeight, parentWidth),
                        getEmilLayout(parentHeight, parentWidth),
                        getOutstandingLimitLayout(parentHeight, parentWidth),
                        getExtNameLayout(parentHeight, parentWidth),
                      ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("document_information")!, ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: Column(children: [
                        // addhar
                        PickDocument(
                          callbackOnchage: (value ) {
                            setState(() {
                              adharNoController.text=value;
                            });
                          },
                          callbackFile: (File? file) async{
                            Uint8List? bytes = await file?.readAsBytes();
                            setState(() {
                              adharFile=file;
                              adharImageBytes = (bytes)!.whereType<int>().toList();
                            });
                            print("IMGE1 : ${adharImageBytes.length}");
                          },
                          readOnly: widget.readOnly,
                          title: ApplicationLocalizations.of(context)!.translate("adhar_number")!,
                          documentFile: adharFile,
                          controller: adharNoController,

                          focuscontroller: _adharoFocus,
                          focusnext: _panNoFocus,
                        ),
                        // pan
                        PickDocument(
                          callbackOnchage: (value ) {
                            setState(() {
                              panNoController.text=value;
                            });
                          },
                          callbackFile: (File? file)async {
                            Uint8List? bytes = await file?.readAsBytes();
                            setState(() {
                              panFile=file;
                              panImageBytes = (bytes)!.whereType<int>().toList();
                            });
                            print("IMGE1 : ${panImageBytes.length}");

                          },
                          title:      ApplicationLocalizations.of(context)!.translate("pan_number")! ,
                          documentFile: panFile,
                          readOnly: widget.readOnly,
                          controller: panNoController,
                          focuscontroller: _panNoFocus,
                          focusnext: _gstNoFocus,
                        ),
                        // gst
                        PickDocument(
                          callbackOnchage: (value ) {
                            setState(() {
                              gstNoController.text=value;
                            });
                          },
                          callbackFile: (File? file) async{
                            Uint8List? bytes = await file?.readAsBytes();
                            setState(() {
                              gstFile=file;
                              gstImageBytes = (bytes)!.whereType<int>().toList();
                            });
                            print("IMGE1 : ${gstImageBytes.length}");

                          },
                          title:      ApplicationLocalizations.of(context)!.translate("gst_number")!,
                          documentFile: gstFile,
                          readOnly: widget.readOnly,
                          controller: gstNoController,
                          focuscontroller: _gstNoFocus,
                          focusnext: _cinNoFocus,
                        ),
                      ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("tax_information")!, ),

                    Container(

                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getTaxTypeLayout(parentHeight,parentWidth),
                            SizedBox(width: 5,),
                            getTaxCategoryLayout(parentHeight,parentWidth),
                          ],
                        ),
                        Row(
                          children: [
                            getTaxLeftLayout(parentHeight, parentWidth),
                            getTaxRightLayout(parentHeight, parentWidth),
                          ],
                        ),
                      ],
                      ),
                    ),


                    // getTaxLayout(parentHeight, parentWidth),

                    SizedBox(height: 20,),
                    getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("account_information")!, ),
                    Container(

                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: Column(children: [

                        // getAccountInfoLayout(parentHeight, parentWidth),
                        getBankNameLayout(parentHeight, parentWidth),
                        getBankBranchNameLayout(parentHeight, parentWidth),
                        getFSCCodeLayout(parentHeight, parentWidth),
                        getACHolderNameLayout(parentHeight, parentWidth),
                        getAcoountNoLayout(parentHeight, parentWidth),

                      ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getImageLayout(double parentHeight, double parentWidth) {
    return GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        readOnly: widget.readOnly,
        callbackFile: (file)async{
          if(file!=null) {

            Uint8List? bytes = await file?.readAsBytes();

              setState(() {
                picImage=file;
                picImageBytes = (bytes)!.whereType<int>().toList();
              });
          }
          else{
            setState(() {
              picImage = file;
              picImageBytes = [];
            });
          }

        }
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


  /* Widget for name text from field layout */
  Widget getNameLangLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return     "";
        }
        return null;
      },
      mandatory: false,
      controller: langController,
      focuscontroller: _langFocus,
      readOnly: widget.readOnly,
      focusnext: _leaderGroupFocus,
      title:     ApplicationLocalizations.of(context)!.translate("name")+ApplicationLocalizations.of(context).translate("langu")  ,
      callbackOnchage: (value) {
        setState(() {
          langController.text = value;
        });

      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'^[\u0900-\u097F\sA-Za-z0-9&^%*.,:)(-]+$')),
    );

  }

  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return     "";
        }
        return null;
      },
      mandatory: true,
      txtkey: _nameKey,
      controller: nameController,
      focuscontroller: _nameFocus,
      readOnly: widget.readOnly,
      focusnext: _langFocus,
      title:"Ledger Name (English)",
     // title:     ApplicationLocalizations.of(context)!.translate("name"),
      callbackOnchage: (value) {
        setState(() {
          nameController.text = value;
        });
        _nameKey.currentState!.validate();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'^[A-zÀ\s*&^%0-9,.-:)(]+')),
    );

  }

  /* Widget for leader group text from field layout */
  Widget getLeaderGroupLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("ledger_group")! ;
        }
        return null;
      },
      controller: leaderGroupController,
      focuscontroller: _leaderGroupFocus,
      focusnext: _contactPersonFocus,
      readOnly: widget.readOnly,
      title:     ApplicationLocalizations.of(context)!.translate("ledger_group")! ,
      callbackOnchage: (value) {
        setState(() {
          leaderGroupController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );


  }


  /* Widget For Category Layout */
  Widget getParentGroupLayout(double parentHeight, double parentWidth){
    return   Padding(
        padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
        child:  SearchableLedgerDropdown(
          mandatory: true,
            txtkey: _ledgergroupKey,
            apiUrl:ApiConstants().ledger_group+"?",
            franchisee: widget.ledgerList!=null?"edit":"",
            readOnly: widget.readOnly,
            franchiseeName: widget.ledgerList!=null && ledgerData!=null?ledgerData[0]['Group_Name']:"",
            title:  ApplicationLocalizations.of(context)!.translate("ledger_group")!,
            callback: (name,id){
              setState(() {
                parentCategory=name!;
                parentCategoryId=(id!);
              });

              _ledgergroupKey.currentState!.validate();
            },
            ledgerName: parentCategory)
    );

      Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("ledger_group")!,
            style: item_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child: Container(
              height: (SizeConfig.screenHeight) * .055,
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
              child:  GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (context != null) {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                              1.0;
                          return Transform(
                            transform:
                            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: a1.value,
                              child: LedegerGroupDialog(
                                mListener: this,
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation2, animation1) {
                          throw Exception('No widget to return in pageBuilder');
                        });
                  }
                },
                child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(parentCategory==""?ApplicationLocalizations.of(context)!.translate("ledger_group")!:parentCategory,
                          style:parentCategory=="" ? item_regular_textStyle:text_field_textStyle,),
                        FaIcon(FontAwesomeIcons.caretDown,
                          color: Colors.black87.withOpacity(0.8), size: 16,)
                      ],
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );

  }

  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("contact_person")! ;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: contactPersonController,
      focuscontroller: _contactPersonFocus,
      focusnext: _addressFocus,
      title:     ApplicationLocalizations.of(context)!.translate("contact_person")! ,
      callbackOnchage: (value) {
        setState(() {
          contactPersonController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* Widget for description text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("address")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: addressController,
      focuscontroller: _addressFocus,
      focusnext: _districtCity,
      title:     ApplicationLocalizations.of(context)!.translate("address")! ,
      callbackOnchage: (value) {
        setState(() {
          addressController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 3,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }


  /* Widget for select contract layout */

  Widget getLeftLayout(double parentHeight, double parentWidth) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: parentWidth * .01),
        child: Column(
          children: [
            getDistrictCityLayout(parentHeight, parentWidth),
          ],
        ),
      ),
    );
  }


  Widget getRightLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .01),
      child: Column(
        children: [
          getPinCodeLayout(parentHeight, parentWidth),
        ],
      ),
    );
  }

  /* Widget for contact no  text from field layout */
  Widget getContactNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("contact_no")! ;
      }
      return null;
    },
      readOnly: widget.readOnly,
      controller: contactController,
      focuscontroller: _contactFocus,
      focusnext: _emailFocus,
      title:   ApplicationLocalizations.of(context)!.translate("contact_no")! ,
      callbackOnchage: (value) {
        setState(() {
          contactController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    );

  }


  /* Widget for  email  text from field layout */
  Widget getEmilLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return     ApplicationLocalizations.of(context)!.translate("enter")! +   ApplicationLocalizations.of(context)!.translate("email_address")! ;
      }
      return null;
    },
      readOnly: widget.readOnly,
      controller: emailController,
      focuscontroller: _emailFocus,
      focusnext: _addTwoFocus,
      title:  ApplicationLocalizations.of(context)!.translate("email_address")! ,
      callbackOnchage: (value) {
        setState(() {
          emailController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z  @ .]')),
    );

  }



  /* Widget for outstanding limit text from field layout */
  Widget getOutstandingLimitLayout(double parentHeight, double parentWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: SingleLineEditableTextFormField(
              controller: outstandingLimitController,
              focuscontroller: _outstandingLimitFocus,
              focusnext: _extNameFocus,
              title: ApplicationLocalizations.of(context)!.translate("outstanding_limit")!,
              callbackOnchage: (value) {
                setState(() {
                  outstandingLimitController.text = value;
                });
              },
              readOnly: widget.readOnly,
              textInput: TextInputType.number,
              maxlines: 1,
              format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              validation: (value) {
                if (value!.isEmpty) {
                  return ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("outstanding_limit")! ;
                }

                return null;
              },
            )

        ),
        AmountTypeDialog(mListener: this,selectedType:selectedLimitUnit,width: 130,mandatory: false,)
        // Container(
        //   height: 50,
        //   width: 130,
        //   margin: EdgeInsets.only(left: 5,top: 30),
        //   child: GestureDetector(
        //     onTap: () {
        //       FocusScope.of(context).requestFocus(FocusNode());
        //       if (context != null) {
        //         showGeneralDialog(
        //             barrierColor: Colors.black.withOpacity(0.5),
        //             transitionBuilder: (context, a1, a2, widget) {
        //               final curvedValue =
        //                   Curves.easeInOutBack.transform(a1.value) -
        //                       1.0;
        //               return Transform(
        //                 transform: Matrix4.translationValues(
        //                     0.0, curvedValue * 200, 0.0),
        //                 child: Opacity(
        //                   opacity: a1.value,
        //                   child: AmountTypeDialog(
        //                     mListener: this,
        //                   ),
        //                 ),
        //               );
        //             },
        //             transitionDuration: Duration(milliseconds: 200),
        //             barrierDismissible: true,
        //             barrierLabel: '',
        //             context: context,
        //             pageBuilder: (context, animation2, animation1) {
        //               throw Exception(
        //                   'No widget to return in pageBuilder');
        //             });
        //       }
        //     },
        //     child: Container(
        //         height: parentHeight * .055,
        //         margin: EdgeInsets.only(top: 10),
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           color: CommonColor.WHITE_COLOR,
        //           borderRadius: BorderRadius.circular(4),
        //           boxShadow: [
        //             BoxShadow(
        //               offset: Offset(0, 1),
        //               blurRadius: 5,
        //               color: Colors.black.withOpacity(0.1),
        //             ),
        //           ],
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               selectedLimitUnit == null ? ApplicationLocalizations.of(context)!.translate("amount_type")!
        //                   : selectedLimitUnit,
        //               style: selectedLimitUnit == null ? item_regular_textStyle : text_field_textStyle,
        //             ),
        //             FaIcon(
        //               FontAwesomeIcons.caretDown,
        //               color: Colors.black87.withOpacity(0.8),
        //               size: 16,
        //             )
        //           ],
        //         )),
        //   ),
        // )

      ],
    );


  }


  Widget getTaxLeftLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(right: parentWidth * .01),
      child: Column(
        children: [

          getHSNLayout(parentHeight,parentWidth),
          getCGSTLayout(parentHeight,parentWidth),
          getCessLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }


  /* Widget for taxt type layout */
  Widget getTaxTypeLayout(double parentHeight, double parentWidth) {
    return Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
          child:  SearchableDropdownWithObjectForTax(
            name:widget.ledgerList!=null && ledgerData!=null?ledgerData[0]['Tax_Type']!=null?ledgerData[0]['Tax_Type']:null:null,
            status:   widget.ledgerList!=null?"edit":"",
            readOnly: widget.readOnly,
            apiUrl:ApiConstants().tax_type+"?",
            titleIndicator: false,
            title: ApplicationLocalizations.of(context)!.translate("tax_type")!,
            callback: (item)async{
              setState(() {
                // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
                taxTypeId = item['code'].toString();
                taxTypeName=item['name'].toString();

              });
            },

          )

      ),
    );


      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              ApplicationLocalizations.of(context)!.translate("tax_type")!,
              style: item_heading_textStyle,
            ),
            GestureDetector(
              onTap: (){
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: TaxDialog(
                            mListener: this,
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation2, animation1) {
                      throw Exception('No widget to return in pageBuilder');
                    });
              },
              onDoubleTap: (){},
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Container(
                  height: parentHeight * .055,
                  alignment: Alignment.center,
                  decoration: box_decoration,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          taxTypeName == "" ? "Select type" : taxTypeName,
                          style: taxTypeName == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: parentHeight * .03,
                          color: /*pollName == ""
                                ? CommonColor.HINT_TEXT
                                :*/
                          CommonColor.BLACK_COLOR,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /* Widget for HSN text from field layout */
  Widget getHSNLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      capital: true,
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("hsn_no")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: hsnNoController,
      focuscontroller: _hsnNoFocus,
      focusnext: _taxRateFocus,
      title: ApplicationLocalizations.of(context)!.translate("hsn_no")!,
      callbackOnchage: (value) {
        setState(() {
          hsnNoController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );


  }



  /* Widget for CGST text from field layout */
  Widget getCGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cgst_percent")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: CGSTController,
      focuscontroller: _CGSTFocus,
      focusnext: _SGSTFocus,
      title: ApplicationLocalizations.of(context)!.translate("cgst_percent")!,
      callbackOnchage: (value) {
     var val= double.parse(value);
          //CGSTController.text = value;

          var v=double.parse(value);
          if(v>100.00){
            var snackBar = SnackBar(content: Text('value should be less than 100.00'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            setState(() {
              CGSTController.text = value;
            });
          }
         // CGSTController.text=(val.toStringAsFixed(2)).toString();
  // String    formattedText = formatDecimal(value);
  //print("formateedddd   $formattedText");

      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }

  String formatDecimal(String value) {
    // Remove existing dots and commas
    value = value.replaceAll('.', '').replaceAll(',', '');

    // Add a dot after every two digits
    RegExp regex = RegExp(r'\B(?=(\d{2})+(?!\d))');
    return value.replaceAllMapped(regex, (match) => '.');
  }


/* Widget for cess text from field layout */
  Widget getCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cess_percent")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: cessController,
      focuscontroller: _cessFocus,
      focusnext: _addCessFocus,
      title: ApplicationLocalizations.of(context)!.translate("cess_percent")!,
      callbackOnchage: (value) {
        setState(() {
         // cessController.text = value;

          var v=double.parse(value);
          if(v>100.00){
            var snackBar = SnackBar(content: Text('value should be less than 100.00'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            setState(() {
              cessController.text = value;
            });
          }
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );


  }





  Widget getTaxRightLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .01),
      child: Column(
        children: [

          getTaxRateLayout(parentHeight,parentWidth),
          getSGSTLayout(parentHeight,parentWidth),
          getAddCessLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }


  /* Widget for taxt category layout */
  Widget getTaxCategoryLayout(double parentHeight, double parentWidth) {
    return Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
          child:  SearchableDropdownWithObjectForTax(
            name:widget.ledgerList!=null && ledgerData!=null? ledgerData[0]['Tax_Category']!=null?ledgerData[0]['Tax_Category']:null:null,
             status:   widget.ledgerList!=null?"edit":"",
            readOnly: widget.readOnly,
            apiUrl:ApiConstants().tax_category+"?",
            titleIndicator: false,
            title: ApplicationLocalizations.of(context)!.translate("tax_category")!,
            callback: (item)async{
              setState(() {
                // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
                taxCategoryId = item['code'].toString();
                taxCategoryName=item['code'].toString();

              });
            },

          )


          // SearchableLedgerDropdown(
          //     apiUrl:ApiConstants().tax_category+"?",
          //     franchisee: widget.ledgerList!=null?"edit":"",
          //     franchiseeName: widget.ledgerList!=null && widget.ledgerList['Tax_Category']!=null?widget.ledgerList['Tax_Category']:"",
          //     title:  ApplicationLocalizations.of(context)!.translate("tax_category")!,
          //     callback: (name,id){
          //       setState(() {
          //         taxCategoryName=name!;
          //         taxCategoryId=(id!);
          //       });
          //
          //     },
          //     ledgerName: taxCategoryName)
      ),
    );



    Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              ApplicationLocalizations.of(context)!.translate("tax_category")!,
              style: item_heading_textStyle,
            ),
            GestureDetector(
              onTap: (){
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: TaxCategoryDialog(
                            mListener: this,
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation2, animation1) {
                      throw Exception('No widget to return in pageBuilder');
                    });
              },
              onDoubleTap: (){},
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Container(
                  height: parentHeight * .055,
                  alignment: Alignment.center,
                  decoration: box_decoration,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            taxCategoryName == "" ? ApplicationLocalizations.of(context)!.translate("select_category")!: taxCategoryName,
                            style: taxCategoryName == ""
                                ? hint_textfield_Style
                                : text_field_textStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            // textScaleFactor: 1.02,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: parentHeight * .03,
                          color: /*pollName == ""
                                ? CommonColor.HINT_TEXT
                                :*/
                          CommonColor.BLACK_COLOR,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /* Widget for tax rate text from field layout */
  Widget getTaxRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("tax_rate")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: taxRateController,
      focuscontroller: _taxRateFocus,
      focusnext: _CGSTFocus,
      title: ApplicationLocalizations.of(context)!.translate("tax_rate")!,
      callbackOnchage: (value) {
        setState(() {
          taxRateController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 \.]')),
    );

  }



  /* Widget for SGST text from field layout */
  Widget getSGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("sgst_percent")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: SGSTController,
      focuscontroller: _SGSTFocus,
      focusnext: _cessFocus,
      title: ApplicationLocalizations.of(context)!.translate("sgst_percent")!,
      callbackOnchage: (value) {
        setState(() {
        //  SGSTController.text = value;
          var v=double.parse(value);
          if(v>100.00){
            var snackBar = SnackBar(content: Text('value should be less than 100.00'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            setState(() {
              SGSTController.text = value;
            });
          }
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }



  /* Widget for add cess text from field layout */
  Widget getAddCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("add_cess_percent")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: addCessController,
      focuscontroller: _addCessFocus,
      focusnext: _bankNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("add_cess_percent")!,
      callbackOnchage: (value) {
        setState(() {
          //addCessController.text = value;
          var v=double.parse(value);
          if(v>100.00){
            var snackBar = SnackBar(content: Text('value should be less than 100.00'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            setState(() {
              addCessController.text = value;
            });
          }
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }






  /* Widget for distric/city text from field layout */
  Widget getDistrictCityLayout(double parentHeight, double parentWidth) {
    return   Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top:3),
        child:  SearchableDropdownForStringArray(
          readOnly: widget.readOnly,
          apiUrl:ApiConstants().city+"?",
          ledgerName: districtController.text,
          franchiseeName:widget.ledgerList!=null &&ledgerData!=null?ledgerData[0]['District']!=null?ledgerData[0]['District'].toString():null:null,
          franchisee: widget.ledgerList!=null&& ledgerData!=null?"edit":"",
          title:  ApplicationLocalizations.of(context)!.translate("city")!,
          callback: (name){
            setState(() {
              districtController.text=name!;
              // cityId=id.toString()!;
            });

            print(districtController.text);
          },
        ),
      ),
    );
      GetDistrictLayout(
        title:  ApplicationLocalizations.of(context)!.translate("city")!,
        callback: (name,id){
          setState(() {
            districtController.text=name!;
            cityId=id!;
          });
        },
        districtName: districtController.text);

  }

  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: const EdgeInsets.only(top:3),
      child: SearchableDropdownForStringArray(
          apiUrl:ApiConstants().state+"?",
          readOnly: widget.readOnly,
          title:  ApplicationLocalizations.of(context)!.translate("state")!,
          callback: (name){

            setState(() {
              stateName=name!;
              // cityId=id.toString()!;
            });

            print(stateName);
          },
          franchiseeName:widget.ledgerList!=null &&ledgerData!=null?ledgerData[0]['State']!=null?ledgerData[0]['State'].toString():null:null,
          franchisee:  widget.ledgerList!=null &&  ledgerData!=null?"edit":"",
          ledgerName: stateName),
    );

      GetStateLayout(
        title:  ApplicationLocalizations.of(context)!.translate("state")!,
        callback: (name,id){
          setState(() {
            stateName=name!;
            stateId=id!;
          });
        },
        stateName: stateName);

  }


  /* Widget for pin code text from field layout */
  Widget getPinCodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: pinCodeController,
      focuscontroller: _pinCodeFocus,
      focusnext: _contactFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("pin_code")!,
      callbackOnchage: (value) {
        setState(() {
          pinCodeController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("pin_code")!;
        }
        return null;
      },
      parentWidth: (SizeConfig.screenWidth ),
    );

  }


  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: const EdgeInsets.only(top:3),
      child: SearchableDropdownForStringArray(
          readOnly: widget.readOnly,
          apiUrl:ApiConstants().country+"?",
          title:  ApplicationLocalizations.of(context)!.translate("country")!,
          callback: (name){

            setState(() {
              countryName=name!;
              // cityId=id.toString()!;
            });

            print(countryName);
          },
          franchiseeName: widget.ledgerList!=null&&ledgerData!=null?ledgerData[0]['Country']!=null?ledgerData[0]['Country'].toString():null:null,
          franchisee:  widget.ledgerList!=null?"edit":"",
          ledgerName: countryName),
    );

      GetCountryLayout(
        title:  ApplicationLocalizations.of(context)!.translate("country")!,
        callback: (name,id){
          setState(() {
            countryName=name!;
            countryId=id!;
          });
        },
        countryName: countryName);

  }


  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("ext_name")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _adharoFocus,
      title:  ApplicationLocalizations.of(context)!.translate("ext_name")!,
      callbackOnchage: (value) {
        setState(() {
          extNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }



  /*Widget for TCS / TDS Applicable Layout*/
  Widget getTCSTDSApplicableLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (mounted) {
                setState(() {
                  if (!checkActiveValue) {
                    checkActiveValue = true;
                  } else {
                    checkActiveValue = false;
                  }
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(top: parentHeight * .01),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: parentHeight * .025,
                      width: parentHeight * .025,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: checkActiveValue == true
                            ? CommonColor.THEME_COLOR
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: checkActiveValue == true
                                ? CommonColor.HINT_TEXT_COLOR
                                .withOpacity(0.5)
                                : CommonColor.THEME_COLOR,
                            width: 1),
                      ),
                      child: Visibility(
                        visible: checkActiveValue,
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(
                            image:
                            AssetImage('assets/images/checkmark.png'),
                            color: CommonColor.WHITE_COLOR,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    left: parentWidth * .02, top: parentHeight * .01),
                child: Text( ApplicationLocalizations.of(context)!.translate("tsc_tds_applicable")!,
                  style: page_heading_textStyle,)
            ),
          ),
        ],
      ),
    );
  }





  /* Widget for bank name text from field layout */
  Widget getBankNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: bankNameController,
      focuscontroller: _bankNameFocus,
      focusnext: _bankBranchFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("bank_name")!,
      callbackOnchage: (value) {
        setState(() {
          bankNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("bank_name")!;
        }

        return null;
      },
    );


  }

  /* Widget for bank branch name text from field layout */
  Widget getBankBranchNameLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      controller: bankBranchController,
      focuscontroller: _bankBranchFocus,
      focusnext: _IFSCCodeFocus,
      readOnly: widget.readOnly,
      title:     ApplicationLocalizations.of(context)!.translate("bank_branch")! ,
      callbackOnchage: (value) {
        setState(() {
          bankBranchController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
        }
        return null;
      },
    );

  }
 /* Widget for IFSC Code text from field layout */
  Widget getFSCCodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: IFSCCodeController,
      focuscontroller: _IFSCCodeFocus,
      focusnext: _aCHolderNameFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("ifsc_branch")!,
      callbackOnchage: (value) {
        setState(() {
          IFSCCodeController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
        }
        return null;
      },
    );

  }

 /* Widget for Account holder name text from field layout */
  Widget getACHolderNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: aCHolderNameController,
      focuscontroller: _aCHolderNameFocus,
      focusnext: _accountNoFocus,
      readOnly: widget.readOnly,
      title:ApplicationLocalizations.of(context)!.translate("ac_holder_name")!,
      callbackOnchage: (value) {
        setState(() {
          aCHolderNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
        }
        return null;
      },
    );

  }

 /* Widget for Account No name text from field layout */
  Widget getAcoountNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: accountNoController,
      focuscontroller: _accountNoFocus,
      focusnext: _bankNameFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("account_no")!,
      callbackOnchage: (value) {
        setState(() {
          accountNoController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
        }
        return null;
      },
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
            onTap: () {
              bool v = _nameKey.currentState!.validate();
              bool q = _ledgergroupKey.currentState!.validate();
              if (mounted && v && q) {
                setState(() {
                  disableColor = true;
                  if(widget.ledgerList!=null){
                    callUpdateLadgerGroup();
                    print("updateeeee");
                  }else{
                    callPostLedgerGroup();
                  }
                });
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
                    child:Text(
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

  @override
  selectTaxCate(String id, String name) {
    // TODO: implement selectTaxCate
    setState(() {
      taxCategoryName=name;
      taxCategoryId=id;
    });
  }

  @override
  selectTaxType(String id, String name) {
    // TODO: implement selectTaxType
    setState(() {
      taxTypeName=name;
      taxTypeId=id;
    });
  }

  callPostLedgerGroup() async {
    String name = nameController.text.trim();
    String contactPerson = contactPersonController.text.trim();
    String address = addressController.text.trim();
    String pinCode = pinCodeController.text.trim();
    String contactNo = contactController.text.trim();
    String emailAdd = emailController.text.trim();
    String outLimit = outstandingLimitController.text.trim();
    String extName = extNameController.text.trim();
    String adharNo = adharNoController.text.trim();
    String panNo = panNoController.text.trim();
    String gstNo = gstNoController.text.trim();
    String hsnNo = hsnNoController.text.trim();
    String taxRate = taxRateController.text.trim();
    String cgstNo = CGSTController.text.trim();
    String sgstNo = SGSTController.text.trim();
    String cess = cessController.text.trim();
    String addCess = addCessController.text.trim();
    String bankName = bankNameController.text.trim();
    String bankBranch = bankBranchController.text.trim();
    String ifscCode = IFSCCodeController.text.trim();
    String accountNo = accountNoController.text.trim();
    String aCHName = aCHolderNameController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostLedgerRequestModel model = PostLedgerRequestModel(
          companyId: companyId,
            name: name,
          Lang: langController.text.trim(),
          groupID: parentCategoryId,
          contactPerson: contactPerson,
          address: address,
          district:districtController.text,
          state: stateName,
          pinCode: pinCode,
          country: countryName,
          contactNo: contactNo,
          eMail: emailAdd,
          pANNo: panNo,
          adharNo: adharNo,
          gSTNo: gstNo,
          cINNo: "",
          fSSAINo: "",
          outstandingLimit: outLimit,
         outstandingLimitType: selectedLimitUnit,
          bankName: bankName,
          bankBranch: bankBranch,
          iFSCCode: ifscCode,
            accountNo: accountNo,
            aCHolderName: aCHName,
            hSNNo: hsnNo,
            gSTRate: "",
            cGSTRate: cgstNo,
            sGSTRate: sgstNo,
            cessRate: cess,
            addCessRate: addCess,
            taxCategory: taxCategoryName,//drop
            Tax_Type: taxTypeName,//drop
            gSTType: "",
            tCSApplicable: "",
            extName: extName,
            remark: "",
            adharCardImage: adharImageBytes,
            pANCardImage: panImageBytes,
            gSTImage: gstImageBytes,
            photo: picImageBytes,
            creator: creatorName,
            creatorMachine: deviceId
        );

        print("jjgjghjghj   ${model.toJson()}");
        String apiUrl = baseurl + ApiConstants().ledger+"?${StringEn.lang}=$lang";


        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                widget.mListener.createPostLedger();
              });


            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });

      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }

  callUpdateLadgerGroup() async {
    String name = nameController.text.trim();
    String contactPerson = contactPersonController.text.trim();
    String address = addressController.text.trim();
    String pinCode = pinCodeController.text.trim();
    String contactNo = contactController.text.trim();
    String emailAdd = emailController.text.trim();
    String outLimit = outstandingLimitController.text.trim();
    String extName = extNameController.text.trim();
    String adharNo = adharNoController.text.trim();
    String panNo = panNoController.text.trim();
    String gstNo = gstNoController.text.trim();
    String hsnNo = hsnNoController.text.trim();
    String taxRate = taxRateController.text.trim();
    String cgstNo = CGSTController.text.trim();
    String sgstNo = SGSTController.text.trim();
    String cess = cessController.text.trim();
    String addCess = addCessController.text.trim();
    String bankName = bankNameController.text.trim();
    String bankBranch = bankBranchController.text.trim();
    String ifscCode = IFSCCodeController.text.trim();
    String accountNo = accountNoController.text.trim();

    String aCHName = aCHolderNameController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String lang = await AppPreferences.getLang();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutLedgerRequestModel model = PutLedgerRequestModel(
          companyId: companyId,
            name: name,
            Lang: langController.text.trim(),
            groupID: parentCategoryId,
            contactPerson: contactPerson,
            address: address,
            district:cityId,
            state: stateId,
            pinCode: pinCode,
            country: countryId,
            contactNo: contactNo,
            email: emailAdd,
            panNo: panNo,
            adharNo: adharNo,
            gstNo: gstNo,
            cinNo: "",
            fssaiNo: "",
            outstandingLimit: outLimit,
            outstandingLimitType: selectedLimitUnit,
            bankName: bankName,
            bankBranch: bankBranch,
            ifscCode: ifscCode,
            accountNo: accountNo,
            acHolderName: aCHName,
            hsnNo: hsnNo,
            gstRate: "",
            cgstRate: cgstNo,
            sgstRate: sgstNo,
            cessRate: cess,
            addCessRate: addCess,
            taxCategory: taxCategoryName,//drop
            Tax_Type: taxTypeName,
            tcsApplicable: "",
            extName: extName,
            remark: "",
            adharCardImage:adharImageBytes.length==0?null: adharImageBytes,
            panCardImage:panImageBytes.length==0?null: panImageBytes,
            gstImage:gstImageBytes.length==0?null: gstImageBytes,
            Photo: picImageBytes.length==0?null:picImageBytes,
            modifier: creatorName,
            modifierMachine: deviceId
        );
        print("MODAL ${model.toJson()}");
        String apiUrl = baseurl + ApiConstants().ledger+"/"+widget.ledgerList['ID'].toString()+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              setState(() {
                editedItem=null;
                widget.mListener.updatePostLedger();
              });
              var snackBar = SnackBar(content: Text('ledger Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, onFailure: (error) {
            print(error.toString());
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
          print(e.toString());
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              print(e.toString());
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  @override
  selectCategory(int id, String name,String nature) {
    // TODO: implement selectCategory
    setState(() {
      parentCategory=name;
      parentCategoryId=id.toString();
    });
  }

  @override
  selectedAmountType(String name) {
    // TODO: implement selectedAmountType
   setState(() {
     selectedLimitUnit=name;
   });
   print(selectedLimitUnit);
  }


}

abstract class CreateExpenseActivityInterface {
  createPostLedger();
  updatePostLedger();
}
