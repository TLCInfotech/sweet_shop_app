import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/journal/create_journal_voucher.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/payment/create_payment_activity.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';



class JournalVoucherActivity extends StatefulWidget {
  final String? comeFor;
  const JournalVoucherActivity({super.key, required mListener, this.comeFor});
  @override
  State<JournalVoucherActivity> createState() => _PaymentActivityState();
}

class _PaymentActivityState extends State<JournalVoucherActivity>with CreateJournalInterface {

  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> payment_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    getJournals(page);
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getJournals(page);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ApplicationLocalizations.of(context)!.translate("journal_voucher")!,
                style: appbar_text_style,),
              automaticallyImplyLeading:widget.comeFor=="dash"? false:true,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateJournals(
              mListener: this,
              dateNew:   CommonWidget.getDateLayout(newDate),
              voucherNo: null,//DateFormat('dd-MM-yyyy').format(newDate),
            )));
          }),
      body: Container(
        margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            getPurchaseDateLayout(),
            const SizedBox(
              height: 10,
            ),
            payment_list.isNotEmpty?getTotalCountAndAmount():Container(),
            const SizedBox(
              height: .5,
            ),
            get_payment_list_layout()
          ],
        ),
      ),
    );
  }

  /* Widget to get add purchase date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            newDate=date!;
            payment_list=[];
          });
          getJournals(1);
        },
        applicablefrom: newDate

    );
  }

  /* Widget to get total count and amount Layout */
  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          width: SizeConfig.screenWidth*0.9,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${payment_list.length} ${ApplicationLocalizations.of(context)!.translate("journal")!}", style: subHeading_withBold,),
              // Text(CommonWidget.getCurrencyFormat(200000), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }


  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }

  /* Widget to get add payment list Layout */
  Expanded get_payment_list_layout() {
    return Expanded(
        child: ListView.separated(
          itemCount: payment_list.length,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateJournals(
                        mListener: this,
                        dateNew:   CommonWidget.getDateLayout(newDate),
                        voucherNo: payment_list[index]['Voucher_No'],//DateFormat('dd-MM-yyyy').format(newDate),
                      )));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: (index)%2==0?Colors.green:Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child:  const FaIcon(
                                  FontAwesomeIcons.moneyCheck,
                                  color: Colors.white,
                                )
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
                                          Text("${payment_list[index]['Ledger_Name']}",style: item_heading_textStyle,),
                                          const SizedBox(height: 5,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                              const SizedBox(width: 10,),
                                              Expanded(child: Text("Voucher No: - ${payment_list[index]['Voucher_No']}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                              const SizedBox(width: 10,),
                                              Expanded(child: Text("${CommonWidget.getCurrencyFormat(payment_list[index]['Amount'])}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
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
                                        await   callDeleteExpense(payment_list[index]['Voucher_No'].toString(),payment_list[index]['Seq_No'].toString(),index);
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
            return const SizedBox(
              height: 5,
            );
          },
        ));
  }


  getJournals(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().getPaymentVouvher}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&Voucher_Name=Journal&pageNumber=$page&pageSize=10";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  setState(() {
                    payment_list=_arrList;
                  });
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

  callDeleteExpense(String removeId,String seqNo,int index) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Voucher_No": removeId,
          "Voucher_Name": "Journal",
          "Seq_No":seqNo,
          "Modifier": uid,
          "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().getPaymentVouvher+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                payment_list.removeAt(index);

              });
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

  @override
  backToList(DateTime date) {
    // TODO: implement backToList
    setState(() {
      payment_list=[];
      newDate=date;
    });
    getJournals(1);
    Navigator.pop(context);
  }
}
