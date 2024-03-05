
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger/create_expense_activity.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/delete_request_model.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';


class ExpenseListingActivity extends StatefulWidget {
  const ExpenseListingActivity({super.key});

  @override
  State<ExpenseListingActivity> createState() => _ExpenseListingActivityState();
}

class _ExpenseListingActivityState extends State<ExpenseListingActivity>with CreateExpenseActivityInterface {
  TextEditingController itemName = TextEditingController();
  TextEditingController itemRate = TextEditingController();
  TextEditingController itemPkgSize = TextEditingController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  String parentCategory="";
  int parentCategoryId=0;
  bool isLoaderShow=false;
  bool isApiCall = false;
  var editedItem=null;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetLedger(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetLedger(page);
  }

  List<dynamic> ledgerList = [];
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetLedger(page);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
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
                  title:  Text(
                    ApplicationLocalizations.of(context)!.translate("ledger")!,
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
              onPressed: () async{
                //   add_item_layout(context);
               await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
                  mListener: this,
                )));
                setState(() {
                  page=1;
                });
                await callGetLedger(page);
              }),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: .5,
                    ),
                    get_items_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: ledgerList.isEmpty && isApiCall  ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }
/*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "No data available.",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 4.2,
            fontFamily: 'Inter_Medium_Font',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Expanded get_items_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ledgerList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              List<int> img=[];
              if( ledgerList[index]['Photo']!=null){
                img=(ledgerList[index]['Photo']['data']).whereType<int>().toList();
                print("#################sd ${ledgerList[index]['Photo']['data']}");
              }

              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: ()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
                          mListener: this,
                          ledgerList: ledgerList[index],
                        )));
                        setState(() {
                          ledgerList=[];
                          page=1;
                        });
                         callGetLedger(page);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            ledgerList[index]['Photo']==null? Container(
                              margin: const EdgeInsets.only(left: 10),
                              width:SizeConfig.imageBlockFromCardWidth,
                              height: 80,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/Login_Background.jpg'), // Replace with your image asset path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),

                            ): Container(
                              margin: const EdgeInsets.only(left: 10),
                              width:SizeConfig.imageBlockFromCardWidth,
                              height: 80,
                              decoration:  BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(Uint8List.fromList(img)), // Replace with your image asset path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),

                            )
                            ,
                            Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ledgerList[index]['Name'],style: item_heading_textStyle,),
                                          const Text("Leadger group name",
                                            style: item_regular_textStyle,),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child:DeleteDialogLayout(
                                          callback: (response ) async{
                                            if(response=="yes"){
                                              print("##############$response");
                                              await  callDeleteItem(ledgerList[index]['ID'].toString(),index);
                                            }
                                          },
                                        )
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
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }

  callGetLedger(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
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
        String apiUrl = "${ApiConstants().baseUrl}${ApiConstants().ledger}?pageNumber=$page&pageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList.clear();
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

  setDataToList(List<dynamic> _list) {
    if (ledgerList.isNotEmpty) ledgerList.clear();
    if (mounted) {
      setState(() {
        ledgerList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        ledgerList.addAll(_list);
      });
    }
  }

  callDeleteItem(String removeId,int index) async {
    String uid = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        DeleteIRequestModel model = DeleteIRequestModel(
            id:removeId,
            modifier: uid,
            modifierMachine: deviceId
        );
        String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger;
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                ledgerList.removeAt(index);
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
  createPostLedger() {
    // TODO: implement createPostLedger
  setState(() {
    ledgerList.clear();
    callGetLedger(0);
  });
  Navigator.pop(context);
  }

  @override
  updatePostLedger() {
    // TODO: implement updatePostLedger
    setState(() {
      ledgerList.clear();
      callGetLedger(0);
    });
    Navigator.pop(context);
  }

}
