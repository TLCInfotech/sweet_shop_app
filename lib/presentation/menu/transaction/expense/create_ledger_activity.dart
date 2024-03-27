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
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/transaction/expense/post_expense_invoice_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import 'add_edit_ledger_for_ledger.dart';

class CreateLedger extends StatefulWidget {
  final CreateLedgerInterface mListener;
  final String dateNew;
  final  voucherNo;
  final come;
  const CreateLedger({super.key, required this.mListener, required this.dateNew, required this.voucherNo, this.come});
  @override
  _CreateLedgerState createState() => _CreateLedgerState();
}


class _CreateLedgerState extends State<CreateLedger> with SingleTickerProviderStateMixin,AddOrEditLedgerForLedgerInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();


  String selectedFranchiseeName="";
  String selectedFranchiseeId="";


  String TotalAmount="0.00";
//  List<dynamic> Item_list=[];
  List<dynamic> Item_list=[];

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  bool isLoaderShow=false;

  var editedItemIndex=null;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    calculateTotalAmt();
    if(widget.voucherNo!=null){
      getExpInvoice(1);
      voucherNoController.text="Voucher No: ${widget.voucherNo}";
    }

  }

  calculateTotalAmt()async{
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
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFfffff5),
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFfffff5),
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
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),

                    backgroundColor: Colors.white,
                    title:  Text(
                      ApplicationLocalizations.of(context)!.translate("expense_invoice_new")!,
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
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }


  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
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
                  LedgerInfo(),
                  const SizedBox(height: 10,),
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
                              padding: const EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: CommonColor.THEME_COLOR,
                                  border: Border.all(color: Colors.grey.withOpacity(0.5))
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(StringEn.ADD_EEXPENSE,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Item_list.length>0?get_Item_list_layout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }


  Container LedgerInfo() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey,width: 1),
        ),
        child:  widget.voucherNo==null? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: getReceiptDateLayout()),
          ],
        ):Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getReceiptDateLayout(),
            getVoucherNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)
          ],
        ),
      );
  }

  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }



  /* Widget to receipt dateLayout */
  Widget getReceiptDateLayout(){
    return GetDateLayout(
        comeFor: widget.voucherNo==null?"newOne":"",
        titleIndicator: false,
        parentWidth:widget.voucherNo!=null? (SizeConfig.screenWidth ):null,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            invoiceDate=date!;
            Item_list=[];
            Updated_list=[];
            Deleted_list=[];
            Inserted_list=[];
          });

          if(widget.voucherNo!=null){
            getExpInvoice(1);
          }
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

  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return  GetFranchiseeLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
        callback: (name,id){
          setState(() {
            selectedFranchiseeName=name!;
            selectedFranchiseeId=id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedFranchiseeId);
          print(selectedFranchiseeName);

          // if(widget.voucherNo!=""){
          //   getExpInvoice(1);
          // }
        },
        franchiseeName: selectedFranchiseeName);
  }



  /* widget for item list layout */
  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Item_list.length,
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
                    setState(() {
                      editedItemIndex=index;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditItem(Item_list[index]);
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
                                      padding: const EdgeInsets.only(left: 10),
                                      width: parentWidth*.70,
                                      //  height: parentHeight*.1,
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${Item_list[index]['Expense_Name']}",style: item_heading_textStyle,),

                                          const SizedBox(height: 3,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Text(CommonWidget.getCurrencyFormat(Item_list[index]['Amount']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          ),
                                          const SizedBox(height: 2 ,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Item_list[index]['Remark']!=null?Text("${Item_list[index]['Remark']}",overflow: TextOverflow.clip,style: item_regular_textStyle,):Container(),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),

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
                                              await calculateTotalAmt();  }
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
          return const SizedBox(
            height: 5,
          );
        },
      ),
    );
  }


  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TotalAmount!="0.00"? Container(
          width: SizeConfig.halfscreenWidth,
          padding: const EdgeInsets.only(top: 10,bottom:10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${Item_list.length}${StringEn.LEDGERS}",style: item_regular_textStyle.copyWith(color: Colors.grey),),
          Text( "${StringEn.ROUND_OFF} ${calculateRoundOffAmt().toStringAsFixed(2)}",style: item_regular_textStyle.copyWith(fontSize: 17),),
          const SizedBox(height: 4,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble())}",style: item_heading_textStyle,),
            ],
          ),
        ):Container(),
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                disableColor = true;
              });
            }
            print(widget.voucherNo);
            if(widget.voucherNo==null) {
             print("#######");
              callPostExpense();
            }
            else {
              print("dfsdf");
              updatecallPostExpense();
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


    /* calculate round off amount function */
  double calculateRoundOffAmt(){
    if(double.parse(TotalAmount.substring(TotalAmount.length-3,TotalAmount.length))==0.00){
      return 0.00;
    }
    else {
      var amt = (1 - double.parse(
          TotalAmount.substring(TotalAmount.length - 3, TotalAmount.length)));
      print(amt);
      if (amt == 0.00) {
        return 0.00;
      }
      if (amt < 0.50) {
        print((-1 * amt).toStringAsFixed(2));
        return amt;
      }
      else {
        print((amt).toStringAsFixed(2));
        return (-1 * amt);
      }
    }
  }


/* Widget for add and edit button layout*/
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
              child: AddOrEditLedgerForLedger(
                mListener: this,
                editproduct:product,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation2, animation1) {
          throw Exception('No widget to return in pageBuilder');
        });
  }


  /* Widget for add or edit ledger function */
  @override
  AddOrEditLedgerForLedgerDetail(item)async {
    // TODO: implement AddOrEditItemDetail
    var itemLlist=Item_list;

    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['New_Expense_ID']=item['New_Expense_ID'];
        Item_list[index]['Expense_Name']=item['Expense_Name'];
        Item_list[index]['Expense_ID']=item['Expense_ID'];
        Item_list[index]['Amount']=item['Amount'];
        Item_list[index]['Remark']=item['Remark'];
        Item_list[index]['Seq_No']=item['Seq_No'];
      });
      print("#############3");
      print(item['Seq_No']);
      if(item['New_Expense_ID']!=null){
        Item_list[index]['New_Expense_ID']=item['New_Expense_ID'];
      }
      if(item['Seq_No']!=null) {
        Updated_list.add(item);
        setState(() {
          Updated_list = Updated_list;
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



/*
    var itemLlist=Item_list;
    if(item['id']!=""){
      var index=Item_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Item_list[index]['Ledger_Name']=item['Ledger_Name'];
        Item_list[index]['currentBal']=item['currentBal'];
        Item_list[index]['Amount']=item['Amount'];
        Item_list[index]['Narration']=item['Narration'];
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
  //http://localhost:3000/getExpenseVoucherDetails?Company_ID=18&Voucher_No=21&Date=2024-03-18

  getExpInvoice(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getExpenseVoucherDetails}?Company_ID=$companyId&Voucher_No=${widget.voucherNo}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
          print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=(data['expenseDetails']);

                  setState(() {
                    Item_list=_arrList;
                    selectedFranchiseeName=data['voucherDetails']['Ledger_Name'];
                    selectedFranchiseeId=data['voucherDetails']['Ledger_ID'].toString();
                  });
                  calculateTotalAmt();
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

  callPostExpense() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String roundOffAmt =  calculateRoundOffAmt().toStringAsFixed(2);
    double roundOffAmtInt = double.parse(roundOffAmt);
   // String totalAmount =CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble());
    double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();
    print("fjfjhgjgj  $roundOffAmtInt  $TotalAmountInt");
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostExpenseInvoiceRequestModel model = PostExpenseInvoiceRequestModel(
          Ledger_ID:selectedFranchiseeId ,
          companyID: companyId ,
          Voucher_Name: "Expense",
          Round_Off:roundOffAmtInt ,
          Total_Amount:TotalAmountInt ,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          creater: creatorName,
          createrMachine: deviceId,
          iNSERT: Inserted_list.toList(),
      );

      String apiUrl =baseurl + ApiConstants().expense_voucher;
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


  updatecallPostExpense() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String roundOffAmt =  calculateRoundOffAmt().toStringAsFixed(2);
    double roundOffAmtInt = double.parse(roundOffAmt);
    // double updatedamt= await calculateTotalInsertAmt();
    double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();
    print("fjfjhgjgj  $roundOffAmtInt  $TotalAmountInt");
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostExpenseInvoiceRequestModel model = PostExpenseInvoiceRequestModel(
          Ledger_ID:selectedFranchiseeId ,
          voucher_No:widget.voucherNo ,
          companyID: companyId ,
          Voucher_Name: "Expense",
          Round_Off:roundOffAmtInt ,
          Total_Amount:TotalAmountInt ,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          dELETE: Deleted_list.toList(),
          uPDATE: Updated_list.toList(),
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().expense_voucher;
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

abstract class CreateLedgerInterface {
  backToList(DateTime updateDate);
}
