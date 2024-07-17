import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/data/domain/transaction/creditDebitNote/post_credit_debit_reuest_model.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/debit_Note/add_or_edit_item.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class CreateDebitNote extends StatefulWidget {
  final CreateDebitNoteInterface mListener;
  final  dateNew;
  final  Invoice_No;
  final  come;
  final  debitNote;
  final  companyId;
  final String logoImage;
  final  readOnly;
  const CreateDebitNote({super.key, required this.dateNew, required this.mListener,required this.Invoice_No, this.come, this.debitNote, this.companyId, this.readOnly, required this.logoImage});
  @override
  _CreateDebitNoteState createState() => _CreateDebitNoteState();
}

class _CreateDebitNoteState extends State<CreateDebitNote> with SingleTickerProviderStateMixin,AddOrEditItemDebitInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  bool showButton = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();

  TextEditingController invoiceNo=TextEditingController();

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";

  String selectedLedgerName="";
  String selectedLedgerId="";

  String TotalAmount="0.00";
//  List<dynamic> Item_list=[];
  List<dynamic> Item_list=[];

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  bool isLoaderShow=false;

  var editedItemIndex=null;
var invoice_No;

  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);

  void _updateOffset(Offset newOffset) {
    setState(() {
      // Clamp the Offset values to stay within the defined constraints
      double clampedX = newOffset.dx.clamp(minX, maxX);
      double clampedY = newOffset.dy.clamp(minY, maxY);
      position = Offset(clampedX, clampedY);
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
    // calculateTotalAmt();
    invoice_No=widget.Invoice_No;
    invoiceDate=widget.dateNew;
    if(widget.Invoice_No!=null){
      getDebitNote(1);

    }

  }

  calculateTotalAmt()async{
    setState(() {
      TotalAmount="0.00";
      roundoff="0.00";
    });
    var total=0.00;
    for(var item  in Item_list ){
      total=total+item['Net_Amount'];
      // print(item['Amount']);
    }
    // var amt = double.parse((total.toString()).substring((total.toString()).length - 3, (total.toString()).length)).toStringAsFixed(3);
    double amt = total % 1;

    print("%%%%%%%%%%%%%%%%%%%%% $amt");
    if(double.parse((total.toString()).substring((total.toString()).length-3,(total.toString()).length))==0.0){
      var total1=(total).floorToDouble();
      setState(() {
        roundoff="0.00";
        TotalAmount=total1.toStringAsFixed(2) ;
      });
    }
    else {
      if ((amt) < 0.50) {
        print("Here");
        var total1=(total).floorToDouble();
        var roff=total1-(total);
        setState(() {
          TotalAmount=total1.toStringAsFixed(2) ;
          roundoff=roff.toStringAsFixed(2);
        });
      }
      else if ((amt) >= 0.50){
        setState(() {
          roundoff=(1-amt).toStringAsFixed(2);
          TotalAmount=(total.ceilToDouble()).toStringAsFixed(2) ;
        });
      }

    }

  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: ()async{
          if(showButton==true){
            await  showCustomDialog(context);
            return false;
          }
          else {
            return true;
          }
        },child: contentBox(context));
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFfffff5),
            // borderRadius: BorderRadius.circular(16.0),
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
                    leading: Container(),
                    leadingWidth: 0,
                    title:  Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: ()async {
                              if(showButton==true){
                                await showCustomDialog(context);
                              }else{
                                Navigator.pop(context);
                              }},
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
                                ApplicationLocalizations.of(context)!.translate("debit_note")!,
                                style: appbar_text_style,),
                            ),
                          ),
                          widget.Invoice_No == null?Container():
                           PopupMenuButton(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                color: Colors.transparent,
                                child: const FaIcon(Icons.download_sharp),
                              ),
                            ),
                            onSelected: (value) {
                             if(value == "PDF"){
                                // add desired output
                               pdfDownloadCall("PDF");
                              }else if(value == "XLS"){
                                // add desired output
                               pdfDownloadCall("XLS");
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: "PDF",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.picture_as_pdf, color: Colors.red),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: "XLS",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage('assets/images/xls.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                Item_list.isEmpty && showButton==false?Container(): Container(
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
        ),
        widget.readOnly==false?Container():  Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              // setState(() {
              //   position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy);
              // });
              _updateOffset(position + details.delta);

            },
            child: FloatingActionButton(
                backgroundColor: Color(0xFFFBE404),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ),
                onPressed: () async{
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(selectedFranchiseeId!=""&&selectedLedgerId!="") {

                  if(selectedFranchiseeId==selectedLedgerId){
                    CommonWidget.errorDialog(context,
                        "Party name and Account Ledger can't be same!");
                  }else {
                    editedItemIndex = null;
                    goToAddOrEditItem(null, widget.companyId, "");
                  }
                  }
                  else{
                    CommonWidget.errorDialog(context, "Select Account Ledger and Party !");
                  }
                }),
          ),
        ),

        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  Future<void> showCustomDialog(BuildContext context) async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: BackPageDialog(
              onCallBack: (value) async {
                if (value == "yes") {
                  if(selectedLedgerId=="" ){
                    var snackBar = SnackBar(content: Text('Select Account Ledger!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(selectedFranchiseeId==""){
                    var snackBar=SnackBar(content: Text("Select Party Name !"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else
                  if(selectedFranchiseeId==selectedLedgerId){
                    CommonWidget.errorDialog(context,
                        "Party name and Account Ledger can't be same!");
                  }
                  else if(Item_list.length==0){
                    var snackBar=SnackBar(content: Text("Add atleast one Item!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(selectedLedgerId!="" && selectedFranchiseeId!= " " && Item_list.length>0){
                    if (mounted) {
                      setState(() {
                        showButton = false;
                      });
                    }

                    if(invoice_No==null) {
                      print("#######");
                      callPostSaleInvoice();
                    }
                    else {
                      print("dfsdf");
                      updatecallPostSaleInvoice();
                    }
                  }
                }
              },
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation2, animation1) {
        return Container();
      },
    );
  }

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      /*  TotalAmount!="0.00"? */Container(
          width: SizeConfig.halfscreenWidth,
          padding: EdgeInsets.only(top: 0,bottom:0),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${Item_list.length} Items",style: item_regular_textStyle.copyWith(color: Colors.grey),),
              Text("Round off: $roundoff",style: item_regular_textStyle.copyWith(fontSize: 17),),
              SizedBox(height: 4,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble())}",style: item_heading_textStyle,),
            ],
          ),
        )/*:Container()*/,
        widget.readOnly==false||showButton==false?Container():   GestureDetector(
          onTap: () {
            if(selectedLedgerId=="" ){
              var snackBar = SnackBar(content: Text('Select Account Ledger!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(selectedFranchiseeId==""){
              var snackBar=SnackBar(content: Text("Select Party Name !"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else
            if(selectedFranchiseeId==selectedLedgerId){
              CommonWidget.errorDialog(context,
                  "Party name and Account Ledger can't be same!");
            }
            else if(Item_list.length==0){
              var snackBar=SnackBar(content: Text("Add atleast one Item!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(selectedLedgerId!="" && selectedFranchiseeId!= " " && Item_list.length>0){
              if (mounted) {
                setState(() {
                  showButton = false;
                });
              }
              print(widget.Invoice_No);
              if(widget.Invoice_No==null) {
                print("#######");
                callPostSaleInvoice();
              }
              else {
                print("dfsdf");
                updatecallPostSaleInvoice();
              }
            }
          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.halfscreenWidth,
            height: 50,
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


  var roundoff="0.00";




  Widget getAllFields(double parentHeight, double parentWidth) {
    return  isLoaderShow?Container(): ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     widget.readOnly==false?Container():
                  //     GestureDetector(
                  //         onTap: (){
                  //           FocusScope.of(context).requestFocus(FocusNode());
                  //           if(selectedFranchiseeId!=""&&selectedLedgerId!="") {
                  //             if (context != null) {
                  //               editedItemIndex=null;
                  //               goToAddOrEditItem(null,widget.companyId,"");
                  //             }
                  //           }
                  //           else{
                  //             CommonWidget.errorDialog(context, "Select Account Ledger and Party !");
                  //           }
                  //         },
                  //         child: Container(
                  //             width: 120,
                  //             padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                  //             margin: EdgeInsets.only(bottom: 10),
                  //             decoration: BoxDecoration(
                  //                 color: CommonColor.THEME_COLOR,
                  //                 border: Border.all(color: Colors.grey.withOpacity(0.5))
                  //             ),
                  //             child:  Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                   ApplicationLocalizations.of(context)!.translate("add_item")!,
                  //                   style: item_heading_textStyle,),
                  //                 FaIcon(FontAwesomeIcons.plusCircle,
                  //                   color: Colors.black87, size: 20,)
                  //               ],
                  //             )
                  //
                  //         )
                  //     )
                  //   ],
                  // ),
                  //
                  // SizedBox(height: 10,),
                  //
                  Item_list.length>0?get_Item_list_layout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container()

                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Item_list.length,
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

                  setState(() {
                    editedItemIndex=index;
                  });
                  if(widget.readOnly==false){
                  }else{
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditItem(Item_list[index],widget.companyId,"edit");
                    }
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
                                    child: Text("${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
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
                                        Text("${Item_list[index]['Item_Name']}",style: item_heading_textStyle,),

                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  CommonWidget.getCurrencyFormat(
                                                      double.parse(Item_list[index]
                                                      ['Quantity'].toString()))
                                                      .toString() + "${Item_list[index]['Unit']}",
                                                  // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}",
                                                  overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),)),

                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: SizeConfig.halfscreenWidth-50,
                                              child:
                                              Text(CommonWidget.getCurrencyFormat(Item_list[index]['Net_Amount']),overflow: TextOverflow.ellipsis,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                widget.readOnly==false?Container():
                                Container(
                                    width: parentWidth*.1,
                                    // height: parentHeight*.1,
                                    color: Colors.transparent,
                                    child:DeleteDialogLayout(
                                        callback: (response ) async{
                                          if(response=="yes"){
                                            print("##############$response");
                                            if(Item_list[index]['Seq_No']!=null){
                                              var deletedItem=   {
                                                "Item_ID": Item_list[index]['Item_ID'],
                                                "Seq_No": Item_list[index]['Seq_No'],
                                              };
                                              Deleted_list.add(deletedItem);
                                              setState(() {
                                                showButton=true;
                                                Deleted_list=Deleted_list;
                                              });
                                            }

                                            var contain = Inserted_list.indexWhere((element) => element['Item_ID']== Item_list[index]['Item_ID']);
                                            print(contain);
                                            if(contain>=0){
                                              print("REMOVE");
                                              Inserted_list.remove(Inserted_list[contain]);
                                            }
                                            Item_list.remove(Item_list[index]);
                                            setState(() {
                                              Item_list=Item_list;
                                              Inserted_list=Inserted_list;
                                            });
                                            print(Inserted_list);
                                            await calculateTotalAmt();
                                            setState(() {
                                              showButton=true;});
                                          }
                                        })
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
    );
  }

  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          goToAddOrEditItem(null,widget.companyId,"");
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add New Item",
                style: item_heading_textStyle,),
              FaIcon(FontAwesomeIcons.plusCircle,
                color: Colors.black87, size: 20,)
            ],
          )
      ),
    );
  }

  Future<Object?> goToAddOrEditItem(product,companyId,statuss) {
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
              child: AddOrEditItemDebit(
                mListener: this,
                editproduct:product,
                date: invoiceDate,
                companyId: companyId,
                partyId: selectedFranchiseeId,
                status: statuss,
                  // exstingList:Item_list
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
        }
    );
  }

  Container InvoiceInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        children: [
          widget.Invoice_No!=null? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width:widget.Invoice_No!=null?SizeConfig.halfscreenWidth:(SizeConfig.screenWidth)*.32,
                  child: getPurchaseDateLayout()),

              SizedBox(width: 5,),
              Expanded(
                  child:getInvoiceNo(SizeConfig.screenHeight,SizeConfig.halfscreenWidth)),
            ],
          ):getPurchaseDateLayout(),
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          // SizedBox(width: 5,),

        ],
      ),
    );
  }

  Widget getInvoiceNo(double parentHeight, double parentWidth) {
    return   Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10),
      width:parentWidth,
      height: (SizeConfig.screenHeight) * .055,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color:CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Text("Invoice No :$finInvoiceNo",style:text_field_textStyle ,),
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
  Widget getPurchaseDateLayout(){
    return
      GetDateLayout(

          titleIndicator: false,
          title: ApplicationLocalizations.of(context)!.translate("date")!,
          callback: (date){
            setState(() {
              showButton=true;
              invoiceDate=date!;
              Item_list=[];
              Updated_list=[];
              Deleted_list=[];
              Inserted_list=[];
            });

            if(widget.Invoice_No!=null){
              getDebitNote(1);
            }
          },
          applicablefrom: invoiceDate
      );
  }

  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return  SearchableLedgerDropdown(
      apiUrl: ApiConstants().ledgerWithoutImage+"?",
      titleIndicator: true,
      ledgerName: selectedFranchiseeName,
      franchisee: widget.come,
      readOnly: widget.readOnly,
      franchiseeName:widget.come=="edit"?selectedFranchiseeName:"",
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (name,id){
        if(selectedLedgerId==id){
          var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
        else {
          setState(() {
            showButton=true;
            selectedFranchiseeName = name!;
            selectedFranchiseeId = id.toString()!;
            position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
          });
        }
        print("############3");
        print(selectedFranchiseeId+"\n"+selectedFranchiseeName);
      },

    );

  }

  /* Widget to get sale ledger Name Layout */
  Widget getSaleLedgerLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      apiUrl: ApiConstants().ledgerWithoutImage+"?",
      titleIndicator: true,
      readOnly: widget.readOnly,
      ledgerName: selectedLedgerName,
      franchisee: widget.come,
      franchiseeName:widget.come=="edit"?selectedLedgerName:"",
      title: ApplicationLocalizations.of(context)!.translate("account_ledger")!,
      callback: (name,id){
        if(selectedLedgerId==id){
          var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
        else {
          setState(() {
            showButton=true;
            selectedLedgerName = name!;
            selectedLedgerId = id.toString();
            position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
          });
        }
        print("############3");
        print(selectedLedgerId);
      },
    );
  }

  @override
  AddOrEditItemSellDetail(item)async {
    // TODO: implement AddOrEditItemDetail


  }

  String finInvoiceNo="";
  getDebitNote(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getVoucherNoteHeaderDetails}?Company_ID=$companyId&Invoice_No=${widget.Invoice_No}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=(data['itemDetails']);

                  setState(() {
                    Item_list=_arrList;
                    selectedFranchiseeName=data['voucherDetails']['Vendor_Name'];
                    finInvoiceNo=data['voucherDetails']['Fin_Invoice_No'];
                    selectedFranchiseeId=data['voucherDetails']['Vendor_ID'].toString();
                    selectedLedgerName=data['voucherDetails']['Ledger_Name'];
                    selectedLedgerId=data['voucherDetails']['Ledger_ID'].toString();
                    TotalAmount=data['voucherDetails']['Total_Amount'].toStringAsFixed(2) ;
                    roundoff=data['voucherDetails']['Round_Off'].toStringAsFixed(2);
                  });
                  if(Item_list.length>0){
                    position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.78);
                  }
                  // calculateTotalAmt();
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

  callPostSaleInvoice() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    // String totalAmount =CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble());
    double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        postCreditDebitNoterequestModel model = postCreditDebitNoterequestModel(
            ledgerID:selectedLedgerId ,
            vendorID:selectedFranchiseeId ,
            companyID: companyId ,
            voucherName: "Debit Note",
            roundOff:double.parse(roundoff) ,
            totalAmount:TotalAmountInt,
            date: DateFormat('yyyy-MM-dd').format(invoiceDate),
            creator: creatorName,
            creatorMachine: deviceId,
            iNSERT: Inserted_list.toList(),
            remark: "Inserted"
        );

        String apiUrl =baseurl + ApiConstants().getVoucherNote;
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=true;
                Item_list=[];
                Inserted_list=[];
                Updated_list=[];
                Deleted_list=[];
              });
              widget.mListener.backToList(invoiceDate);

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


  updatecallPostSaleInvoice() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    var matchDate=DateFormat('yyyy-MM-dd').format(invoiceDate).compareTo(DateFormat('yyyy-MM-dd').format(widget.dateNew));
    print("newOne    $matchDate");
    double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        postCreditDebitNoterequestModel model = postCreditDebitNoterequestModel(
            ledgerID:selectedLedgerId ,
            vendorID:selectedFranchiseeId ,
            invoiceNo:widget.Invoice_No.toString() ,
            companyID: companyId ,
            voucherName: "Debit Note",
            roundOff:double.parse(roundoff),
            totalAmount:TotalAmountInt,
            dateNew:matchDate !=0?DateFormat('yyyy-MM-dd').format(invoiceDate):null,
            date: DateFormat('yyyy-MM-dd').format(widget.dateNew),
            modifier: creatorName,
            modifierMachine: deviceId,
            iNSERT: Inserted_list.toList(),
            dELETE: Deleted_list.toList(),
            uPDATE: Updated_list.toList(),
            remark:"Modified"
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().getVoucherNote;
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=true;
                Item_list=[];
                Inserted_list=[];
                Updated_list=[];
                Deleted_list=[];
              });
              widget.mListener.backToList(invoiceDate);

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

  @override
  AddOrEditItemDebitDetail(item) async {
    // TODO: implement AddOrEditItemDebitDetail
    var itemLlist=Item_list;
showButton=true;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['Item_Name']=item['Item_Name'];
        Item_list[index]['Quantity']=item['Quantity'];
        Item_list[index]['Item_ID']=item['New_Item_ID'];
        Item_list[index]['Unit']=item['Unit'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['Amount']=item['Amount'];
        Item_list[index]['Disc_Percent']=item['Disc_Percent'];
        Item_list[index]['Disc_Amount']=item['Disc_Amount'];
        Item_list[index]['Taxable_Amount']=item['Taxable_Amount'];
        Item_list[index]['GST_Rate']=item['GST_Rate'];
        Item_list[index]['GST_Amount']=item['GST_Amount'];
        Item_list[index]['Net_Rate']=item['Net_Rate'];
        Item_list[index]['Net_Amount']=item['Net_Amount'];
      });
      print("#############3");
      print(item['Seq_No']);
      if(item['New_Item_ID']!=null){
        Item_list[index]['New_Item_ID']=item['New_Item_ID'];
      }
      if(item['Seq_No']!=null) {
        var contain = Updated_list.indexWhere((element) => element['Item_ID']== item['Item_ID']);
        print(contain);
        if(contain>=0){
          print("REMOVE");
          Updated_list.remove(Updated_list[contain]);
          Updated_list.add(item);
        }else{
          Updated_list.add(item);
        }
        setState(() {
          Updated_list = Updated_list;
          print("hvhfvbfbv   $Updated_list");
        });

      }
    }
    else
    {
      itemLlist.add(item);
      Inserted_list.add(item);
      setState(() {
        Inserted_list=Inserted_list;
      });
      print(itemLlist);

      setState(() {
        Item_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex=null;
    });
    await calculateTotalAmt();
    print("List");
    print(Inserted_list);
    print(Updated_list);
    if(Item_list.length>0){
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
    }else{
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
    }
  }
  pdfDownloadCall(String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });

        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl =baseurl + ApiConstants().getVoucherNoteHeaderDetails+"/Download?Company_ID=$companyId&Invoice_No=${widget.Invoice_No.toString()}&Type=$urlType";

        print(apiUrl);
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data)async{

              setState(() {
                isLoaderShow=false;
                print("  dataaaaaaaa  ${data['data']} ");
                 downloadFile(data['data'],data['fileName']);
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

    Future<void> downloadFile( String url, String fileName) async {
    // Check for storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Get the application directory
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
       // String url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
      //  String fileName = "example.pdf";
        String savePath = "${dir.path}/$fileName";

        try {
          var response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            File file = File(savePath);
            await file.writeAsBytes(response.bodyBytes);
            print("File is saved to download folder: $savePath");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Downloaded: $fileName"),
              ),
            );
            // Show a notification
            NotificationService.showNotification(
                'Download Complete',
                'The file has been downloaded successfully.',
                savePath
            );
            // Open the downloaded file
               OpenFile.open(savePath);
          } else {
            print("Error: ${response.statusCode}");
          }
        } catch (e) {
          print("Error: $e");
        }
      }
    } else {
      print("Permission Denied");
    }
  }
}

abstract class CreateDebitNoteInterface {
  backToList(DateTime updateDate);
}
