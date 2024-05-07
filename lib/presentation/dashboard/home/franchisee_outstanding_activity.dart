import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/franchisee_outstanding_dash_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/expense/create_ledger_activity.dart';
import 'package:textfield_search/textfield_search.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../core/string_en.dart';
import '../../common_widget/signleLine_TexformField.dart';

class FranchiseeOutstandingDetailActivity extends StatefulWidget {
  final String? comeFor;
  final date;
  final profit;
  const FranchiseeOutstandingDetailActivity({super.key, required mListener, this.comeFor, this.date, this.profit});

  @override
  State<FranchiseeOutstandingDetailActivity> createState() => _FranchiseeOutstandingDetailActivityState();
}

class _FranchiseeOutstandingDetailActivityState extends State<FranchiseeOutstandingDetailActivity>with FOutstandingDashActivityInterface {

  TextEditingController serchvendor=TextEditingController();


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
    //   _scrollController.addListener(_scrollListener);
   // newDate=widget.date;
    addDate();
    getOutstandings(page);
    print("hghdghdghdgh  ${widget.comeFor}");
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
        getOutstandings(page);
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
    await getOutstandings(page);
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
                    _outstandingPartywise.isNotEmpty? getFilterLayout():Container(),
                    get_ledger_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: _outstandingPartywise.isEmpty && isApiCall  ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  var selectedOption="Outstanding";
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
                      getOutstandings(1);
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Outstanding-A',
                          child: Text('Outstanding : High-Low'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Outstanding-D',
                          child: Text('Outstanding : Low-High'),
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
                await getOutstandings(1);
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
              color:int.parse(TotalAmount)>=0? Colors.green:Colors.red,
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
              //  Text("${_outstandingPartywise.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!}", style: subHeading_withBold,),
              Text("Total : ${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}", style: subHeading_withBold,),
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
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(date));
            _outstandingPartywise=[];
          });
          getOutstandings(1);
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
            itemCount: _outstandingPartywise.length,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              FranchiseeOutstandingData model =_outstandingPartywise.elementAt(index);
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FOutstandingDashActivity(mListener: this,
                          fid: model.Vendor_ID,
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
                                      model.Outstanding>=0?  Text("${CommonWidget.getCurrencyFormat(model.Outstanding)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.green,fontSize: 20),):
                                      Text("${CommonWidget.getCurrencyFormat(model.Outstanding)}",overflow: TextOverflow.clip,style: big_title_style.copyWith(color: Colors.red,fontSize: 20),),
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
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }

  List<FranchiseeOutstandingData> _outstandingPartywise = [];

  String TotalAmount="0.00";

  getOutstandings(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getDashboardOutstandingPartywise}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&VendorName=${serchvendor.text}&SortBy=$selectedOption&SortOrder=$selectedOrder";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                _outstandingPartywise=[];
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  for (var item in data['OutstandingPartywise']) {
                    _outstandingPartywise.add(FranchiseeOutstandingData(DateFormat("dd/MM").format(DateTime.parse(item['Date'])), (item['Outstanding']),(item['Vendor_Name']),(item['Vendor_ID'])));
                  }
                  TotalAmount= data['TotalOutstandingAmount'].toString();
                  print("getDashboardProfitDetailpartywise    $_outstandingPartywise");
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


class FranchiseeOutstandingData {
  final String Date;
  final String Vendor_Name;
  final int Outstanding;
  final int Vendor_ID;

  FranchiseeOutstandingData(this.Date, this.Outstanding, this.Vendor_Name,this.Vendor_ID);
}