import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
import '../../../../data/domain/transaction/journals/postJournalRequestBody.dart';
import '../../../../data/domain/transaction/payment_reciept_contra_journal/payment_recipt_contra_journal_req_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_bank_cash_ledger.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dialog/franchisee_dialog.dart';
import 'add_edit_journal_voucher.dart';

class CreateJournals extends StatefulWidget {
  final CreateJournalInterface mListener;
  final  dateNew;
  final  voucherNo;

  const CreateJournals({super.key,required this.mListener, required this.dateNew,required this.voucherNo});
  @override
  _CreateJournalsState createState() => _CreateJournalsState();
}



class _CreateJournalsState extends State<CreateJournals> with SingleTickerProviderStateMixin,AddOrEditLedgerForJournalsInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));


  String selectedbankCashLedger="";
  var selectedBankLedgerID=null;

  List<dynamic> Ledger_list=[];



  String TotalAmount="0.00";
  double TotalCr=0.00;
  double TotalDr=0.00;

//  List<dynamic> Item_list=[];

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
    invoiceDate=widget.dateNew;
    if(widget.voucherNo!=null){
      getExpInvoice(1);
      voucherNoController.text="Voucher No: ${widget.voucherNo}";
    }

  }

  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in Ledger_list ){
      total=total+item['Amount'];
      print(item['Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });
    var totalamt=0.00;
    var totalcr=0.00;
    var totaldr=0.00;
    for(var item  in Ledger_list ){
      total=total+item['Amount'];
      if(item['Amnt_Type']=="CR"){
        totalcr=totalcr+item['Amount'];
      }
      else  if(item['Amnt_Type']=="DR"){
        totaldr=totaldr+item['Amount'];
      }
    }
      setState(() {
        // TotalAmount=total.isNegative?(-1*total).toStringAsFixed(2):total.toStringAsFixed(2) ;
        TotalCr=totalcr;
        TotalDr=totaldr;
      });

  }
  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }


/* Widget for build context layout*/
  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFfffff5),
            borderRadius: BorderRadius.circular(0.0),
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
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("journal_voucher")!,
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
                      child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                Container(
                    decoration: const BoxDecoration(
                      color: CommonColor.WHITE_COLOR,

                    ),
                    height: SizeConfig.safeUsedHeight * .12,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
              ],
            ),
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }


