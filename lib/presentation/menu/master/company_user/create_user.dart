import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/common_widget/getFranchisee.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_image_from_gallary_or_camera.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/user/post_user_request_model.dart';
import '../../../../data/domain/user/put_user_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../../dialog/working_under_dialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class UserCreate extends StatefulWidget {
  final editUser;
  final come;
  final compId;
  final readOnly;

  const UserCreate(
      {super.key,
      required this.mListener,
      this.editUser,
      this.compId,
      this.come,
      this.readOnly});

  final UserCreateInterface mListener;

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate>
    with WorkingUnderDialogInterface {
  final _userFocus = FocusNode();
  final userController = TextEditingController();
  final _userNameKey = GlobalKey<FormFieldState>();

  final _workingdaysFocus = FocusNode();
  final workingdaysController = TextEditingController();
  final _workingDayKey = GlobalKey<FormFieldState>();

  final _fnameKey = GlobalKey<FormFieldState>();

  List<int> picImageBytes = [];
  final _passwordFocus = FocusNode();
  final passwordController = TextEditingController();

  final _franchiseFocus = FocusNode();
  final afranchiseController = TextEditingController();

  bool checkPasswordValue = false;
  bool checkActiveValue = false;
  File? picImage;
  String countryName = "";
  String countryId = "";
  String franchiseeName = "";
  String franchiseeId = "";
  String stateName = "";
  String stateId = "";
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isLoaderShow = false;
  bool isApiCall = false;
  final _formkey = GlobalKey<FormState>();
  var userData = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editUser != null) getData();

    localData();
  }

  String companyIds = "";
  localData() async {
    companyIds = await AppPreferences.getCompanyId();
    setState(() {});
  }

  getData() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
            TokenRequestModel(token: sessionToken, page: "1");
        String apiUrl =
            "${baseurl}${ApiConstants().users}/${widget.editUser['UID']}?Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) async {
          setState(() {
            if (data != null) {
              setState(() {
                userData = data;
              });
              print("%%%%%%%%%%%%%%%%%%%%% $userData");
            } else {
              isApiCall = true;
            }
          });
          await setData();
          print("  LedgerLedger  $data ");
        }, onFailure: (error) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          print("Here2=> $e");

          setState(() {
            isLoaderShow = false;
          });
          var val = CommonWidget.errorDialog(context, e);

          print("YES");
          if (val == "yes") {
            print("Retry");
          }
        }, sessionExpire: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  String oldUid = "";
  setData() async {
    if (widget.editUser != null) {
      File? f = null;
      if (userData[0]['Photo'] != null &&
          userData[0]['Photo']['data'] != null &&
          userData[0]['Photo']['data'].length > 10) {
        f = await CommonWidget.convertBytesToFile(userData[0]['Photo']['data']);
      }
      setState(() {
        userController.text = userData[0]["UID"];
        oldUid = userData[0]["UID"];
        print("jhjfhjf  ${userData[0]["Active"]}  $oldUid");
        workingdaysController.text = userData[0]["Working_Days"] != null
            ? userData[0]["Working_Days"].toString()
            : workingdaysController.text;
        franchiseeId = userData[0]["Ledger_ID"].toString();
        franchiseeName = userData[0]["Ledger_Name"];
        checkActiveValue = userData[0]["Active"];
        checkPasswordValue = userData[0]["Reset_Password"];
        picImageBytes = (userData[0]['Photo'] != null &&
                userData[0]['Photo']['data'] != null &&
                userData[0]['Photo']['data'].length > 10)
            ? (userData[0]['Photo']['data']).whereType<int>().toList()
            : [];

        picImage = f;
      });
      setState(() {
        isLoaderShow = false;
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
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    leadingWidth: 0,
                    automaticallyImplyLeading: false,
                    title: Container(
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
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!
                                    .translate("user")!,
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
                  child: Container(
                      child: Form(
                    key: _formkey,
                    child: getAllTextFormFieldLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                  )),
                ),
                widget.readOnly == false
                    ? Container()
                    : Container(
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

  Widget getImageLayout(double parentHeight, double parentWidth) {
    return GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        readOnly: widget.readOnly,
        callbackFile: (file) async {
          if (file != null) {
            List<int> bytes = (await file?.readAsBytes()) as List<int>;
            setState(() {
              picImage = file;
              picImageBytes = bytes;
            });
          } else {
            setState(() {
              picImage = file;
              picImageBytes = [];
            });
          }
        });
  }

  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return isLoaderShow
        ? Container()
        : ListView(
            shrinkWrap: true,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getImageLayout(parentHeight, parentWidth),
                        getNameLayout(parentHeight, parentWidth),
                        getWorkingDaysLayout(parentHeight, parentWidth),
                        // widget.editUser!=null? getPasswordLayout(parentHeight, parentWidth):
                        //  Container(),
                        getFranchiseeLayout(parentHeight, parentWidth),
                        widget.editUser == null
                            ? Container()
                            : getResetPswwordLayout(parentHeight, parentWidth),
                        widget.editUser == null
                            ? Container()
                            : getActiveLayout(parentHeight, parentWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: true,
      txtkey: _userNameKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      readOnly: widget.editUser != null ? false : widget.readOnly,
      controller: userController,
      focuscontroller: _userFocus,
      focusnext: _workingdaysFocus,
      title: ApplicationLocalizations.of(context)!.translate("user_name")!,
      callbackOnchage: (value) {
        setState(() {
          userController.text = value;
        });
        _userNameKey.currentState!.validate();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }

  /* Widget for working days text from field layout */
  Widget getWorkingDaysLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: true,
      txtkey: _workingDayKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "" ;
        }
        return null;
      }, 
      readOnly: widget.readOnly,
      controller: workingdaysController,
      focuscontroller: _workingdaysFocus,
      focusnext: _passwordFocus,
      title: ApplicationLocalizations.of(context)!.translate("working_days")!,
      callbackOnchage: (value) {
        setState(() {
          workingdaysController.text = value;
        });
        _workingDayKey.currentState!.validate();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );
  }

  /* Widget for password  text from field layout */
  Widget getPasswordLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")! +
              ApplicationLocalizations.of(context)!.translate("password")!;
        }
        return null;
      },
      controller: passwordController,
      focuscontroller: _passwordFocus,
      focusnext: _passwordFocus,
      title: ApplicationLocalizations.of(context)!.translate("password")!,
      callbackOnchage: (value) {
        setState(() {
          passwordController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );
  }

  /* Widget for franchisee name text from field layout */
  Widget getFranchiseeLayout(double parentHeight, double parentWidth) {
    return  Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
      child: SearchableLedgerDropdown(
          mandatory: true,
          txtkey: _fnameKey,
          apiUrl: ApiConstants().franchiseeWithCompany + "?",
          titleIndicator: true,
          readOnly: widget.readOnly,
          franchiseeName: widget.come == "edit" ? franchiseeName : "",
          franchisee: widget.come,
          title: ApplicationLocalizations.of(context)!
              .translate("franchisee")!,
          callback: (name, id) {
            if (franchiseeId == id) {
              var snack = SnackBar(
                  content:
                      Text("Sale Ledger and Party can not be same!"));
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else {
              setState(() {
                franchiseeName = name!;
                franchiseeId = id!;
              });
            }
            print("ddddddddd   $franchiseeId");
            _fnameKey.currentState!.validate();
          },
          ledgerName: widget.come == "edit"
              ? franchiseeName
              : ""), /* GestureDetector(
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
                      child:WorkingUnderDialog(
                        mListener: this,
                      ),
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation2, animation1) {
                  throw Exception('No widget to return in pageBuilder');
                });
          },
          onDoubleTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(franchiseeName == "" ? ApplicationLocalizations.of(context)!.translate("franchisee_name")!  : franchiseeName,
                  style:franchiseeName == ""
                      ? hint_textfield_Style
                      : text_field_textStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  // textScaleFactor: 1.02,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: (SizeConfig.screenHeight) * .03,
                  color: */ /*pollName == ""
                      ? CommonColor.HINT_TEXT
                      :*/ /*
                  CommonColor.BLACK_COLOR,
                ),
              ],
            ),
          ),
        ),*/
    );
  }

  /*Widget for Terms and privacy Layout*/
  Widget getResetPswwordLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (widget.readOnly == true) {
                if (widget.editUser != null) {
                  setState(() {
                    if (!checkPasswordValue) {
                      checkPasswordValue = true;
                    } else {
                      checkPasswordValue = false;
                    }
                  });
                }
              } else {}
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
                        color: checkPasswordValue == true
                            ? CommonColor.THEME_COLOR
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: checkPasswordValue == true
                                ? CommonColor.HINT_TEXT_COLOR.withOpacity(0.5)
                                : CommonColor.THEME_COLOR,
                            width: 1),
                      ),
                      child: Visibility(
                        visible: checkPasswordValue,
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(
                            image: AssetImage('assets/images/checkmark.png'),
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
                child: Text(
                  ApplicationLocalizations.of(context)!
                      .translate("reset_password")!,
                  style: page_heading_textStyle,
                )),
          ),
        ],
      ),
    );
  }

  /*Widget for active Layout*/
  Widget getActiveLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (widget.readOnly == true) {
                FocusScope.of(context).requestFocus(FocusNode());
                if (widget.editUser != null) {
                  setState(() {
                    if (!checkActiveValue) {
                      checkActiveValue = true;
                    } else {
                      checkActiveValue = false;
                    }
                  });
                } else {}
              } else {}
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: checkActiveValue == true
                                ? CommonColor.HINT_TEXT_COLOR.withOpacity(0.5)
                                : CommonColor.THEME_COLOR,
                            width: 1),
                      ),
                      child: Visibility(
                        visible: checkActiveValue,
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(
                            image: AssetImage('assets/images/checkmark.png'),
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
                child: Text(
                  ApplicationLocalizations.of(context)!.translate("active")!,
                  style: page_heading_textStyle,
                )),
          ),
        ],
      ),
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
              bool v = _userNameKey.currentState!.validate();
              bool q = _workingDayKey.currentState!.validate();
              bool u = _fnameKey.currentState!.validate();
              if (mounted && v && q && u) {
                if (widget.editUser != null) {
                  callUpdateItem();
                } else {
                  callPostItem();
                }
              }
              // _formkey.currentState?.validate();
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
                    child: Text(
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

  callPostItem() async {
    String workingDay = workingdaysController.text.trim();
    String userName = userController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl = await AppPreferences.getDomainLink();

    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow = true;
      });
      PostUserRequestModel model = PostUserRequestModel(
          uid: userName,
          photo: picImageBytes.length == 0 ? null : picImageBytes,
          Company_ID: companyId,
          ledgerID: franchiseeId,
          workingDays: workingDay,
          // AppType: "F",
          active: true,
          resetPassword: true,
          creator: creatorName,
          creatorMachine: deviceId);

      String apiUrl = baseurl + ApiConstants().users;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess: (data) {
        print("  ITEM  $data ");
        setState(() {
          isLoaderShow = false;
        });
        widget.mListener.createUser();
      }, onFailure: (error) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.errorDialog(context, error.toString());
      }, onException: (e) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.errorDialog(context, e.toString());
      }, sessionExpire: (e) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.gotoLoginScreen(context);
      });
    });
  }

  callUpdateItem() async {
    String baseurl = await AppPreferences.getDomainLink();
    String workingDay = workingdaysController.text.trim();
    String userName = userController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String tokan = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      print("FFFFFFFFFFFFFFFFFFFFFFFFF $userName");
      AppPreferences.getDeviceId().then((deviceId) {
        PutUserRequestModel model = PutUserRequestModel(
          uid: userName,
          Photo: picImageBytes.length == 0 ? null : picImageBytes,
          Company_ID: companyIds,
          ledgerID: franchiseeId,
          // AppType: "",
          workingDays: workingDay,
          active: checkActiveValue,
          resetPassword: checkPasswordValue,
          creator: creatorName,
          creatorMachine: deviceId,
        );
        print("jfhjfhjjhrjhr  $companyId  ${model.toJson()} ");
        String apiUrl = baseurl +
            ApiConstants().users +
            "?Company_ID=$companyId" /*+"/"+widget.editItem['ID'].toString()*/;
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), tokan,
            onSuccess: (value) async {
          setState(() {
            isLoaderShow = false;
          });
          print("  Put Call :   $value ");
          var snackBar =
              const SnackBar(content: Text('User  Updated Successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          widget.mListener.updateUser();
        }, onFailure: (error) {
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          CommonWidget.errorDialog(context, e.toString());
        }, sessionExpire: (e) {
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  @override
  selectWorking(String id, String name) {
    // TODO: implement selectWorking
    setState(() {
      franchiseeName = name;
      franchiseeId = id;
    });
    print("oneee $name  $id  $franchiseeId");
  }
}

abstract class UserCreateInterface {
  createUser();
  updateUser();
}
