

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
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/presentation/dialog/city_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/transaction/saleInvoice/sale_invoice_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/getLedger.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/franchisee_dialog.dart';
import '../sell/add_or_edit_Item.dart';
import 'add_or_edit_Item.dart';


class CreatePurchaseInvoice extends StatefulWidget {
  final CreatePurchaseInvoiceInterface mListener;
  final String dateNew;
  final String Invoice_No;
  const CreatePurchaseInvoice({super.key,required this.mListener, required this.dateNew,required this.Invoice_No});

  @override
  _CreatePurchaseInvoiceState createState() => _CreatePurchaseInvoiceState();
}



class _CreatePurchaseInvoiceState extends State<CreatePurchaseInvoice> with SingleTickerProviderStateMixin,AddOrEditItemInterface {


  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    calculateTotalAmt();
    if(widget.Invoice_No!=""){
      gerSaleInvoice(1);
      setState(() {
        invoiceNo.text="Invoice No : ${widget.Invoice_No}";
      });
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

  /* Widget to get build context Layout */
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
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                    backgroundColor: Colors.white,
                    title:  Text(
                      ApplicationLocalizations.of(context)!.translate("purchase_invoice_new")!,
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
              Text("${Item_list.length} Items",style: item_regular_textStyle.copyWith(color: Colors.grey),),
              Text("Round off: ${calculateRoundOffAmt().toStringAsFixed(2)}",style: item_regular_textStyle.copyWith(fontSize: 17),),
              SizedBox(height: 4,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
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
            print(widget.Invoice_No);
            if(widget.Invoice_No=="") {
              print("#######");
              callPostSaleInvoice();
            }
            else {
              print("dfsdf");
              updatecallPostSaleInvoice();
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



  double calculateRoundOffAmt(){
    print(double.parse(TotalAmount.substring(TotalAmount.length-3,TotalAmount.length)));
    if(double.parse(TotalAmount.substring(TotalAmount.length-3,TotalAmount.length))==0.0){
      return 0.00;
    }
    else {
      var amt = (1 - double.parse(TotalAmount.substring(TotalAmount.length - 3, TotalAmount.length)));
      print("mvmnvmfnvfmv   $amt");
      if (amt == 0.00) {
        return 0.00;
      }
      if (amt < 0.50) {
        print("godddddddddd ${(-1 * amt).toStringAsFixed(2)}");
        var totalList=double.parse(TotalAmount).floorToDouble();
        setState(() {
          TotalAmount=totalList.toString();
        });
        return amt;
      }
      else {
        print((amt).toStringAsFixed(2));
        var totalList=double.parse(TotalAmount).ceilToDouble();
        setState(() {
          TotalAmount=totalList.toString();
        });
        return (-1 * amt);
      }
    }
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
                  InvoiceInfo(),
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
                              width: 120,
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
                                    ApplicationLocalizations.of(context)!.translate("add_item")!,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),

                  SizedBox(height: 10,),

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
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
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
                                                  child: Text("${(Item_list[index]['Quantity'])}.00${Item_list[index]['Unit']}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),)),

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(CommonWidget.getCurrencyFormat(Item_list[index]['Net_Amount']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                              ),
                                            ],
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
                                                  "Item_ID": Item_list[index]['Item_ID'],
                                                  "Seq_No": Item_list[index]['Seq_No'],
                                                };
                                                Deleted_list.add(deletedItem);
                                                setState(() {
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
          return SizedBox(
            height: 5,
          );
        },
      ),
    );
  }

  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(double parentHeight, double parentWidth){
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
              child: AddOrEditItem(
                mListener: this,
                editproduct:product,
                date: invoiceDate.toString(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width:widget.Invoice_No!=""?SizeConfig.halfscreenWidth:(SizeConfig.screenWidth)*.32,
                  child: getPurchaseDateLayout()),

              SizedBox(width: 5,),
              Expanded(
                  child:widget.Invoice_No!=""?getInvoiceNo(SizeConfig.screenHeight,SizeConfig.halfscreenWidth): getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
            ],
          ),
          widget.Invoice_No!=""?Row(
            children: [
              Expanded(child: getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth)),
              SizedBox(width: 5,),
              Expanded(child: getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth))
            ],
          ):
          getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)
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
      child: Text("${invoiceNo.text}",style:text_field_textStyle ,),
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
              invoiceDate=date!;
              Item_list=[];
              Updated_list=[];
              Deleted_list=[];
              Inserted_list=[];
            });

            if(widget.Invoice_No!=""){
              gerSaleInvoice(1);
            }
          },
          applicablefrom: invoiceDate
      );
  }

  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return
      GetFranchiseeLayout(
          titleIndicator: false,
          title: ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
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
          },
          franchiseeName: selectedFranchiseeName);
  }

  /* Widget to get sale ledger Name Layout */
  Widget getSaleLedgerLayout(double parentHeight, double parentWidth) {
    return GetLedgerLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("ledger")!,
        callback: (name,id){
          setState(() {
            selectedLedgerName=name!;
            selectedLedgerId=id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedLedgerId);
        },
        ledgerName: selectedLedgerName);
  }

  @override
  AddOrEditItemDetail(item)async {
    // TODO: implement AddOrEditItemDetail
    var itemLlist=Item_list;

    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['Item_Name']=item['Item_Name'];
        Item_list[index]['Quantity']=item['Quantity'];
        Item_list[index]['Unit']=item['Unit'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['Amount']=item['Amount'];
        Item_list[index]['Disc_Percent']=item['Disc_Percent'];
        Item_list[index]['Disc_Amount']=item['Disc_Amount'];
        Item_list[index]['Taxable_Amount']=item['Taxable_Amount'];
        Item_list[index]['CGST_Rate']=item['CGST_Rate'];
        Item_list[index]['CGST_Amount']=item['CGST_Amount'];
        Item_list[index]['Net_Rate']=item['Net_Rate'];
        Item_list[index]['Net_Amount']=item['Net_Amount'];
      });
      print("#############3");
      print(item['Seq_No']);
      if(item['New_Item_ID']!=null){
        Item_list[index]['New_Item_ID']=item['New_Item_ID'];
      }
      if(item['Seq_No']!=null) {
        Updated_list.add(Item_list[index]);
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
    await calculateRoundOffAmt();
    print("List");
    print(Inserted_list);
    print(Updated_list);
  }


  gerSaleInvoice(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getPurchaseInvoiceDetails}?Company_ID=$companyId&Invoice_No=${widget.Invoice_No}&pageNumber=$page&pageSize=10";
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
                    selectedFranchiseeId=data['voucherDetails']['Vendor_ID'].toString();
                    selectedLedgerName=data['voucherDetails']['Sale_Ledger_Name'];
                    selectedLedgerId=data['voucherDetails']['Sale_Ledger'].toString();

                  });
                  calculateTotalAmt();
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

  callPostSaleInvoice() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String roundOffAmt =  calculateRoundOffAmt().toStringAsFixed(2);
    double roundOffAmtInt = double.parse(roundOffAmt);
 double TotalAmountInt= double.parse(TotalAmount).ceilToDouble();
    print("fjfjhgjgj  $roundOffAmtInt  $TotalAmountInt");
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        postSaleInvoiceRequestModel model = postSaleInvoiceRequestModel(
            purchaseLedger:selectedLedgerId ,
            vendorID:selectedFranchiseeId ,
            companyID: companyId ,
            voucherName: "Purchase",
            roundOff:roundOffAmtInt ,
            totalAmount:TotalAmountInt,
            date: DateFormat('yyyy-MM-dd').format(invoiceDate),
            creator: creatorName,
            creatorMachine: deviceId,
            iNSERT: Inserted_list.toList(),
            remark: "Inserted"
        );

        String apiUrl =baseurl + ApiConstants().getPurchaseInvoice;
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
              widget.mListener.backToList();

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
        postSaleInvoiceRequestModel model = postSaleInvoiceRequestModel(
            purchaseLedger:selectedLedgerId ,
            vendorID:selectedFranchiseeId ,
            invoiceNo:widget.Invoice_No ,
            companyID: companyId ,
            voucherName: "Purchase",
            roundOff:roundOffAmtInt,
            totalAmount:TotalAmountInt,
            date: DateFormat('yyyy-MM-dd').format(invoiceDate),
            modifier: creatorName,
            modifierMachine: deviceId,
            iNSERT: Inserted_list.toList(),
            dELETE: Deleted_list.toList(),
            uPDATE: Updated_list.toList(),
            remark:"Modified"
        );

        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().getPurchaseInvoice;
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
              widget.mListener.backToList();

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

abstract class CreatePurchaseInvoiceInterface {
  backToList();
}