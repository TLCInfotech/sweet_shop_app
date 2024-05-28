import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class LedgerVouchersReport extends StatefulWidget {
  const LedgerVouchersReport({super.key});

  @override
  State<LedgerVouchersReport> createState() => _LedgerVouchersReportState();
}

class _LedgerVouchersReportState extends State<LedgerVouchersReport> {
  String reportType = "";
  String reportId = "";

  bool disableColor = false;

  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTo =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  String selectedFranchiseeName="";

  final _expenseFocus = FocusNode();
  final expenseController = TextEditingController();
  String selectedLedgerName="";
  String selectedLedgerId="";
  bool isLoaderShow=false;
  bool isApiCall = false;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        // callGetLedger(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    // callGetLedger(page);
    // setVal();
  }

  var  singleRecord;
  List<dynamic> ledgerList = [];

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    // await callGetLedger(page);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
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
                      Expanded(
                        child: Center(
                          child: Text(
                            ApplicationLocalizations.of(context)!.translate("ledger_voucher")!,
                            style: appbar_text_style,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: getAllTextFormFieldLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ),
            Container(
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeUsedHeight * .1,
                child: getSaveAndFinishButtonLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
          ],
        ),
      ),
    );
  }


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return  Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width:(SizeConfig.halfscreenWidth),
                      child: getDateONELayout(parentHeight, parentWidth)),
                  Container(

                      width:(SizeConfig.halfscreenWidth),
                      child: getDateTwoLayout(parentHeight, parentWidth)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ApplicationLocalizations.of(context)!.translate("ledger_voucher")!,
                style: item_heading_textStyle,),
              get_items_list_layout()
            ],
          ),
        ),
        Visibility(
            visible: ledgerList.isEmpty && isApiCall  ? true : false,
            child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

      ],
    );

      ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: parentWidth * 0.04,
          right: parentWidth * 0.04,
          top: parentHeight * 0.01,
          bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: parentWidth * .01, right: parentWidth * .01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width:(SizeConfig.halfscreenWidth),
                          child: getDateONELayout(parentHeight, parentWidth)),
                      Container(

                          width:(SizeConfig.halfscreenWidth),
                          child: getDateTwoLayout(parentHeight, parentWidth)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /* Widget to get sale ledger Name Layout */
  Widget getSaleLedgerLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().ledgerWithoutImage}?",
        titleIndicator: true,
        title: ApplicationLocalizations.of(context)!.translate("ledger")!,
        franchiseeName: selectedLedgerName!=""? selectedLedgerName:"",
        franchisee:selectedLedgerName,
        callback: (name,id)async{
          setState(() {
            selectedLedgerName = name!;
            selectedLedgerId = id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedLedgerId);
          var item={
            "Name":name,
            "ID":id
          };

          // await callGetLedger(0);
        },
        ledgerName: selectedLedgerName);
  }

  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date){
          setState(() {
            applicablefrom=date!;
          });
        },
        applicablefrom: applicablefrom
    );

  }

  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date){
          setState(() {
            applicableTo=date!;
          });
        },
        applicablefrom: applicableTo
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
            itemCount: 10,
            controller: _scrollController,
            padding: EdgeInsets.only(top: 10),
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
                        // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
                        //   mListener: this,
                        //   ledgerList: ledgerList[index],
                        //   readOnly:singleRecord['Update_Right'],
                        // )));
                        // setState(() {
                        //   page=1;
                        // });
                        // await callGetLedger(page);
                      },
                      child: Card(
                        child: Row(
                          children: [
                           Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("New Diamond Treders",style: item_heading_textStyle,),

                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.fileInvoice ,size: 15,),
                                              SizedBox(width: 10,),
                                              Text("Recipt Voucher No.: 100", style: item_regular_textStyle,),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  FaIcon(FontAwesomeIcons.calendar,size: 15,),
                                                  SizedBox(width: 10,),
                                                  Text("28-05-2024", style: item_regular_textStyle,),
                                                ],
                                              ),
                                              Expanded(
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(CommonWidget.getCurrencyFormat(10000),overflow: TextOverflow.clip,style: item_heading_textStyle,),
                                                      SizedBox(width: 5,),
                                                      Text("CR",style: item_heading_textStyle,)
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ],
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

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Container(
          padding: EdgeInsets.only(top: 10,bottom:5,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Text("Opening Bal. : ${CommonWidget.getCurrencyFormat(double.parse("10000").ceilToDouble())}",style: item_heading_textStyle,),
        ),
        Container(
          padding: EdgeInsets.only(top: 5,bottom:10,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text("Closing Bal: ${CommonWidget.getCurrencyFormat(double.parse("10000").ceilToDouble())}",style: item_heading_textStyle,),
        ),

      ],
    );
  }


}
