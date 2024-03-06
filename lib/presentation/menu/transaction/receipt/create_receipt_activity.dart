
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/add_edit_ledger.dart';

import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_date_layout.dart';


class CreateReceipt extends StatefulWidget {
  final CreateReceiptInterface mListener;
  final String dateNew;
  const CreateReceipt({super.key,required this.mListener, required this.dateNew});
  @override
  _CreateReceiptState createState() => _CreateReceiptState();
}

class _CreateReceiptState extends State<CreateReceipt> with SingleTickerProviderStateMixin,AddOrEditLedgerInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();


  String selectedFranchiseeName="";

  List<dynamic> Ledger_list=[
    {
      "id":1,
      "ledgerName":"Mahesh Kirana Store",
      "currentBal":10,
      "amount":780.00,
      "narration":"narration1"

    },
    {
      "id":2,
      "ledgerName":"Rajesh Furnicture",
      "currentBal":20,
      "amount":5300.00,
      "narration":"narration2"

    },
  ];

  String TotalAmount="0.00";

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Ledger_list ){
      total=total+item['amount'];
      print(item['amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    calculateTotalAmt();
  }

  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: SizeConfig.safeUsedHeight,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFFfffff5),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFfffff5),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
              color: Colors.transparent,
              // color: Colors.red,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),

                backgroundColor: Colors.white,
                title: Text(
                  ApplicationLocalizations.of(context)!.translate("receipt_invoice_new")!,
                  style: appbar_text_style,),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // color: CommonColor.DASHBOARD_BACKGROUND,
                  child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
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
                height: SizeConfig.safeUsedHeight * .12,
                child: getSaveAndFinishButtonLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),

          ],
        ),
      ),
    );
  }

  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      // padding: EdgeInsets.only(
      //     left: parentWidth * 0.04,
      //     right: parentWidth * 0.04,
      //     top: parentHeight * 0.01,
      //     bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  ReceiptInfo(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditItem(null);
                            }
                          },
                          child: Container(
                              width: 140,
                              padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: CommonColor.THEME_COLOR,
                                  border: Border.all(color: Colors.grey.withOpacity(0.5))
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ApplicationLocalizations.of(context)!.translate("add_ledger")!,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Ledger_list.length>0? get_Item_list_layout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),
                  // Ledger_list.length>0? getLedgerListLayout():Container(),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }



  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemCount: Ledger_list.length,
        itemBuilder: (BuildContext context, int index) {
          return  AnimationConfiguration.staggeredList(
            position: index,
            duration:
            const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -44.0,
              child: FadeInAnimation(
                delay: Duration(microseconds: 1500),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditItem(Ledger_list[index]);
                    }
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(top: 10,left: 10,right: 10 ,bottom: 10),
                              child:Row(
                                children: [
                                  Container(
                                      width: parentWidth*.1,
                                      height:parentWidth*.1,
                                      decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      alignment: Alignment.center,
                                      child: Text("0${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
                                  ),

                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      width: parentWidth*.70,
                                      //  height: parentHeight*.1,
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${Ledger_list[index]['ledgerName']}",style: item_heading_textStyle,),

                                          SizedBox(height: 3,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Text(CommonWidget.getCurrencyFormat(Ledger_list[index]['amount']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          ),
                                          SizedBox(height: 2 ,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child: Text("${Ledger_list[index]['narration']}",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                      width: parentWidth*.1,
                                      // height: parentHeight*.1,
                                      color: Colors.transparent,
                                      child:IconButton(
                                        icon:  FaIcon(
                                          FontAwesomeIcons.trash,
                                          size: 15,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: ()async{
                                          Ledger_list.remove(Ledger_list[index]);
                                          setState(() {
                                            Ledger_list=Ledger_list;
                                          });
                                          await calculateTotalAmt();
                                        },
                                      )
                                  ),
                                ],
                              )

                          ),
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
          return SizedBox(
            height: 5,
          );
        },
      ),
    );
  }



  Container ReceiptInfo() {
    return  Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width:(SizeConfig.screenWidth)*.32,
              child: getReceiptDateLayout()),

          SizedBox(width: 5,),
          Expanded(
              child: getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
        ],
      ),
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getReceiptDateLayout(){
    return  GetDateLayout(

        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            invoiceDate=date!;
          });
        },
        applicablefrom: invoiceDate
    );
  }


  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return GetFranchiseeLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
        callback: (name,id){
          setState(() {
            selectedFranchiseeName=name!;
          });
        },
        franchiseeName: selectedFranchiseeName);
  }

  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          goToAddOrEditItem(null);
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add New Ledger",
                style: item_heading_textStyle,),
              FaIcon(FontAwesomeIcons.plusCircle,
                color: Colors.black87, size: 20,)
            ],
          )
      ),
    );
  }

  Future<Object?> goToAddOrEditItem(product) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
              1.0;
          return Transform(
            transform:
            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddOrEditLedger(
                mListener: this,
                editproduct:product,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation2, animation1) {
          throw Exception('No widget to return in pageBuilder');
        });
  }





  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TotalAmount!="0.00"? Container(
          width: SizeConfig.halfscreenWidth,
          padding: EdgeInsets.only(top: 10,bottom:10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${Ledger_list.length} Ledgers",style: item_regular_textStyle.copyWith(color: Colors.grey),),

              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble())}",style: item_heading_textStyle,),
            ],
          ),
        ):Container(),
        GestureDetector(
          onTap: () {
            // if(widget.comeFrom=="clientInfoList"){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClientInformationListingPage(
            //   )));
            // }if(widget.comeFrom=="Projects"){
            //   Navigator.pop(context,false);
            // }
            // else if(widget.comeFrom=="edit"){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ClientInformationDetails(
            //   )));
            // }
            if (mounted) {
              setState(() {
                disableColor = true;
              });
            }
          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.halfscreenWidth,
            height: 40,
            decoration: BoxDecoration(
              color: disableColor == true
                  ? CommonColor.THEME_COLOR.withOpacity(.5)
                  : CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: parentWidth * .005),
                  child:  Text(
                    ApplicationLocalizations.of(context)!.translate("save")!,
                    style: page_heading_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  @override
  AddOrEditLedgerDetail(item) {
    // TODO: implement AddOrEditItemDetail
    var itemLlist=Ledger_list;
    if(item['id']!=""){
      var index=Ledger_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Ledger_list[index]['ledgerName']=item['ledgerName'];
        Ledger_list[index]['currentBal']=item['currentBal'];
        Ledger_list[index]['amount']=item['amount'];
        Ledger_list[index]['narration']=item['narration'];
      });
    }
    else {
      if (itemLlist.contains(item)) {
        print("Already Exist");
      }
      else {
        itemLlist.add(item);
      }
      setState(() {
        Ledger_list = itemLlist;
      });
    }
    calculateTotalAmt();
  }

}

abstract class CreateReceiptInterface {
}
