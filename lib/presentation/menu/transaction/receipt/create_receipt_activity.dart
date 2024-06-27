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
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/add_edit_ledger.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/transaction/payment_reciept_contra_journal/payment_recipt_contra_journal_req_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_bank_cash_ledger.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';


class CreateReceipt extends StatefulWidget {
  final CreateReceiptInterface mListener;
  final  dateNew;
  final  voucherNo;
  final  newDate;
  final come;
  final editedItem;
  final readOnly;

  const CreateReceipt({super.key,required this.mListener, required this.dateNew,  this.voucherNo, this.newDate,this.editedItem,this.come, this.readOnly});
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
  String TotalAmount="0.00";

  List<dynamic> Item_list=[];

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];
bool isLoaderShow=false;
bool showButton=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();



  var companyId="0";
var voucherNo;


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

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Item_list ){
      total=total+item['Amount'];
      print(item['Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voucherNo=widget.voucherNo;
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    setData();
  }
  setData()async{
    await getCompanyId();
    invoiceDate=widget.dateNew;
    if(widget.come=="edit"){
      // await calculateTotalAmt();
      await getRecipt(1);
      print("#######################3 ${widget.voucherNo}  ${widget.dateNew}");
      setState(() {
        voucherNoController.text="Voucher No: ${widget.voucherNo}";
      });
    }

    print("#######################33 ${selectedbankCashLedger}");

  }

  getCompanyId()async{
    String companyId1 = await AppPreferences.getCompanyId();
    setState(() {
      companyId=companyId1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                  if(selectedBankLedgerID==null){
                    var snackBar=SnackBar(content: Text("Select Bank Cash Ledger !"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(Item_list.length==0){
                    var snackBar=SnackBar(content: Text("Add atleast one Expense ledger!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(selectedBankLedgerID!=null &&Item_list.length>0) {
                    if (mounted) {
                      setState(() {
                        disableColor = true;
                      });
                    }
                    if(voucherNo==null) {
                      print("#######");
                      callPostReceipt();
                    }
                    else {
                      print("dfsdf");
                      updatecallPostReceipt();
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

  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
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
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                    title:  Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if(showButton==true){
                              await showCustomDialog(context);
                              }else{
                                Navigator.pop(context);
                              }},
                            child: FaIcon(Icons.arrow_back),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("receipt_invoice")!,
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                Item_list.length>0?Container(
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
                        SizeConfig.screenHeight, SizeConfig.screenWidth)):Container(),
                CommonWidget.getCommonPadding(
                    SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
              ],
            ),
          ),
        ),
        widget.readOnly==false?Container():  Positioned(
          left: position.dx,
          top: position.dy,
          child:  GestureDetector(
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
                  if(selectedBankLedgerID!=null) {
                    if (context != null) {
                      editedItemIndex=null;
                      goToAddOrEditItem(null,DateFormat("yyyy-MM-dd").format(widget.newDate));
                    }
                  }
                  else{
                    CommonWidget.errorDialog(context, "Select Bank !");
                  }

                }),
          ),
        ),

        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }


  Widget getAllFields(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():ListView(
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
                  ReceiptInfo(),
                  SizedBox(height: 10,),

                  Item_list.length>0? get_Item_list_layout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),
                  // Item_list.length>0? getLedgerListLayout():Container(),
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
                    goToAddOrEditItem(Item_list[index],DateFormat("yyyy-MM-dd").format(widget.newDate));
                  }}
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
                                        Text("${Item_list[index]['Ledger_Name']}",style: item_heading_textStyle,),

                                        SizedBox(height: 3,),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child:
                                          Text(CommonWidget.getCurrencyFormat(Item_list[index]['Amount']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                        ),
                                        SizedBox(height: 2 ,),
                                        Item_list[index]['Remark']!=null?Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child: Text("${Item_list[index]['Remark']}",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                        ):Container(),
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
                                                "Expense_ID": Item_list[index]['Expense_ID'],
                                                "Seq_No": Item_list[index]['Seq_No'],
                                              };
                                              Deleted_list.add(deletedItem);
                                              setState(() {
                                                showButton=true;
                                                Deleted_list=Deleted_list;
                                              });
                                            }

                                            var contain = Inserted_list.indexWhere((element) => element['Expense_ID']== Item_list[index]['Expense_ID']);
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
                                            if(Item_list.length>0){
                                              position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
                                            }else{
                                              position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
                                            }
                                          }
                                        })/*IconButton(
                                      icon:  FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 15,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: ()async{
                                        Item_list.remove(Item_list[index]);
                                        setState(() {
                                          Item_list=Item_list;
                                        });
                                        await calculateTotalAmt();
                                      },
                                    )*/
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



  Widget ReceiptInfo() {
    return  Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.voucherNo==null? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // width:(SizeConfig.screenWidth),
                  child: getReceiptDateLayout()),

              // SizedBox(width: 5,),
              // Expanded(
              //     child: getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
            ],
          ):Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getReceiptDateLayout(),
              getVoucherNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)
            ],
          ),
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
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
        comeFor: widget.voucherNo==null?"newOne":"",
        titleIndicator: false,
        parentWidth:widget.voucherNo!=null? (SizeConfig.screenWidth ):null,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            showButton=true;
            invoiceDate=date!;
          });
        },
        applicablefrom: invoiceDate
    );
  }
  final voucherNoController = TextEditingController();

  /* Widget for voucher no text from field layout */
  Widget getVoucherNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: voucherNoController,
      focuscontroller: _voucherNoFocus,
      focusnext: _voucherNoFocus,
      title: "",
      callbackOnchage: (value) {
        setState(() {
          voucherNoController.text = value;
        });
      },
      readOnly: false,
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("pin_code")!;
        }
        return null;
      },
      parentWidth: (SizeConfig.screenWidth ),
    );
  }

  String selectedbankCashLedger="";
  var selectedBankLedgerID=null;
  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return  SearchableLedgerDropdown(
      apiUrl: ApiConstants().getBankCashLedger+"?",
      titleIndicator: true,
      ledgerName: selectedbankCashLedger,
      franchisee: widget.come,
      readOnly: widget.readOnly,
      franchiseeName: widget.come=="edit"? selectedbankCashLedger:"",
      title: ApplicationLocalizations.of(context)!.translate("bank_cash_ledger")!,
      callback: (name,id){
        setState(() {
          showButton=true;
          selectedbankCashLedger=name!;
          selectedBankLedgerID=id!;
          // Item_list=[];
          // Updated_list=[];
          // Deleted_list=[];
          // Inserted_list=[];
        });
        print(selectedBankLedgerID);
        print(selectedbankCashLedger);

        // if(widget.voucherNo!=""){
        //   getExpInvoice(1);
        // }
      },

    );


      GetBankCashLedger(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
        callback: (name,id){
          setState(() {
            selectedbankCashLedger=name!;
            selectedBankLedgerID=id;
          });
        },
        bankCashLedger: selectedbankCashLedger);
  }

  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          goToAddOrEditItem(null,DateFormat("yyyy-MM-dd").format(widget.newDate));
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

  Future<Object?> goToAddOrEditItem(product,dateee) {
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
                newDate:dateee,
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
        });
  }





  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TotalAmount!="0.00"? Container(
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
              Text("${Item_list.length} Ledgers",style: item_regular_textStyle.copyWith(color: Colors.grey),),

              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
            ],
          ),
        ):Container(),
        widget.readOnly==false||showButton==false?Container():   GestureDetector(
          onTap: () {
            if(selectedBankLedgerID==null){
              var snackBar=SnackBar(content: Text("Select Bank Cash Ledger !"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(Item_list.length==0){
              var snackBar=SnackBar(content: Text("Add atleast one Expense ledger!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(selectedBankLedgerID!=null &&Item_list.length>0) {
                if (mounted) {
                setState(() {
                disableColor = true;
                });
                }
                if(widget.voucherNo==null) {
                print("#######");
                callPostReceipt();
                }
                else {
                print("dfsdf");
                updatecallPostReceipt();
             }
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

  var editedItemIndex=null;
  @override
  AddOrEditLedgerDetail(item)async {
    // TODO: implement AddOrEditItemDetail

    var itemLlist=Item_list;
showButton=true;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
       // Item_list[index]['New_Ledger_ID']=item['New_Ledger_ID'];
        Item_list[index]['Ledger_Name']=item['Ledger_Name'];
        Item_list[index]['Ledger_ID']=item['New_Ledger_ID'];
        Item_list[index]['Amount']=item['Amount'];
        Item_list[index]['Remark']=item['Remark'];
        Item_list[index]['Seq_No']=item['Seq_No'];
      });
      print("#############3");
      print(item['Seq_No']);
      if(item['New_Ledger_ID']!=null){
        Item_list[index]['New_Ledger_ID']=item['New_Ledger_ID'];
      }
      if(item['Seq_No']!=null) {
        var contain = Updated_list.indexWhere((element) => element['Ledger_ID']== item['Ledger_ID']);
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
    
/*    var itemLlist=Item_list;
    if(item['id']!=""){
      var index=Item_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Item_list[index]['ledgerName']=item['ledgerName'];
        Item_list[index]['currentBal']=item['currentBal'];
        Item_list[index]['amount']=item['amount'];
        Item_list[index]['narration']=item['narration'];
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
        Item_list = itemLlist;
      });
    }
    calculateTotalAmt();*/
  }

  getRecipt(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getPaymentVoucherDetail}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(widget.newDate)}&Voucher_Name=Receipt&Voucher_No=${widget.voucherNo}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                if(data!=null){
                  List<dynamic> _arrList = [];
                  print("data     $data   $_arrList");
                  _arrList=(data['accountDetails']);

                  setState(() {
                    Item_list=_arrList;
                    selectedbankCashLedger=data['accountVoucherHeader']['Ledger_Name'];
                    selectedBankLedgerID=data['accountVoucherHeader']['Ledger_ID'].toString();
                    TotalAmount=data['accountVoucherHeader']['Total_Amount'].toStringAsFixed(2) ;
                  });
                  if(Item_list.length>0){
                    position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.78);
                  }
                  // calculateTotalAmt();
                }
                isLoaderShow=false;
              });
              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  newwwwww  $data ");
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

  callPostReceipt() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    double TotalAmountInt= double.parse(TotalAmount);
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        postPaymentRecieptRequestModel model = postPaymentRecieptRequestModel(
          ledgerID:selectedBankLedgerID ,
          companyID: companyId ,
          voucherName: "Receipt",
          totalAmount:TotalAmountInt ,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
        creator: creatorName,
          creatorMachine: deviceId,
          iNSERT: Inserted_list.toList(),
        );
print("hufhfhjufr  ${Inserted_list.toList()} ");

print("newwwww   ${model.toJson()}");
        String apiUrl =baseurl + ApiConstants().getPaymentVouvher;
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




  updatecallPostReceipt() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    var matchDate=DateFormat('yyyy-MM-dd').format(invoiceDate).compareTo(DateFormat('yyyy-MM-dd').format(widget.dateNew));
    print("newOne    $matchDate");
    double TotalAmountInt= double.parse(TotalAmount);
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        postPaymentRecieptRequestModel model = postPaymentRecieptRequestModel(
          ledgerID:selectedBankLedgerID ,
          companyID: companyId ,
          voucherNo: widget.voucherNo,
          voucherName: "Receipt",
          totalAmount:TotalAmountInt ,
          dateNew:matchDate==0?null:DateFormat('yyyy-MM-dd').format(invoiceDate),
          date: DateFormat('yyyy-MM-dd').format(widget.dateNew),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          dELETE: Deleted_list.toList(),
          uPDATE: Updated_list.toList(),
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().getPaymentVouvher;
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

}

abstract class CreateReceiptInterface {
  backToList(DateTime updateDate);
}
