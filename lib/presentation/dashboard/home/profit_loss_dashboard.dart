import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:countup/countup.dart';
import 'package:sweet_shop_app/presentation/dashboard/purchase_mrp/purchase_mrp_activity.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../menu/master/item_opening_balance/create_item_opening_bal_activity.dart';
import '../../menu/transaction/credit_note/credit_note_activity.dart';
import '../../menu/transaction/expense/ledger_activity.dart';
import '../../menu/transaction/sell/sell_activity.dart';
import 'home_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ProfitLossDash extends StatefulWidget {
  final ProfitLossDashInterface mListener;
  final fid;
  final vName;
  final date;
  final come;
  final String logoImage;
  const ProfitLossDash({Key? key, required this.mListener, this.fid, this.vName, this.date, this.come, required this.logoImage}) : super(key: key);

  @override
  State<ProfitLossDash> createState() => _ProfitLossDashState();
}

class _ProfitLossDashState extends State<ProfitLossDash> with CreateItemOpeningBalInterface{
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;

  List<SalesData> _saleData = [];

  var statistics=[];

  List<ProfitPartyWiseData> _profitPartywise = [];

  var profit=0.0;
  var purchaseAmt=0.0;
  var expenseAmt=0.0;
  var returnAmt=0.0;
  var receiptAmt=0.0;
  var FranchiseeOutstanding=0.0;
  var saleAmt=0.0;
  var itemOpening=0.0;
  var itemClosing=0.0;
  var profitLossShare=0.0;

