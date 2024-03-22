import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/expense/create_ledger_activity.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';



class LedgerActivity extends StatefulWidget {
  final String? comeFor;
  const LedgerActivity({super.key, required mListener, this.comeFor});

  @override
  State<LedgerActivity> createState() => _LedgerActivityState();
}

class _LedgerActivityState extends State<LedgerActivity>with CreateLedgerInterface {

  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> expense_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    getExpense(page);
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getExpense(page);
      }
    }
  }
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await getExpense(page);
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
                    ApplicationLocalizations.of(context)!.translate("expense_invoice")!,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLedger(
                  mListener: this,
                  voucherNo: "",
                  dateNew:     CommonWidget.getDateLayout(newDate),
                 // DateFormat('dd-MM-yyyy').format(newDate),
                )));
              }),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPurchaseDateLayout(),
                    const SizedBox(
                      height: 10,
                    ),
                    expense_list.isNotEmpty?getTotalCountAndAmount()
                        :Container(),
                    const SizedBox(
                      height: .5,
                    ),
                    get_ledger_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: expense_list.isEmpty && isApiCall  ? true : false,
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

  /* Widget to get add PURCHASE date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            newDate=date!;
            expense_list=[];
          });
          getExpense(1);
        },
        applicablefrom: newDate
    );
  }

  /* Widget to get total count and amount layout */
  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          width: SizeConfig.screenWidth*0.9,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
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
               Text("${expense_list.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!}", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
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

  /* widget for get ledger list layout */
  Expanded get_ledger_list_layout() {
    return Expanded(
        child:  RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            itemCount: expense_list.length,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLedger(
                          mListener: this,
                          voucherNo: expense_list[index]["Voucher_No"].toString(),
                          dateNew:     CommonWidget.getDateLayout(newDate),
                          // DateFormat('dd-MM-yyyy').format(newDate),
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
                                             Text(expense_list[index]["Ledger_Name"],style: item_heading_textStyle,),
                                            const SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                                const SizedBox(width: 10,),
                                                 Expanded(child: Text("Voucher No. - ${expense_list[index]["Fin_Voucher_No"]}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                                const SizedBox(width: 10,),
                                                Expanded(child: Text("${CommonWidget.getCurrencyFormat(expense_list[index]["Total_Amount"])}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
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
                                          await   callDeleteExpense(expense_list[index]['Voucher_No'].toString(),index);
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
          ),
        ));
  }
  String TotalAmount="0.00";
  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in expense_list ){
      total=total+item['Total_Amount'];
      print(item['Total_Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  getExpense(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().expense_voucher}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&pageNumber=$page&pageSize=12";
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
                calculateTotalAmt();
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
    if (expense_list.isNotEmpty) expense_list.clear();
    if (mounted) {
      setState(() {
        expense_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        expense_list.addAll(_list);
      });
    }
  }

  callDeleteExpense(String removeId,int index) async {
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
       "Modifier": uid,
       "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().expense_voucher+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                expense_list.removeAt(index);
                calculateTotalAmt();
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
  backToList() {
    // TODO: implement backToList
    getExpense(1);
    Navigator.pop(context);
  }
}
