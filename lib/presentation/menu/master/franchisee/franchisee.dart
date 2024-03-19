import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee/franchisee_create_activity.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/delete_request_model.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';


class AddFranchiseeActivity extends StatefulWidget {
  const AddFranchiseeActivity({super.key, required mListener});

  @override
  State<AddFranchiseeActivity> createState() => _AddFranchiseeActivityState();
}

class _AddFranchiseeActivityState extends State<AddFranchiseeActivity> {

  bool isLoaderShow=false;
  bool isApiCall = false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetFranchisee(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetFranchisee(page);
  }

  List<dynamic> franchiseeList = [];
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    print("Here");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetFranchisee(page);

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: Color(0xFFfffff5),
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
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                child: AppBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),

                  backgroundColor: Colors.white,
                  title: Text(
                    ApplicationLocalizations.of(context)!.translate("franchisee")!,
                    style: appbar_text_style,),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xFFFBE404),
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFranchisee()));
                setState(() {
                  page=1;
                });
                await callGetFranchisee(page);
              }),
          body:Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    get_franchisee_list_layout()

                  ],
                ),
              ),
              Visibility(
                  visible: franchiseeList.isEmpty && isApiCall  ? true : false,
                  child:CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
            ],
          )
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  Expanded get_franchisee_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () => refreshList(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: franchiseeList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                    verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: ()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateFranchisee(editItem: franchiseeList[index],)));
                        setState(() {
                          page=1;
                        });
                        callGetFranchisee(page);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: (index)%2==0?Colors.green:Colors.blueAccent,
                                child:  FaIcon(
                                  FontAwesomeIcons.user,
                                  color: Colors.white,
                                )
                                // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
                              ),
                            ),
                            Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     Expanded(
                                       child: Container(
                                        margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(franchiseeList[index]['Name'],style: item_heading_textStyle,),
                                            SizedBox(height: 5,),
                                            franchiseeList[index]['Contact_No']!=null? Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(FontAwesomeIcons.phone,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(child: Text(franchiseeList[index]['Contact_No'],overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ],
                                            ):Container(),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                FaIcon(FontAwesomeIcons.locationDot,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        franchiseeList[index]['Address']!=null?TextSpan(text:"${franchiseeList[index]['Address']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['District']!=null?TextSpan(text:"${franchiseeList[index]['District']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['State']!=null?TextSpan(text:"${franchiseeList[index]['State']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['Pin_Code']!=null?TextSpan(text:"- ${franchiseeList[index]['Pin_Code']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                       
                                                      ],
                                                    ),
                                                  ),
                                                )
                                       
                                              ],
                                            ),
                                       
                                          ],
                                        ),
                                                                           ),
                                     ),
                                    DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await  callDeleteFranchisee(franchiseeList[index]['ID'].toString(),index);
                                        }
                                      },
                                    )
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
              return SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }


  callGetFranchisee(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().franchisee}?Company_ID=$companyId&pageNumber=$page&pageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  if (_arrList.length < 10) {
                    if (mounted) {
                      setState(() {
                        isPagination = false;
                      });
                    }
                  }
                  if (page == 1) {
                    setDataToList(_arrList);
                  } else {
                    setMoreDataToList(_arrList);
                  }
                }else{
                  isApiCall=true;
                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
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

  setDataToList(List<dynamic> _list) {
    if (franchiseeList.isNotEmpty) franchiseeList.clear();
    if (mounted) {
      setState(() {
        franchiseeList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        franchiseeList.addAll(_list);
      });
    }
  }

  callDeleteFranchisee(String removeId,int index) async {
    String uid = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        DeleteIRequestModel model = DeleteIRequestModel(

            id:removeId,
            modifier: uid,
            modifierMachine: deviceId,
            companyId: companyId
        );
        String apiUrl = baseurl + ApiConstants().franchisee+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                franchiseeList.removeAt(index);
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
