import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/profit_loss_dashboard.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';


class ProfitLossDetailActivity extends StatefulWidget {
  final String? comeFor;
  final date;
  final viewWorkDDate;
  final viewWorkDVisible;
  final String logoImage;
  const ProfitLossDetailActivity({super.key, required mListener, this.comeFor, this.date, required this.logoImage, this.viewWorkDDate,this.viewWorkDVisible});

  @override
  State<ProfitLossDetailActivity> createState() => _ProfitLossDetailActivityState();
}

class _ProfitLossDetailActivityState extends State<ProfitLossDetailActivity>with ProfitLossDashInterface {


 // DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  TextEditingController serchvendor=TextEditingController();
  bool viewWorkDVisible=true;

  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.viewWorkDVisible!=null){
      viewWorkDVisible=widget.viewWorkDVisible;
    }
    addDate();
    getExpense(page);
  }

  DateTime newDate= DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));
  addDate() async {
    String dateString = await AppPreferences.getDateLayout(); // Example string date
    newDate = DateTime.parse(dateString);
    print(newDate);
    setState(() {

    });
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
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                  title:  Container(
                    width: SizeConfig.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.comeFor=="dash"? Container(): GestureDetector(
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
                            widget.comeFor!,
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
                margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPurchaseDateLayout(),
                    const SizedBox(
                      height: 10,
                    ),
                    // getFilterLayout(),
                   _profitPartywise.isNotEmpty? getFilterLayout():Container(),
                    get_ledger_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: _profitPartywise.isEmpty && isApiCall  ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  var selectedOption="Profit";
  var selectedOrder="A";

  Widget getFilterLayout(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getTotalCountAndAmount(),
            Container(
              alignment: Alignment.centerRight,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // IconButton(onPressed: (){}, icon: FaIcon(
                  //   FontAwesomeIcons.sortAlphaUpAlt,
                  //   color: Colors.black87,
                  //   size: 18,
                  // ),
                  // ),
                  PopupMenuButton<String>(
                    icon: Row(
                      children: [
                        Text("Sort By",style: item_heading_textStyle,),
                        SizedBox(width: 15,),
                        FaIcon(
                          FontAwesomeIcons.caretDown,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    onSelected: (value) {
                      // Implement your logic based on the selected value
                      // print('Selected: $value');
                      // print(value.split("-"));
                      setState(() {
                        selectedOption=value.split("-")[0];
                        selectedOrder=value.split("-")[1];
                      });
                      print(selectedOption);
                      print(selectedOrder);
                      getExpense(1);
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Profit-A',
                          child: Text('Profit : High-Low'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Profit-D',
                          child: Text('Profit : Low-High'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Vendor_Name-A',
                          child: Text('Vendor : A-Z'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Vendor_Name-D',
                          child: Text('Vendor : Z-A'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
            height:45,
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CommonColor.WHITE_COLOR,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),

            padding: EdgeInsets.only(left: 8),
            child: TextFormField(
              onChanged: (value)async{
                await getExpense(1);
              },
              keyboardType:TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: CommonColor.BLACK_COLOR,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Vendor Name",
                hintStyle: hint_textfield_Style,
                suffixIcon: Icon(Icons.search,color: Colors.grey,),
              ),
              controller: serchvendor,

            )

        )
      ],
    );
  }


  /* Widget to get total count and amount layout */
  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 2,right: 8,bottom: 8),
      child: Container(
          height: 40,
          width: SizeConfig.screenWidth*0.6,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color:TotalAmount>=0? Colors.green:Colors.red,
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
            //  Text("${_profitPartywise.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!}", style: subHeading_withBold,),
              Text("Total : ${CommonWidget.getCurrencyFormat(TotalAmount)}", style: subHeading_withBold,),
            ],
          )
      ),
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

  /* Widget to get add PURCHASE date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            if (date!.isAfter(widget.viewWorkDDate)) {
              viewWorkDVisible=true;
              print("previousDateTitle  ");
            } else {
              viewWorkDVisible=false;
              print("previousDateTitle   ");
            }
            newDate=date!;
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(date));
            _profitPartywise=[];
          });
          getExpense(1);
        },
        applicablefrom: newDate
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
            itemCount: _profitPartywise.length,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              ProfitPartyWiseData model =_profitPartywise.elementAt(index);
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDash(
                          mListener: this,
                        fid: model.Vendor_ID,
                          viewWorkDDate: widget.viewWorkDDate,
                          viewWorkDVisible: viewWorkDVisible,
                          logoImage: widget.logoImage,
                        vName: model.Vendor_Name,
                        )));

                      },
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image(
                                    image: AssetImage("assets/images/hand.png"),
                                    height: 33,
                                    width:33,
                                    color:Colors.black87,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(model.Vendor_Name,style: item_heading_textStyle.copyWith(fontSize: 20),),
                                      model.Profit>=0?  Text("${CommonWidget.getCurrencyFormat(model.Profit)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.green,fontSize: 20),):
                                      Text("${CommonWidget.getCurrencyFormat(model.Profit)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.red,fontSize: 20),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              );
             /* return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: Card(
                      child:Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage("assets/images/hand.png"),
                                  height: 33,
                                  width:33,
                                  color:Colors.black87,
                                ),
                              ),
                              Expanded(child: Text(model.Vendor_Name,style: item_heading_textStyle.copyWith(fontSize: 20),)),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: 8,right: 8,bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Sale : ${CommonWidget.getCurrencyFormat(model.Sale_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                    Text("Return  : ${CommonWidget.getCurrencyFormat(model.Return_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.indigo,)),
                                    Text("Expense : ${CommonWidget.getCurrencyFormat(model.Expense_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.orange),),

                                  ],
                                ),
                                model.Profit>=0?  Text("${CommonWidget.getCurrencyFormat(model.Profit)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.green,fontSize: 20),):
                                 Text("${CommonWidget.getCurrencyFormat(model.Profit)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.red,fontSize: 20),),
                              ],
                            ),
                          ),


                        ],
                      )
                    ),
                  ),
                ),
              );*/
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }

  List<ProfitPartyWiseData> _profitPartywise = [];

  var TotalAmount=0.00;

  getExpense(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().dashboardProfitPartywise}?Company_ID=$companyId&${StringEn.lang}=$lang&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&VendorName=${serchvendor.text}&SortBy=$selectedOption&SortOrder=$selectedOrder";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                _profitPartywise=[];
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  for (var item in data['DashboardProfitDetailPartywise']) {
                    _profitPartywise.add(ProfitPartyWiseData(DateFormat("dd/MM").format(DateTime.parse(item['Date'])), (item['Profit']),(item['Vendor_Name']),(item['Sale_Amount']),(item['Expense_Amount']),(item['Return_Amount']),(item['Vendor_ID'])));
                  }
                  //TotalAmount= data['TotalProfit'].toString();
                  TotalAmount=double.parse(data['TotalProfit'].toString());
                  print("getDashboardProfitDetailpartywise    $_profitPartywise");
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

}


class ProfitPartyWiseData {
  final String Date;
  final String Vendor_Name;
   var Profit;
  var Sale_Amount;
  var Expense_Amount;
  var Return_Amount;
 var Vendor_ID;

  ProfitPartyWiseData(this.Date, this.Profit, this.Vendor_Name,this.Sale_Amount,this.Expense_Amount,this.Return_Amount,this.Vendor_ID);
}