/* Widget for all field layout*/
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
                  journalInfo(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //  Ledger_list.length>0?getFieldTitleLayout(StringEn.LEADER_DETAIL):Container(),
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
                                  Text(StringEn.ADD_LEADER,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Ledger_list.length>0?    get_Item_list_layout(parentHeight,parentWidth):Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

/* Widget for payment info layout*/
  Container journalInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child:     widget.voucherNo==null? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
     Expanded(
              // width:(SizeConfig.screenWidth),
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


/* Widget for item list layout layout*/
  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Ledger_list.length,
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
                                      padding: const EdgeInsets.only(left: 10),
                                      width: parentWidth*.70,
                                      //  height: parentHeight*.1,
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${Ledger_list[index]['Ledger_Name']}",style: item_heading_textStyle,),

                                          const SizedBox(height: 3,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child: Text(CommonWidget.getCurrencyFormat(Ledger_list[index]['Amount'])+" ${Ledger_list[index]['Amnt_Type']}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          // +" ${Ledger_list[index]['Amnt_Type']}"
                                          ),
                                          const SizedBox(height: 2 ,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child: Text("${Ledger_list[index]['Remark']}",overflow: TextOverflow.clip,style: item_regular_textStyle,),
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
                                              if(Ledger_list[index]['Seq_No']!=null){
                                                var deletedItem=   {
                                                  "Ledger_ID": Ledger_list[index]['Ledger_ID'],
                                                  "Seq_No": Ledger_list[index]['Seq_No'],
                                                  "Amnt_Type":Ledger_list[index]['Amnt_Type'],
                                                  "Date":DateFormat('yyyy-MM-dd').format(invoiceDate)//"2024-03-26"
                                                };
                                                Deleted_list.add(deletedItem);
                                                setState(() {
                                                  Deleted_list=Deleted_list;
                                                });
                                              }

                                              var contain = Inserted_list.indexWhere((element) => element['Ledger_ID']== Ledger_list[index]['Ledger_ID']);
                                              print(contain);
                                              if(contain>=0){
                                                print("REMOVE");
                                                Inserted_list.remove(Inserted_list[contain]);
                                              }
                                              Ledger_list.remove(Ledger_list[index]);
                                              setState(() {
                                                Ledger_list=Ledger_list;
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
        title:   ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            invoiceDate=date!;
          });
        },
        applicablefrom: invoiceDate
    );
  }
  final voucherNoController = TextEditingController();
  final _voucherNoFocus = FocusNode();
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
    return  GetBankCashLedger(
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



  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: SizeConfig.halfscreenWidth,
          padding: const EdgeInsets.only(top: 10,bottom:10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Ledger_list.length>0?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("${Ledger_list.length} Ledgers",style: item_regular_textStyle.copyWith(color: Colors.grey),),
              Text("Total Cr : ${CommonWidget.getCurrencyFormat((TotalCr).ceilToDouble())} CR",style: item_heading_textStyle,),
              Text("Total Dr : ${CommonWidget.getCurrencyFormat((TotalDr).ceilToDouble())} DR",style: item_heading_textStyle,),
            ],
          ):Container(),
        ),
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                disableColor = true;
              });
            }
            print(widget.voucherNo);

            if(Ledger_list.length==0){
              var snackBar=SnackBar(content: Text("Add atleast one ledger!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                disableColor = false;
              });
            }
            else if((TotalCr).ceilToDouble()!=(TotalDr).ceilToDouble()){
              var snackBar = SnackBar(
                  content: Text('Match Total Credit and Debit!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                disableColor = false;
              });
            }
            else if((TotalCr).ceilToDouble()==(TotalDr).ceilToDouble()&&Ledger_list.length>0) {
              if (widget.voucherNo == null) {
                print("#######");
                callPostBankLedgerPayment();
              }
              else {


                updatecallPostBankLedgerPayment();
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
                  child: const Text(
                    StringEn.SAVE,
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

/* Widget for add or edit button layout*/
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
              child: AddOrEditLedgerForJournals(
                mListener: this,
                editproduct:product,
                newdate: DateFormat("yyyy-MM-dd").format(invoiceDate),
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

  /* Widget for get franchisee drop down function */
  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedbankCashLedger=name;
      selectedBankLedgerID=id;
    });
  }

  /* Widget for add or edit ledger function */
  @override
  AddOrEditLedgerForJournalsDetail(item)async {
    // TODO: implement AddOrEditItemDetail
    var itemLlist=Ledger_list;

    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
       // Ledger_list[index]['Date']=item['Date'];
        // Ledger_list[index]['New_Ledger_ID']=item['New_Ledger_ID'];
        Ledger_list[index]['Ledger_Name']=item['Ledger_Name'];
        Ledger_list[index]['Ledger_ID']=item['Ledger_ID'];
        Ledger_list[index]['Amount']=item['Amount'];
        Ledger_list[index]['Amnt_Type']=item['Amnt_Type'];
        Ledger_list[index]['Remark']=item['Remark'];
        Ledger_list[index]['Seq_No']=item['Seq_No'];
      });
      print("#############3");
      print(item['Seq_No']);
      if(item['New_Ledger_ID']!=null){
        Ledger_list[index]['New_Ledger_ID']=item['New_Ledger_ID'];
      }
      if(item['Seq_No']!=null) {
        Updated_list.add(Ledger_list[index]);
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
        Ledger_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex=null;
    });
    await calculateTotalAmt();
    print("List");
    print(Inserted_list);
    print(Updated_list);

  }



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
        String apiUrl = "${baseurl}${ApiConstants().getJournalVouchers}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&Voucher_Name=Journal&Voucher_No=${widget.voucherNo}&PageNumber=$page&PageSize=10";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=(data['details']);

                  setState(() {
                    Ledger_list=_arrList;
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

  callPostBankLedgerPayment() async {
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
        PostJournalRequestModel model = PostJournalRequestModel(
          // ledgerID:selectedBankLedgerID ,
          companyID: companyId ,
          voucherName: "Journal",
          // totalAmount: TotalAmountInt,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          creator: creatorName,
          creatorMachine: deviceId,
          iNSERT: Inserted_list.toList(),
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().getJournalVouchers;
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=true;
                Ledger_list=[];
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


  updatecallPostBankLedgerPayment() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();
    var matchDate=DateFormat('yyyy-MM-dd').format(invoiceDate).compareTo(DateFormat('yyyy-MM-dd').format(widget.dateNew));
    print("dfsdf    $matchDate");
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostJournalRequestModel model = PostJournalRequestModel(
            voucherNo: widget.voucherNo,
            companyID: companyId ,
            voucherName: "Journal",
            dateNew:matchDate==0?null:DateFormat('yyyy-MM-dd').format(invoiceDate),
            date: DateFormat('yyyy-MM-dd').format(widget.dateNew),
            modifier: creatorName,
            modifierMachine: deviceId,
            iNSERT: Inserted_list.toList(),
            uPDATE: Updated_list.toList(),
            dELETE: Deleted_list.toList()
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().getJournalVouchers;
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=true;
                Ledger_list=[];
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

abstract class CreateJournalInterface {
  backToList(DateTime date);
}
