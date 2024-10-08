import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/measuring_unit/delete_measuring_unit_request_model.dart';
import '../../../../data/domain/measuring_unit/post_measuring_unit_request_model.dart';
import '../../../../data/domain/measuring_unit/put_measuring_unit_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../searchable_dropdowns/searchable_dropdown_for_string_array.dart';


class UnitsActivity extends StatefulWidget {
  final  formId;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  final  arrData;final String logoImage;
  const UnitsActivity({super.key, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<UnitsActivity> createState() => _UnitsActivityState();
}

class _UnitsActivityState extends State<UnitsActivity> {
  final _formkey=GlobalKey<FormState>();
  TextEditingController unitName = TextEditingController();
  int page = 1;
  bool isPagination = true;
  List<dynamic> measuring_unit = [];
  //List measuringUnit = [];
  ScrollController _scrollController = new ScrollController();
  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var editedItem=null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeasuringUnit();
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }
  //FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    await getMeasuringUnit();
  }


  String selectedUnitName="";
  String selectedUnitId="";
/* Widget to get sale ledger Name Layout */
  Widget getFranchiseeSearchLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():
    SearchableDropdownForStringArray(
        apiUrl: "${ApiConstants().measuring_unit}?",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context).translate("unit"),
        franchiseeName: selectedUnitName!=""? selectedUnitName:"",
        franchisee:selectedUnitName,
        callback: (name)async{
          setState(() {
            selectedUnitName = name!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedUnitId);

              setState(() {
            editedItem=name;
            unitName.text=name!;
            mesuringText=name!;
          });

         await add_unit_layout(context,singleRecord['Update_Right'],editedItem);
         setState(() {
           selectedUnitName="";
         });
         await  getMeasuringUnit();
          // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
          //   mListener: this,
          //   ledgerList: item,
          //   readOnly:singleRecord['Update_Right'],
          // )));
          // await callGetLedger(0);
        },
        ledgerName: selectedUnitName);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          // backgroundColor: Colors.white.withOpacity(0.95),
          backgroundColor: const Color(0xFFfffff5),
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: SafeArea(
              child:  Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
                color: Colors.transparent,
                // color: Colors.red,
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
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
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
                                style: appbar_text_style,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          floatingActionButton:singleRecord['Insert_Right']==true ? FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  editedItem="";
                  unitName.text="";
                  mesuringText=" ";
                });
                add_unit_layout(context,true,null);
              }):Container(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFranchiseeSearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                    const SizedBox(
                      height: 10,
                    ),
                    get_unit_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: measuring_unit.isEmpty && isApiCall  ? true : false,
                  child: CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth, ApplicationLocalizations.of(context).translate("no_data"))),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  String mesuringText="";
  
  Expanded get_unit_list_layout() {
    return Expanded(
        child:RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: measuring_unit.length,
            itemBuilder: (BuildContext context, int index) {
              print("hhjjhhjjh ${ measuring_unit[index]}");
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          editedItem=measuring_unit[index];
                          unitName.text=measuring_unit[index];
                          mesuringText=measuring_unit[index];
                        });

                        add_unit_layout(context,singleRecord['Update_Right'],editedItem);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width:60,
                              height: 40,
                              decoration:  BoxDecoration(
                                  color: index %2==0?const Color(0xFFEC9A32):const Color(0xFF7BA33C),
                                  borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),
                              alignment: Alignment.center,
                              child: Text("${(index+1).toString()}",style: const TextStyle(),),
                            ),
                            Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin:  const EdgeInsets.only(top: 15,left: 10,right: 40,bottom: 15),
                                      child: measuring_unit[index]!=null? Text(
                                        measuring_unit[index],style: item_heading_textStyle,):Container(),
                                    ),

                                    singleRecord['Delete_Right']==true? Positioned(
                          top: 0,
                          right: 0,
                          child: DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await callDeleteMeasuringUnit(measuring_unit[index],index);

                                        }
                                      },
                                    )):Container()
                                  ],
                                )

                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));


  }

  Future<dynamic> add_unit_layout(BuildContext context,updateRight,editedItemss) {
    return  showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
              1.0;
          return Transform(
            transform:
            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
                      child: Container(
                        height: SizeConfig.screenHeight*0.25,
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
                                    ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
                                    style: page_heading_textStyle
                                ),
                              ),
                            ),

                        SingleLineEditableTextFormField(
                          validation: (value) {
                            if (value!.isEmpty) {
                              return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("measuring_unit")!;
                            }
                            return null;
                          },
                          readOnly:updateRight ,
                          controller: unitName,
                          focuscontroller: null,
                          focusnext: null,
                          title: ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
                          callbackOnchage: (value) {
                            setState(() {
                              unitName.text = value;
                            });
                          },
                          textInput: TextInputType.text,
                          maxlines: 1,
                          format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
                        )

                          ],
                        ),
                      ),
                    ),
                    getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth,editedItemss),
                  ],
                ),
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
  }

  Widget getCloseButton(double parentHeight, double parentWidth, editedItemss){
    return singleRecord['Update_Right']==false? GestureDetector(
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
    ): Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: Row(
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
              if(editedItemss!=null){
                print("jgbgbgbggn");
                updateMeasuringUnit();
              }else{
                postMeasuringUnit();
              }
            //  Navigator.pop(context);

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
      ),
    );
  }

  getMeasuringUnit()async{
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: ""
        );
        String apiUrl = "${baseurl}${ApiConstants().measuring_unit}?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  print("responseeee   $data");
                  measuring_unit=data;
                  print("hjfjf  ${measuring_unit.length}");
                }else{
                  isApiCall=true;
                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
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
              // widget.mListener.loaderShow(false);
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


  postMeasuringUnit() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    String unitMName=unitName.text.trim();
    String creatorName = await AppPreferences.getUId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostMeasuringUnitRequestModel model = PostMeasuringUnitRequestModel(
        code: unitMName,
          creatorMachine: deviceId,
          Lang: lang,
          creator: creatorName,
          companyId: companyId
      );
      print("bjbccbb  $model");
      //  print("IMGE2 : ${(model.Photo)?.length}");
      String apiUrl = baseurl + ApiConstants().measuring_unit;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            getMeasuringUnit();
            Navigator.pop(context);
            }, onFailure: (error) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, error.toString());
          },
          onException: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.gotoLoginScreen(context);
          });

    });
  }

  updateMeasuringUnit() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String lang = await AppPreferences.getLang();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PutMeasuringUnitRequestModel model = PutMeasuringUnitRequestModel(
          companyId:companyId ,
          code: mesuringText,
          newCode: unitName.text,
          modifier:creatorName ,
          modifierMachine: deviceId
      );
      //  print("IMGE2 : ${(model.Photo)?.length}");
      String apiUrl = "${baseurl}${ApiConstants().measuring_unit}?Company_ID=$companyId&${StringEn.lang}=$lang";
      apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            getMeasuringUnit();
            var snackBar = const SnackBar(content: Text('measuring unit updated succesfully'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
             Navigator.pop(context);
          }, onFailure: (error) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, error.toString());
          },
          onException: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.gotoLoginScreen(context);
          });

    });
  }


  callDeleteMeasuringUnit(String removeId,int index) async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String uid = await AppPreferences.getUId();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        DeleteMeasuringUnitRequestModel model = DeleteMeasuringUnitRequestModel(
            code:removeId,
            modifier: uid,
            modifierMachine: deviceId,
            companyId: companyId
        );
        String apiUrl = baseurl + ApiConstants().measuring_unit+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                measuring_unit.removeAt(index);
              });
              print("  LedgerLedger  $data ");
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

}
