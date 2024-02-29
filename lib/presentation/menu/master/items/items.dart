
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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


class ItemsActivity extends StatefulWidget {
  const ItemsActivity({super.key});

  @override
  State<ItemsActivity> createState() => _ItemsActivityState();
}

class _ItemsActivityState extends State<ItemsActivity> {
bool isLoaderShow=false;
bool isApiCall = false;
  List<dynamic> item_category=[
    {
      "name":"Category 1",
      "id":123
    },
    {
      "name":"Category 2",
      "id":123
    },
    {
      "name":"Category 3",
      "id":123
    },
  ];

  String? selectedCategory="choose";


  List<dynamic> measuring_unit=[
    {
      "name":"kg",
      "id":123
    },
    {
      "name":"Ltr",
      "id":123
    },
    {
      "name":"Gram",
      "id":123
    },
  ];
ApiRequestHelper apiRequestHelper = ApiRequestHelper();
String parentCategory="";
int parentCategoryId=0;

var editedItem=null;

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
}

List<dynamic> itemList = [];
//FUNC: REFRESH LIST
Future<void> refreshList() async {
  await Future.delayed(Duration(seconds: 2));
  page = 0;
  isPagination = true;
  callGetItem(page);
  return ;
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
                  title: Text(
                    ApplicationLocalizations.of(context)!.translate("item")!,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemCreateActivity()));
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
        child:   RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: itemList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              Uint8List byteArray = Uint8List.fromList([
                // Replace this list with your byte array data
                255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 1, 1, 1, 0, 72, 0, 72, 0, 0,
                255, 219, 67, 0, 5, 3, 4, 4, 4, 3, 5, 4, 4, 4, 5, 5, 5, 6, 7, 12, 8, 7, 7,
                7, 7, 15, 11, 11, 9, 12, 17, 15, 18, 18, 17, 15, 17, 16, 17, 17, 19, 23,
                31, 21, 19, 21, 25, 24, 25, 28, 29, 28, 24, 27, 21, 23, 33, 36, 33, 30, 31,
                35, 27, 28, 34, 39, 30, 33, 29, 32, 28, 28, 38, 41, 37, 40, 34, 43, 35, 32,
                36, 28, 28, 40, 55, 41, 43, 48, 46, 51, 50, 52, 52, 52, 32, 39, 57, 61, 56,
                49, 61, 45, 50, 52, 50, 255, 219, 0, 67, 1, 5, 5, 5, 7, 6, 7, 14, 8, 8, 14,
                30, 20, 17, 20, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
                30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
                30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
                30, 30, 30, 30, 255, 192, 0, 17, 8, 0, 8, 0, 8, 3, 1, 34, 0, 2, 17, 1, 3,
                17, 1, 255, 196, 0, 31, 0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 255, 196, 0, 181, 16, 0, 2, 1, 3, 3, 2,
                4, 3, 5, 5, 4, 4, 0, 0, 1, 125, 1, 2, 3, 0, 4, 17, 5, 18, 33, 49, 65, 6, 19,
                81, 97, 7, 34, 113, 20, 50, 129, 145, 161, 8, 35, 66, 177, 193, 21, 82,
                209, 240, 36, 51, 98, 114, 130, 9, 10, 22, 23, 24, 25, 26, 37, 38, 39, 40,
                41, 42, 52, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84,
                85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116,
                117, 118, 119, 120, 121, 122, 131, 132, 133, 134, 135, 136, 137, 138, 146,
                147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168,
                169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197,
                198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 225,
                226, 227, 228, 229, 230, 231, 232, 233, 234, 241, 242, 243, 244, 245, 246,
                247, 248, 249, 250, 255, 196, 0, 31, 1, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17, 0, 2, 1, 2, 4, 4,
                // End of example byte array
              ]);
              if( itemList[index]['Photo']==null){
                print((itemList[index]['Photo']));
              }
              else{
               // imageBytes=(itemList[index]['Photo']['data']) as List<int>;
               // imageBytes=(itemList[index]['Photo']['data']) as List<int>;
                print((itemList[index]['Photo']['data']));
              }
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width:SizeConfig.imageBlockFromCardWidth,
                            height: 80,
                            decoration: const BoxDecoration(
                                // image: DecorationImage(
                                //   image: AssetImage('assets/images/Login_Background.jpg'), // Replace with your image asset path
                                //   fit: BoxFit.cover,
                                // ),
                                // borderRadius: BorderRadius.only(
                                //   bottomLeft: Radius.circular(10),
                                //   topLeft: Radius.circular(10)
                                // )
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: itemList[index]['Photo']==null?Image(
                              image: AssetImage('assets/images/Login_Background.jpg'),
                            ): Image.memory(byteArray
                                // (itemList[index]['Photo']['data']).buffer.asUint8List()
                            ),
                          ),
                          Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(itemList[index]['Name']+" ${index+1}",style: item_heading_textStyle,),
                                        const Text("The descreption related to sweet if available.",style: item_regular_textStyle,),
                                        const Text("500.00/kg",style: item_heading_textStyle,),

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
                                            await  callDeleteItem(itemList[index]['ID'].toString(),index);
                                          }
                                        },
                                      )

                                      // IconButton(
                                      //   icon:  const FaIcon(
                                      //     FontAwesomeIcons.trash,
                                      //     size: 18,
                                      //     color: Colors.redAccent,
                                      //   ),
                                      //   onPressed: (){
                                      //     callDeleteItem(itemList[index]['ID'].toString(),index);
                                      //     },
                                      // )
                                     )
                                ],
                              )

                          )
                        ],
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
        String apiUrl = "${ApiConstants().baseUrl}${ApiConstants().item}?pageNumber=$page&pageSize=12";
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
        String apiUrl = ApiConstants().baseUrl + ApiConstants().item;
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