  var purchaseMRPAmt=0.0;
  var returnMRPAmt=0.0;
  var saleMRPAmt=0.0;
  var additionalProfitLoss=0.0;
  var additionalProfitLossShare=0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.come=="report"){
      dateTime=DateTime.parse(widget.date);
    }else {
      addDate();
    }
  // callGetFranchiseeNot(0);
    getDashboardData();

    print("hfshjffhfbh  $dateString");
    // AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
    getLocal();
  }


  List MasterMenu=[];
  List TransactionMenu=[];

  String companyId="";
  var dataArr;
  var dataArrM;
  getLocal()async{
    companyId=await AppPreferences.getCompanyId();
    setState(() {
    });
    var menu =await (AppPreferences.getMasterMenuList());
    var tr =await (AppPreferences.getTransactionMenuList());
    dataArr=tr;
    dataArrM=menu;
    var re =await (AppPreferences.getReportMenuList());
    setState(() {
      MasterMenu=  (jsonDecode(menu)).map((i) => i['Form_ID']).toList();
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });
  }
  late DateTime dateTime;
  String dateString="";



  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));

 //   await callGetFranchiseeNot(0);
    await getDashboardData();
  }
  final ScrollController _scrollController =  ScrollController();
  @override
  Widget build(BuildContext context) {
    return isShowSkeleton? SkeletonAnimation(
        curve: Curves.easeIn,
        child: Container(
            color: CommonColor.MAIN_BG,
            child: const HomeSkeleton())):Scaffold(
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
                            widget.vName!,
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
        backgroundColor: const Color(0xFFfffff5),
        body: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
     children: [
       Padding(
         padding: const EdgeInsets.all(15.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // getFieldTitleLayout("Statistics Of : "),
             getPurchaseDateLayout(),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 GestureDetector(
                     onTap: ()async{
                       await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                           dateNew: dateTime,
                           logoImage: widget.logoImage,
                           mListener: this,
                           come:"edit",
                           franchiseeDetails:[widget.vName!,widget.fid!]
                       )));
                     //  await callGetFranchiseeNot(0);
                       await getDashboardData();
                     },
                     child: getThreeLayout("Opening Bal.","${CommonWidget.getCurrencyFormat(itemOpening)}",Color(0xFF6495ED))),
                 GestureDetector(
                     onTap: ()async{
                       await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                           dateNew: dateTime.add(Duration(days: 1)),
                           mListener: this,
                           come:"edit",
                           logoImage: widget.logoImage,
                           franchiseeDetails:[widget.vName!,widget.fid!]
                       )));
                    //  await callGetFranchiseeNot(0);
                       await getDashboardData();
                     },
                     child: getThreeLayout("Closing Bal.","${CommonWidget.getCurrencyFormat(itemClosing)}",Color(0xFF6082B6))),
  ],
             ),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [

                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(
                           dateNew: dateTime, logoImage: widget.logoImage,
                           mListener: this,
                           formId: "ST003",
                           arrData: dataArr,
                         comeFor: "frDash",
                         franhiseeID:widget.fid!,
                         franchiseeName:widget.vName!,
                       )));
                     },
                     child: getThreeLayout("Purchase","${CommonWidget.getCurrencyFormat(purchaseAmt)}",Color(0xFF4CBB17))),
                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseMrpActivity(mListener: this,
                         dateNew: dateTime,
                         formId: "AT006",
                         logoImage: widget.logoImage,
                         comeFor: "frDash",
                         arrData: dataArr,
                         franhiseeID:widget.fid!,
                         franchiseeName:widget.vName!,
                         apiUrl: ApiConstants().getSaleMRP,
                       )));
                     },
                     child: getThreeLayout( "Purchase MRP", "${CommonWidget.getCurrencyFormat((purchaseMRPAmt))}",Color(0xFFef1246))),
               ],
             ),
             const SizedBox(height: 10,),

           /*  Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 getThreeLayout("Sale","${CommonWidget.getCurrencyFormat(saleAmt)}",Color(0xFF00A36C)),
                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(
                           dateNew: dateTime,
                           mListener: this,
                           formId: "AT009",
                           arrData: dataArr,
                         logoImage: widget.logoImage,
                           comeFor: "frDash",
                           franhiseeID:widget.fid!,
                           franchiseeName:widget.vName!,
                       )));
                     },
                     child: getThreeLayout( "Expense", "${CommonWidget.getCurrencyFormat((expenseAmt))}",Colors.orange)),
               ],
             ),
             const SizedBox(height: 10,),*/
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 GestureDetector(
                     onTap: ()async{
                       Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(
                         dateNew: dateTime,
                         mListener: this,
                         formId: "AT006",
                         arrData: dataArr,
                         logoImage: widget.logoImage,
                         comeFor: "frDash",
                         franhiseeID:widget.fid!,
                         franchiseeName:widget.vName!,
                       )));
                     },
                     child: getThreeLayout( "Return", "${CommonWidget.getCurrencyFormat((returnAmt))}",Color(0xFF00A36C))),
                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseMrpActivity(mListener: this,
                         dateNew: dateTime,
                         formId: "AT006",
                         logoImage: widget.logoImage,
                         arrData: dataArr,
                         franhiseeID:widget.fid!,
                         franchiseeName:widget.vName!,
                         comeFor: "Return",
                         apiUrl: ApiConstants().getReturnMRP,
                       )));
                     },
                     child: getThreeLayout( "Return MRP", "${CommonWidget.getCurrencyFormat((returnMRPAmt))}",Colors.orange)),
               ],
             ),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                /* (TransactionMenu.contains("AT009"))?*/ GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(
                         dateNew: dateTime,
                         mListener: this,
                         formId: "AT009",
                         arrData: dataArr,
                         logoImage: widget.logoImage,
                         comeFor: "frDash",
                         franhiseeID:widget.fid!,
                         franchiseeName:widget.vName!,
                       )));
                     },child: getThreeLayout("Expense","${CommonWidget.getCurrencyFormat(expenseAmt)}",Color(0xFFf88379))),
                     //:Container(),
                 GestureDetector(
                     onTap: (){
                     },child: getThreeLayout( "Sale MRP", "${CommonWidget.getCurrencyFormat((saleMRPAmt))}",Color(0xFF913a74)  ))
                 //   :Container(),
               ],
             ),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
             /*    (TransactionMenu.contains("AT002"))? */   getSellPurchaseExpenseLayout(Colors.deepPurple, "${CommonWidget.getCurrencyFormat((receiptAmt))}", "Payment"),
                /* (MasterMenu.contains("RM005"))&&(TransactionMenu.contains("ST003"))&&
                     (TransactionMenu.contains("AT006"))&&(TransactionMenu.contains("AT009"))?*/
                 getSellPurchaseExpenseLayout(Colors.deepOrange, "${CommonWidget.getCurrencyFormat((profit))}",   profit>=0?"Sale Profit ":"Sale Loss"),
               ],
             ),
             const SizedBox(height: 10,),
             // getProfitLayout(),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 GestureDetector(
                     onTap: (){
                     },child: getThreeLayout(additionalProfitLoss>=0?"Purchase Profit ":"Purchase Loss","${CommonWidget.getCurrencyFormat(additionalProfitLoss)}",additionalProfitLoss<0?Colors.red:Colors.green)),

                 GestureDetector(
                     onTap: (){
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,dateNew: dateTime,
                       //   formId: "AT009",
                       //   arrData: dataArr,
                       // )));
                     },child: getThreeLayout(additionalProfitLossShare>=0? "Purchase Profit Share":"Purchase Loss Share", "${CommonWidget.getCurrencyFormat((additionalProfitLossShare))}",additionalProfitLossShare<0?Colors.red:Colors.green))
               ],
             ),
            /* SizedBox(height: 10,),
             (MasterMenu.contains("RM005"))&&(TransactionMenu.contains("ST003"))&&
                 (TransactionMenu.contains("AT006"))&&(TransactionMenu.contains("AT009"))?
             getProfitLayout():Container(),*/
           ],
         ),
       ),
     ],
          ),
        ));
  }

  Widget getSellPurchaseExpenseLayout( MaterialColor boxcolor, String amount, String title) {
    return   GestureDetector(
      onTap: (){

      },
        child: Container(
      height: 100,
      width: (SizeConfig.screenWidth * 0.89) / 2,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: (Colors.orange).withOpacity(0.3),
          border: Border.all(color: boxcolor),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 40,
            width: (SizeConfig.screenWidth * 0.89) / 2,
            // margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: (Colors.orange), borderRadius: BorderRadius.circular(5)
            ),
            alignment: Alignment.center,
            child: Text(
              "$amount",
              style: subHeading_withBold.copyWith(fontSize:19,color: Colors.black87 ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Expanded(
            child: Container(
              width: (SizeConfig.screenWidth * 0.89) / 2,
              alignment: Alignment.center,
              color: boxcolor,
              padding: EdgeInsets.all(5),
              child: Text(
                "$title",
                style: item_heading_textStyle.copyWith(
                    color: (Colors.white),
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ],
      ),
    ), /*Container(
        height: 120,
        width: (SizeConfig.screenWidth * 0.85) / 2,
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: boxcolor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 60,
              width: (SizeConfig.screenWidth * 0.85) / 2,
              // margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: boxcolor, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Text(
                amount,
                style: subHeading_withBold.copyWith(fontSize:18 ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$title",
                  style: item_heading_textStyle.copyWith(
                      color: boxcolor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // FaIcon(
                //   FontAwesomeIcons.solidArrowAltCircleRight,
                //   color: boxcolor,
                // )
              ],
            )

          ],
        ),
      ),*/
    );

  }

  Widget getThreeLayout(title,amount,boxcolor){
    return Container(
      height: 100,
      width: (SizeConfig.screenWidth * 0.89) / 2,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: (Colors.orange).withOpacity(0.3),
          border: Border.all(color: boxcolor),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 40,
            width: (SizeConfig.screenWidth * 0.89) / 2,
            // margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: (Colors.orange), borderRadius: BorderRadius.circular(5)

            ),
            alignment: Alignment.center,
            child: Text(
              "$amount",
              style: subHeading_withBold.copyWith(fontSize:19,color: Colors.black87 ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Expanded(
            child: Container(
              width: (SizeConfig.screenWidth * 0.89) / 2,
              alignment: Alignment.center,
              color: boxcolor,
              padding: EdgeInsets.all(5),
              child: Text(
                "$title",
                style: item_heading_textStyle.copyWith(
                    color: (Colors.white),
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget getProfitLayout(){
    return
    //   GestureDetector(
    //   onTap: (){
    //     /*   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
    //     comeFor: profit>=0?"Profit ":"Loss" ,
    //       profit:profit ,
    //       date:dateTime,
    //     )));*/
    //   },
    //   onDoubleTap: (){},
    //   child: Container(
    //     height:70 ,
    //     margin: const EdgeInsets.only(bottom: 10),
    //     width: (SizeConfig.screenWidth),
    //     // margin: EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //         color: profit<0?Colors.red:Colors.green,
    //         borderRadius: BorderRadius.circular(5)),
    //     alignment: Alignment.center,
    //     child:  Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding:  EdgeInsets.only(left: 40),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 profit>=0?"Profit ":"Loss",
    //                 style: item_heading_textStyle.copyWith(
    //                     color:Colors.white,
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.bold
    //
    //                 ),
    //               ),
    //
    //             ],
    //           ),
    //         ),
    //         getAnimatedFunction(),
    //       ],
    //     ),
    //   ),
    // );
      GestureDetector(
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
          //   comeFor: profit>=0?"Profit ":"Loss" ,
          //   profit:profit ,
          //   date:dateTime,
          // )));
        },
        onDoubleTap: (){},
        child: Container(
          height:80 ,
          margin: const EdgeInsets.only(bottom: 10),
          width: (SizeConfig.screenWidth),
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: profit<0?Colors.red:Colors.green,
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profit>=0?"Sale Profit ":"Sale Loss",
                          style: item_heading_textStyle.copyWith(
                              color:Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold

                          ),
                        ),

                      ],
                    ),
                  ),
                  getAnimatedFunction(),
                ],
              ),
              Divider(height: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profitLossShare>=0?"Sale Profit Share":"Sale Loss Share",
                          style: item_heading_textStyle.copyWith(
                              color:Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold

                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                      padding:  EdgeInsets.only(left: 10,right: 10),
                      child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(profitLossShare)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
                  )
                ],
              )
            ],
          ),
        ),
      );
  }


  Widget getFranchiseeLayout(){
    return GestureDetector(
      onTap: (){
        /*    Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseeOutstandingDetailActivity(mListener: this,
          comeFor: "Franchisee Outstanding",
          profit:FranchiseeOutstanding ,
          date:dateTime,
        )));*/
      },
      child: Container(
        height:70 ,
        margin: const EdgeInsets.only(bottom: 10),
        width: (SizeConfig.screenWidth),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Franchisee \nOutstanding",
                    style: item_heading_textStyle.copyWith(
                        color:Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const FaIcon(
                      FontAwesomeIcons.solidArrowAltCircleRight,
                      color:Colors.white,
                    ),
                  )
                ],
              ),
            ),
            getFranAnimatedFunction(),
          ],
        ),
      ),
    );
  }

  getAnimatedFunction(){
    return  Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(profit)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
      // Countup(
      //   locale: Locale('HI', 'IN'),
      //   precision: 2,
      //   begin: 0,
      //     // NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(amount);
      //   end: double.parse((profit).toString()),
      //   duration: const Duration(seconds: 2),
      //   separator: ',',
      //
      //     style: big_title_style.copyWith(fontSize: 26,color: Colors.white)
      //
      // ),
    );
  }

  getFranAnimatedFunction(){
    return  Padding(
      padding:  EdgeInsets.only(left: 20),
      child: Countup(
          precision: 2,
          begin: 0,
          end:double.parse((FranchiseeOutstanding).toString()) ,
          duration: const Duration(seconds: 2),
          separator: ',',
          style: big_title_style.copyWith(fontSize: 26,color: Colors.white)
      ),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date)async{
          setState(() {
            dateTime=date!;
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(dateTime));
            profit=0.0;
            purchaseAmt=0.0;
            expenseAmt=0.0;
            returnAmt=0.0;
            receiptAmt=0.0;
            FranchiseeOutstanding=0.0;
          });
        //  await callGetFranchiseeNot(0);
          await getDashboardData();
        },
        applicablefrom: dateTime
    );
  }


  callGetFranchiseeNot(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl = "${baseurl}${ApiConstants().sendFranchiseeNotification}?Company_ID=$companyId&${StringEn.frnachisee_id}=${widget.fid}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){
              setState(() {

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {

              print("Here2=> $e");
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }

  addDate() async {

    String  dateString = await AppPreferences.getDateLayout(); // Example string date
    dateTime = DateTime.parse(dateString);
    if(dateString==""){
      DateTime saleDate =  DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));
      AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
      print("jdjfjfbf  $saleDate");
    }else{

    }
    print(dateTime);
    print("jdhbdcbhb  $dateTime  $dateString");
    setState(() {

    });
  }
  bool isShowSkeleton = true;


  getDashboardData() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();

    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    print("objectgggg444444   $date  ");
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        print("meeeeeeee");
        String apiUrl = "${baseurl}${ApiConstants().getDashboardData}?Company_ID=$companyId&${StringEn.frnachisee_id}=${widget.fid}&Date=${DateFormat("yyyy-MM-dd").format(dateTime)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                _saleData=[];
                _profitPartywise=[];
                isLoaderShow=false;
                isShowSkeleton=false;
                if(data!=null){
                  // if (mounted) {
                  //   for (var item in data['DashboardSaleDateWise']) {
                  //     _saleData.add(SalesData(DateFormat("dd/MM").format(DateTime.parse(item['Date'])), (item['Amount'])));
                  //   }
                  //   for (var item in data['DashboardProfitPartywise']) {
                  //     _profitPartywise.add(ProfitPartyWiseData(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), double.parse(item['Profit'].toString()),item['Vendor_Name']));
                  //   }
                  // }
                  // _saleData=_saleData;
                  // print("nessssss  $_saleData");

                  setState(() {
                   profit=double.parse(data['DashboardMainData'][0]['Sale_Profit'].toString());
                   purchaseAmt=double.parse(data['DashboardMainData'][0]['Purchase_Amount'].toString());
                   purchaseMRPAmt=double.parse(data['DashboardMainData'][0]['Purchase_MRP_Amount'].toString());
                   returnMRPAmt=double.parse(data['DashboardMainData'][0]['Return_MRP_Amount'].toString());
                   saleMRPAmt=double.parse(data['DashboardMainData'][0]['Franchisee_Sale_Amount'].toString());
                   itemOpening=double.parse(data['DashboardMainData'][0]['Item_Opening_Amount'].toString());
                    itemClosing=double.parse(data['DashboardMainData'][0]['Item_Closing_Amount'].toString());
                   // purchaseAmt=double.parse(data['DashboardMainData'][0]['Company_Sale_Amount'].toString());
                    expenseAmt=double.parse(data['DashboardMainData'][0]['Expense_Amount'].toString());
                    returnAmt=double.parse(data['DashboardMainData'][0]['Return_Amount'].toString());
                    receiptAmt=double.parse(data['DashboardMainData'][0]['Receipt_Amount'].toString());
                    saleAmt=double.parse(data['DashboardMainData'][0]['Franchisee_Sale_Amount'].toString());
                    //
                    FranchiseeOutstanding=double.parse(data['DashboardMainData'][0]['Franchisee_Outstanding'].toString());
                    profitLossShare=data['DashboardMainData'][0]['Sale_Profit_Share']==null?0.0:double.parse(data['DashboardMainData'][0]['Sale_Profit_Share'].toString());
                    additionalProfitLoss=data['DashboardMainData'][0]['Purchase_Profit']!=null?double.parse(data['DashboardMainData'][0]['Purchase_Profit'].toString()):0.0;
                     additionalProfitLossShare=data['DashboardMainData'][0]['Purchase_Profit_Share']==null?0.0:double.parse(data['DashboardMainData'][0]['Purchase_Profit_Share'].toString());
                    print("############################### ${additionalProfitLoss}");
                  });

                }else{
                  isApiCall=true;
                }
              });
              print("  LedgerLedger111111  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
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



  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 0, bottom: 0,),
      child: Text(
        "$title",
        style: item_heading_textStyle.copyWith(fontSize: 20),
      ),
    );
  }

  @override
  backToList() {
    // TODO: implement backToList
  }

}

abstract class ProfitLossDashInterface {

}

class SalesData {
  final String Date;
  final int Amount;

  SalesData(this.Date, this.Amount);
}

class ExpenseData {
  final String category;
  final int amount;

  ExpenseData(this.category, this.amount);
}

class ProfitPartyWiseData {
  final String Date;
  final String Vendor_Name;
  final double Profit;

  ProfitPartyWiseData(this.Date, this.Profit, this.Vendor_Name);
}