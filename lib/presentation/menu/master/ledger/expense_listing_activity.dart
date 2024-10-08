
import 'dart:convert';
import 'dart:io';
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
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';


class ExpenseListingActivity extends StatefulWidget {
  final  formId;
  final  arrData;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const ExpenseListingActivity({super.key, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

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
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
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
                                ApplicationLocalizations.of(context)!.translate("ledger")!,
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
              onPressed: () async{
                //   add_item_layout(context);
               await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
                  mListener: this,
                 logoImage: widget.logoImage,
                )));
                setState(() {
                  page=1;

                });
                await callGetLedger(page);
              }):Container(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                    const SizedBox(
                      height: .10,
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
  String selectedLedgerName="";
  String selectedLedgerId="";

  /* Widget to get sale ledger Name Layout */
  Widget getSaleLedgerLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().ledgerWithoutImage}?",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("ledger")!,
        franchiseeName: selectedLedgerName!=""? selectedLedgerName:"",
        franchisee:selectedLedgerName,
        callback: (name,id)async{
            setState(() {
              selectedLedgerName = name!;
              selectedLedgerId = id!;
            });
          print(selectedLedgerId);
          var item={
            "Name":name,
            "ID":id
          };
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
              mListener: this,   logoImage: widget.logoImage,
              ledgerList: item,
              readOnly:singleRecord['Update_Right'],
            )));
            setState(() {
              page=0;
            });
            await callGetLedger(1);
        },
        ledgerName: selectedLedgerName);
  }
/*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
           ApplicationLocalizations.of(context).translate("no_data"),
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
            padding: EdgeInsets.only(top: 20),
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
                          logoImage: widget.logoImage,
                          readOnly:singleRecord['Update_Right'],
                        )));
                        setState(() {
                          page=1;
                        });
                         await callGetLedger(page);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            ledgerList[index]['Photo']==null? Container(
                              margin: EdgeInsets.all(5),
                              width:SizeConfig.imageBlockFromCardWidth,
                              height: 80,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/placeholder.png'), // Replace with your image asset path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),

                            ): Container(
                              margin: EdgeInsets.all(5),
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
                                           Text("${ledgerList[index]['Group_Name']}",
                                            style: item_regular_textStyle,),
                                        ],
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?   Positioned(
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
                                    ):Container()
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
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().getFilteredLedger}?Company_ID=$companyId&${StringEn.lang}=$lang&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  //_arrList.clear();
                  _arrList=data;
                  if (_arrList.length < 50) {
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
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
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
        String apiUrl = baseurl + ApiConstants().ledger+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                ledgerList.removeAt(index);
              });
              callGetLedger(1);
            }, onFailure: (error) {
            print(error.toString());
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

            }, onException: (e) {
              print(e.toString());
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              print(e.toString());
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
    callGetLedger(1);
  });
  Navigator.pop(context);
  }

  @override
  updatePostLedger() {
    // TODO: implement updatePostLedger
    setState(() {
      ledgerList.clear();
      callGetLedger(1);
    });
    Navigator.pop(context);
  }

}
