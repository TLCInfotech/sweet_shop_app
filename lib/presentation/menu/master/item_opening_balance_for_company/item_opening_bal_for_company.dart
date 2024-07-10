import 'dart:convert';
import 'dart:io';
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
import 'package:sweet_shop_app/data/domain/itemOpeningbalForCompany/item_opening_bal_for_company_req_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/deleteDialog.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_date_layout.dart';
import 'add_or_edit_company_item_opening.dart';

class CreateItemOpeningBalForCompany extends StatefulWidget {
  final String dateNew;
  final  formId;
  final  arrData;
  final String logoImage;
  const CreateItemOpeningBalForCompany({super.key, required this.dateNew, this.formId, this.arrData, required this.logoImage});
  @override
  State<CreateItemOpeningBalForCompany> createState() => _CreateItemOpeningBalForCompanyState();
}

class _CreateItemOpeningBalForCompanyState extends State<CreateItemOpeningBalForCompany> with SingleTickerProviderStateMixin,AddOrEditItemOpeningBalForCompanyInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _InvoiceNoFocus = FocusNode();
  final InvoiceNoController = TextEditingController();


  String selectedFranchiseeName="";

  String TotalAmount="0.00";

  List<dynamic> Item_list=[];

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


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

  bool isLoaderShow=false;
  bool showButton=false;

  var editedItemIndex=null;


  callGetItemOpeningList(int page) async {
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String companyId = await AppPreferences.getCompanyId();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().item_opening}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&PageNumber=$page&PageSize=10";
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
                  if(Item_list.length>0){
                    position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.78);
                  }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetItemOpeningList(0);
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
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
        },
        child: contentBox(context));
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
                              await  showCustomDialog(context);
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
                                ApplicationLocalizations.of(context)!.translate("company_item_opening")!,
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
        singleRecord['Insert_Right']==true||singleRecord['Update_Right']==true ? Positioned(
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
                  if (context != null) {
                    editedItemIndex=null;
                    goToAddOrEditItem(null,true);
                  }
                }),
          ),
        ):Container(),

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
                  if (mounted) {
                    setState(() {
                      showButton = false;
                    });
                    await callPostItemOpeningBal();}
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //
                  //     singleRecord['Insert_Right']==true||singleRecord['Update_Right']==true ?GestureDetector(
                  //         onTap: (){
                  //           FocusScope.of(context).requestFocus(FocusNode());
                  //           if (context != null) {
                  //             editedItemIndex=null;
                  //             goToAddOrEditItem(null,true);
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
                  //                 Text("${ApplicationLocalizations.of(context)!.translate("add_item")!}", style: item_heading_textStyle,),
                  //                 FaIcon(FontAwesomeIcons.plusCircle,
                  //                   color: Colors.black87, size: 20,)
                  //               ],
                  //             )
                  //
                  //         )
                  //     ):Container()
                  //   ],
                  // ),
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
        print(Item_list[index]['Amount']);
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
                    goToAddOrEditItem(Item_list[index],singleRecord['Update_Right']);
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
                                          //    Text("${(Item_list[index]['Rate'])}",overflow: TextOverflow.clip,style: item_regular_textStyle,),
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

                                singleRecord['Delete_Right']==true?Container(
                                  width: parentWidth*.08,
                                  color: Colors.transparent,
                                  child: DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
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
                                          setState(() {
                                            showButton=true;});
                                          }; }
                                      ),
                                )

    :Container(),
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


  Container InvoiceInfo() {
    return Container(
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
              width:(SizeConfig.screenWidth)*0.87,
              child: getPurchaseDateLayout()),
        ],
      ),
    );
  }

  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(

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
            callGetItemOpeningList(0);
          }
        },
        applicablefrom: invoiceDate
    );

  }


  Future<Object?> goToAddOrEditItem(product,update) {
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
              child: AddOrEditItemOpeningBalForCompany(
                mListener: this,
                readOnly: update,
                editproduct:product,
                existList: Item_list,
                date:invoiceDate.toString()
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
          Item_list.length==0?Container():Container(
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
                Text("${Item_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                SizedBox(height: 4,),
                Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,)
              ],
            ),
          ),
          singleRecord['Update_Right']==false&&singleRecord['Insert_Right']==false||showButton==false?Container():GestureDetector(
            onTap: ()async {
              if (mounted) {
                  setState(() {
                    showButton = false;
                  });
                  await callPostItemOpeningBal();
                }},
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
  AddOrEditItemOpeningBalForCompanyDetail(item)async {
    // TODO: implement AddOrEditItemSellDetail
    var itemLlist=Item_list;
showButton=true;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['Seq_No']=item['Seq_No'];
        Item_list[index]['Item_ID']=item['Seq_No']!=null?item['New_Item_ID']:item['Item_ID'];

        // Item_list[index]['Item_ID']=item['New_Item_ID'];
        Item_list[index]['Batch_ID']=item['Batch_ID'];
        Item_list[index]['Item_Name']=item['Item_Name'];
        Item_list[index]['Quantity']=item['Quantity'];
        Item_list[index]['Unit']=item['Unit'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['Amount']=item['Amount'];
      });
      if(item['New_Item_ID']!=null){
        print("#############3");
        print("present");
        setState(() {
          Item_list[index]['Item_ID']=item['Item_ID'];
          Item_list[index]['New_Item_ID']=item['New_Item_ID'];
        });
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
      else{
        setState(() {
          Item_list[index]=item;
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
    // Sort itemDetails by Item_Name
    itemLlist.sort((a, b) => a['Item_Name'].compareTo(b['Item_Name']));
    print(Updated_list);
    if(Item_list.length>0){
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
    }else{
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
    }
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


  callPostItemOpeningBal() async {
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostItemOpeningRequestModel model = PostItemOpeningRequestModel(
          companyID: companyId,
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList()
      );

      String apiUrl = baseurl + ApiConstants().item_opening;
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
            await callGetItemOpeningList(0);

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

abstract class CreateItemOpeningBalForCompanyInterface {
}