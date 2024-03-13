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


class UnitsActivity extends StatefulWidget {
  const UnitsActivity({super.key});

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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),

                  backgroundColor: Colors.white,
                  title: Text(
                    ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
                    style: appbar_text_style,),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                add_unit_layout(context);
              }),
          body: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                get_unit_list_layout()
              ],
            ),
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  String mesuringText="";
  
  Expanded get_unit_list_layout() {
    return Expanded(
        child: ListView.separated(
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

                      add_unit_layout(context);
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
                            child: Text("${(index+1).toString().padLeft(2, '0')}",style: const TextStyle(),),
                          ),
                          Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin:  const EdgeInsets.only(top: 15,left: 10,right: 40,bottom: 15),
                                    child: measuring_unit[index]!=null? Text(
                                      measuring_unit[index],style: item_heading_textStyle,):Container(),
                                  ),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: DeleteDialogLayout(
                                    callback: (response ) async{
                                      if(response=="yes"){
                                        print("##############$response");
                                        await callDeleteMeasuringUnit(measuring_unit[index],index);

                                      }
                                    },
                                  ))
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
        ));


  }

  Future<dynamic> add_unit_layout(BuildContext context) {
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
                    getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
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

  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
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
              if(editedItem!=null){
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
        String apiUrl = "${baseurl}${ApiConstants().measuring_unit}?Company_ID=$companyId";
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
    String unitMName=unitName.text.trim();
    String creatorName = await AppPreferences.getUId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostMeasuringUnitRequestModel model = PostMeasuringUnitRequestModel(
        code: unitMName,
          creatorMachine: deviceId,
          creator: creatorName,
          companyId: companyId
      );
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
      String apiUrl = "${baseurl}${ApiConstants().measuring_unit}?Company_ID=$companyId";
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
        String apiUrl = baseurl + ApiConstants().measuring_unit+"?Company_ID=$companyId";
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
