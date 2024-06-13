

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
import 'package:sweet_shop_app/data/domain/itemOpeningbalForCompany/item_opening_bal_for_company_req_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/getFranchisee.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/franchiseeItemOpeningBal/franchisee_item_opening_bal_req_body.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/exit_screen_dialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import 'add_or_edit_item_opening_bal.dart';

class CreateItemOpeningBal extends StatefulWidget {
  final CreateItemOpeningBalInterface mListener;
  final  dateNew;
  final editedItem;
  final compId;
  final come;
  final franchiseeDetails;
  final readOnly;

  const CreateItemOpeningBal({super.key, required this.dateNew, this.editedItem, required this.mListener, this.compId, this.come,   this.franchiseeDetails, this.readOnly});
  @override
  State<CreateItemOpeningBal> createState() => _CreateItemOpeningBalForCompanyState();
}

class _CreateItemOpeningBalForCompanyState extends State<CreateItemOpeningBal> with SingleTickerProviderStateMixin,AddOrEditItemOpeningBalInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _InvoiceNoFocus = FocusNode();
  final InvoiceNoController = TextEditingController();


  String selectedFranchiseeName="";
  var selectedFranchiseeID=null;

  String TotalAmount="0.00";

  List<dynamic> Item_list=[];

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  bool isLoaderShow=false;
  bool showButton=false;

  var editedItemIndex=null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceDate=widget.dateNew;
    if(widget.editedItem!=null) {
      setData();
    }
    else if(widget.franchiseeDetails!=null){
      setFranchisee();
    }
  }
  List fdetail=[];
  setFranchisee()async{
    setState(() {
      fdetail=widget.franchiseeDetails;
    });
    setState(() {
      selectedFranchiseeID=fdetail[1];
      selectedFranchiseeName=fdetail[0];
    });

    print(selectedFranchiseeName);
    await callGetFranchiseeItemOpeningList(0);
  }
  setData()async{
    setState(() {
      selectedFranchiseeID=widget.editedItem['Franchisee_ID'];
      selectedFranchiseeName=widget.editedItem['Name'];
    });
    await callGetFranchiseeItemOpeningList(0);
  }

  callGetFranchiseeItemOpeningList(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().franchisee_items}?Franchisee_ID=$selectedFranchiseeID&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                disableColor = false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  setState(() {
                    Item_list=_arrList;
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
                  if(selectedFranchiseeID==null){
                    var snackBar=SnackBar(content: Text("Select Franchisee Name !"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(Item_list.length==0){
                    var snackBar=SnackBar(content: Text("Add atleast one Item!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(selectedFranchiseeID!=null && Item_list.length>0) {
                    if (mounted) {
                      setState(() {
                        disableColor = true;
                      });
                      await callPostIFranchiseetemOpeningBal();
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
    return Container(
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
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),

                backgroundColor: Colors.white,
               title: Container(
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
                           ApplicationLocalizations.of(context)!.translate("item_opening_balance")!,
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

      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [

                  //    getFieldTitleLayout("Invoice Detail"),
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     widget.readOnly==false?Container():
                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if(selectedFranchiseeID!=null) {
                              if (context != null) {
                                editedItemIndex=null;
                                goToAddOrEditItem(null);

                              }
                            }
                            else{
                              CommonWidget.errorDialog(context, "Select Franchisee !");
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
                                  Text("${ApplicationLocalizations.of(context)!.translate("add_item")!}", style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Item_list.length>0? get_purchase_list_layout(parentHeight,parentWidth):Container(),

                  SizedBox(height: 10,),

                  //:Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

  Widget get_purchase_list_layout(double parentHeight, double parentWidth) {
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
                    goToAddOrEditItem(Item_list[index]);
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
                                        Text("${Item_list[index]['Name']}",style: item_heading_textStyle,),

                                        SizedBox(height: 5,),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth/3-50,
                                                child: Text(
                                                  CommonWidget.getCurrencyFormat(
                                                      double.parse(Item_list[index]
                                                      ['Quantity'].toString()))
                                                      .toString() + "${Item_list[index]['Unit']}",
                                                  // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']} ",
                                                  overflow: TextOverflow.ellipsis,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                              ),
                                            //  Text("${(Item_list[index]['Rate'])}/${Item_list[index]['Unit']} ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                              Item_list[index]['Amount']!=null?
                                              Expanded(
                                                child: Container(

                                                    alignment: Alignment.centerRight,
                                                    width: SizeConfig.halfscreenWidth-70,
                                                    child: Text(CommonWidget.getCurrencyFormat(double.parse(Item_list[index]['Amount'].toString())),overflow: TextOverflow.ellipsis,style: item_heading_textStyle.copyWith(color: Colors.blue),)),
                                              ):Container(),
                                            ],
                                          ),

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
                                    child:IconButton(
                                      icon:  FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 15,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: ()async{
                                        showButton=true;
                                        if(Item_list[index]['Seq_No']!=0){
                                          var deletedItem=   {
                                            "Seq_No": Item_list[index]['Seq_No'],
                                            "Item_ID": Item_list[index]['Item_ID']
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
    );

  }



  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
        apiUrl:ApiConstants().getFilteredFranchisee+"?",
        titleIndicator: false,
        franchisee: widget.come,
        readOnly: widget.readOnly,
        franchiseeName: selectedFranchiseeName,
        title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
        callback: (name,id){
          if(selectedFranchiseeID==id){
            var snack=SnackBar(content: Text(" Sale Ledger and Party can not be same!"));
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
          else {
            setState(() {
              showButton=true;
              selectedFranchiseeName = name!;
              selectedFranchiseeID = id;
              Item_list = [];
              Updated_list = [];
              Deleted_list = [];
              Inserted_list = [];
            });
            print(selectedFranchiseeID);
            print(selectedFranchiseeName);
          }
            callGetFranchiseeItemOpeningList(1);
          },
           ledgerName: selectedFranchiseeName,);GetFranchiseeLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("franchisee_name")! ,
        callback: (name,id){
          setState(() {
            selectedFranchiseeName=name!;
            selectedFranchiseeID=id;
            Item_list=[];
            Updated_list=[];
            Deleted_list=[];
            Inserted_list=[];
          });
          print(selectedFranchiseeID);
          print(selectedFranchiseeName);

          callGetFranchiseeItemOpeningList(1);
        },
        franchiseeName: selectedFranchiseeName);

  }

  Widget InvoiceInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getPurchaseDateLayout(),
          SizedBox(width: 5,),
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)
        ],
      ),
    );
  }

  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return Container(
        height: 42,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(CommonWidget.getDateLayout(invoiceDate),
              //DateFormat('dd-MM-yyyy').format(applicablefrom),
              style: item_regular_textStyle,),
            FaIcon(FontAwesomeIcons.calendar,
              color: Colors.black87, size: 16,)
          ],
        )
    );

      GetDateLayout(

        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          if(date!=null) {
            setState(() {
              invoiceDate = date!;
              Item_list=[];
              Updated_list=[];
              Deleted_list=[];
              Inserted_list=[];
            });
            callGetFranchiseeItemOpeningList(0);
          }
        },
        applicablefrom: invoiceDate
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
              child: AddOrEditItemOpeningBal(
                mListener: this,
                editproduct:product,
                existList: Item_list,
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
        });
  }


  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 0,bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
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
                Text("${Item_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                SizedBox(height: 2,),
                Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,)
              ],
            ),
          ),
          widget.readOnly==false||showButton==false?Container():  GestureDetector(
            onTap: ()async {
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
              if(selectedFranchiseeID==null){
                var snackBar=SnackBar(content: Text("Select Franchisee Name !"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else if(Item_list.length==0){
                var snackBar=SnackBar(content: Text("Add atleast one Item!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else if(selectedFranchiseeID!=null && Item_list.length>0) {
                if (mounted) {
                  setState(() {
                    disableColor = true;
                  });
                  await callPostIFranchiseetemOpeningBal();
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
      ),
    );
  }



  @override
  AddOrEditItemOpeningBalDetail(item)async {
    // TODO: implement AddOrEditItemSellDetail
    var itemLlist=Item_list;
showButton=true;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['Seq_No']=item['Seq_No'];
        Item_list[index]['Item_ID']=item['Item_ID'];
        Item_list[index]['Batch_ID']=item['Batch_ID'];
        Item_list[index]['Name']=item['Name'];
        Item_list[index]['Quantity']=item['Quantity'];
        Item_list[index]['Unit']=item['Unit'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['Amount']=item['Amount'];
      });
      print("#############3");
      print(item['Seq_No']);
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
    print("Listrrrkfknfknngvf");
    // Sort itemDetails by Item_Name
  //  itemLlist.sort((a, b) => a['Name'].compareTo(b['Name']));

    print(Inserted_list);
    print(Updated_list);
  }

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Item_list ){
      if(item['Amount']!=null||item['Amount']!="") {
        total = total + double.parse(item['Amount'].toString());
        print(item['Amount']);
      }
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }



  callPostIFranchiseetemOpeningBal() async {

    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostFranchiseeItemOpeningRequestModel model = PostFranchiseeItemOpeningRequestModel(

          franchiseeID:selectedFranchiseeID.toString() ,
          companyID: companyId ,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList()
      );

      String apiUrl =baseurl + ApiConstants().franchisee_item_opening;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=true;
              Item_list=[];
              Inserted_list=[];
              Updated_list=[];
              Deleted_list=[];
              widget.mListener.backToList();
            });
            await callGetFranchiseeItemOpeningList(0);

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

    });
  }
}

abstract class CreateItemOpeningBalInterface {
  backToList();
}