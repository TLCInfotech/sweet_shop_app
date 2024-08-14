import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_opening_balance/item_opening_bal_activity.dart';
import '../../../core/app_preferance.dart';
import '../../../core/colors.dart';
import '../../../core/common.dart';
import '../../../core/common_style.dart';
import '../../../core/internet_check.dart';
import '../../../core/localss/application_localizations.dart';
import '../../../core/size_config.dart';
import '../../../data/api/constant.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/commonRequest/get_toakn_request.dart';

class NotificationListing extends StatefulWidget {
  final String logoImage;
  const NotificationListing({super.key, required this.logoImage});

  @override
  State<NotificationListing> createState() => _NotificationListingState();
}

class _NotificationListingState extends State<NotificationListing> {
  bool isLoaderShow=false;
  bool isApiCall = false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  int page = 1;
  bool isPagination = true;
  List notification_list=[];
 /* List notification_list=[
  {
    "title":"Notication Title 1",
    "detail":"Notification details click to continue",
    "id":23,
    "read":false
  },
    {
      "title":"Notication Title 2",
      "detail":"Notification details click to continue",
      "id":23,
      "read":false
    },
    {
      "title":"Notication Title 3",
      "detail":"Notification details click to continue",
      "id":23,
      "read":false
    },
    {
      "title":"Notication Title 4",
      "detail":"Notification details click to continue",
      "id":23,
      "read":true
    },
    {
      "title":"Notication Title 5",
      "detail":"Notification details click to continue",
      "id":23,
      "read":true
    },
    {
      "title":"Notication Title 6",
      "detail":"Notification details click to continue",
      "id":23,
      "read":true
    },
  ];*/

  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetNotifications(page);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetNotifications(page);
    getLocal();
  }
  List MasterMenu=[];
  List TransactionMenu=[];
  var dataArr;
  var dataArrM;
  getLocal()async{
    setState(() {
    });
    var menu =await (AppPreferences.getMasterMenuList());
    var tr =await (AppPreferences.getTransactionMenuList());
    var re =await (AppPreferences.getReportMenuList());
    dataArr=tr;
    dataArrM=menu;
    setState(() {
      MasterMenu=  (jsonDecode(menu)).map((i) => i['Form_ID']).toList();
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });

    print("bnbedbdbnebnedbneebn    $menu");
  }
  Future<void> refreshList() async {
    print("Here");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetNotifications(page);

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
                              ApplicationLocalizations.of(context)!.translate("notifications")!,
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
                  visible: notification_list.isEmpty ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
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
            itemCount: notification_list.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>    ItemOpeningBal(
                          newDate: DateTime.parse(notification_list[index]['Date']),
                          formId: "RM005",    logoImage: widget.logoImage,
                          titleKey: notification_list[index]['Title'],
                          arrData: dataArrM,
                        )));
                        await updatecallPostSaleInvoice(notification_list[index]['ID']);
                        await callGetNotifications(1);
                        callDeleteNotifi(notification_list[index]['ID'].toString(),index);
                        },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: notification_list[index]['Status']=="Read"?Colors.green.withOpacity(0.1):Colors.orange.withOpacity(0.1)
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:notification_list[index]['Status']=="Read"? FaIcon(FontAwesomeIcons.bell): FaIcon(FontAwesomeIcons.solidBell),
                              ),
                              Expanded(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,left: 10,right: 5,bottom: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon( Icons.calendar_month,
                                                    color: Colors.black,),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(notification_list[index]['Date'])),style: item_heading_textStyle,),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              //notification_list[index]['Title']!=null? Text(notification_list[index]['Title'],style: item_heading_textStyle,):Container(),
                                              notification_list[index]['Message']!=null? Text(notification_list[index]['Message'],style: item_regular_textStyle,):Container(),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  )

                              )
                            ],
                          ),
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

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  callGetNotifications(int page) async {
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




        String apiUrl = "${baseurl}${ApiConstants().getAllNotifications}?Company_ID=$companyId&Date=$invoiceDate";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {

                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data['Notifications'];
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
    if (notification_list.isNotEmpty) notification_list.clear();
    if (mounted) {
      setState(() {
        notification_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        notification_list.addAll(_list);
      });
    }
  }


  updatecallPostSaleInvoice(id) async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });

        String apiUrl =baseurl + ApiConstants().updateNotificationStatus+"?Company_ID=$companyId";
     /*   get   http://61.2.227.173:3000/DownloadPdf

            {
          "Company_ID": 74,
        "Order_No": 48,
        "Modifier": "1",
        "Modifier_Machine": "myMachine"
        }*/
        var model={
          "ID": id,
          "Status": "Read"
        };
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model, "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=true;

              });

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
              // widget.mListener.loaderShow(false);
            });

      }); }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  callDeleteNotifi(String removeId, int index) async {
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        //{DateFormat('yyyy-MM-dd').format(DateTime.parse(indexDate))}
        String apiUrl = "$baseurl${ApiConstants().deleteNotification}?Company_ID=$companyId&ID=$removeId&Date=$invoiceDate";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl,"", "",
            onSuccess: (data) {
              setState(() {
                isLoaderShow = false;
                notification_list.removeAt(index);
                callGetNotifications(page);
              });
              print("  LedgerLedger  $data ");
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
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }




}
