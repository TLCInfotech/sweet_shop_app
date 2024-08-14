
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/master/items/item_create_activity.dart';
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


class ItemsActivity extends StatefulWidget {
  final  formId;
  final  arrData;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const ItemsActivity({super.key, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<ItemsActivity> createState() => _ItemsActivityState();
}

class _ItemsActivityState extends State<ItemsActivity> {
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
      callGetItem(page);
    }
  }
}
@override
void initState() {
  // TODO: implement initState
  super.initState();
  _scrollController.addListener(_scrollListener);
  callGetItem(page);
  setVal();
}
var  singleRecord;
setVal()async{
  List<dynamic> jsonArray = jsonDecode(widget.arrData);
  singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
  print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
}

List<dynamic> itemList = [];
//FUNC: REFRESH LIST
Future<void> refreshList() async {
  print("Here");
  await Future.delayed(Duration(seconds: 2));
  setState(() {
    page=1;
  });
  isPagination = true;
  await callGetItem(page);

}

  String selectedItemName="";
  String selectedItemId="";
  
/* Widget to get sale ledger Name Layout */
  Widget getItemSearchLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():
    SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().item_list}?Date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("item")!,
        franchiseeName: selectedItemName!=""? selectedItemName:"",
        franchisee:selectedItemName,
        callback: (name,id)async{
          setState(() {
            selectedItemName = name!;
            selectedItemId = id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedItemId);
          var item={
            "Name":name,
            "ID":id
          };
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemCreateActivity(
              editItem: item,   logoImage: widget.logoImage,
              readOnly:singleRecord['Update_Right']
          )));
          setState(() {
            page=1;
          });
          await callGetItem(page);
          // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
          //   mListener: this,
          //   ledgerList: item,
          //   readOnly:singleRecord['Update_Right'],
          // )));
          // await callGetLedger(0);
        },
        ledgerName: selectedItemName);
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
                                ApplicationLocalizations.of(context)!.translate("item")!,
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
          floatingActionButton: singleRecord['Insert_Right']==true ?FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemCreateActivity(
                  logoImage: widget.logoImage,
                )));
                setState(() {
                  page=1;
                });
                callGetItem(page);
              }):Container(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getItemSearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                    const SizedBox(
                      height: 10,
                    ),
                    get_items_list_layout()

                  ],
                ),
              ),
              Visibility(
                  visible: itemList.isEmpty && isApiCall  ? true : false,
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
        child:   RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () => refreshList(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              List<int> img=[];
              if( itemList[index]['Photo']!=null){
                img=(itemList[index]['Photo']['data']).whereType<int>().toList();
                print("#################sd ${itemList[index]['Photo']['data']}");
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

                        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemCreateActivity(
                            editItem: itemList[index],
                            logoImage: widget.logoImage,
                        readOnly:singleRecord['Update_Right']
                        )));
                        setState(() {
                          page=1;
                        });
                        callGetItem(page);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            itemList[index]['Photo']==null? Container(
                              margin: EdgeInsets.all(5),
                              // margin: const EdgeInsets.only(left: 10),
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
                              // margin: const EdgeInsets.only(left: 10),
                              margin: EdgeInsets.all(5),
                              width:SizeConfig.imageBlockFromCardWidth,
                              height: 80,
                              decoration:  BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(Uint8List.fromList(img)), // Replace with your image asset path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),

                            )
                            ,
                            Expanded(
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(itemList[index]['Name'],style: item_heading_textStyle,),
                                            itemList[index]['Detail_Desc']!=null? Text(itemList[index]['Detail_Desc'],style: item_regular_textStyle,):Container(),
                                            itemList[index]['Unit']!=null && itemList[index]['Rate']!=null?   Text(itemList[index]['Rate'].toString()+"/"+itemList[index]['Unit'],style: item_heading_textStyle,):Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?     DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await  callDeleteItem(itemList[index]['ID'].toString(),index);
                                        }
                                      },
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


  callGetItem(int page) async {
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
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().getFilteredItem}?Company_ID=$companyId&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {

                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
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

  setDataToList(List<dynamic> _list) {
    if (itemList.isNotEmpty) itemList.clear();
    if (mounted) {
      setState(() {
        itemList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        itemList.addAll(_list);
      });
    }
  }

  callDeleteItem(String removeId,int index) async {
    String baseurl=await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();
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
            modifierMachine: deviceId,
            companyId: companyId,
        );
        String apiUrl = baseurl + ApiConstants().item+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                itemList.removeAt(index);
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
