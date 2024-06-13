import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/add_new_sale_rate_product.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/franchiseeSaleRate/franchisee_sale_rate_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/exit_screen_dialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class FranchiseeSaleRate extends StatefulWidget {
  final String compId;
  final formId;
  final arrData;
  const FranchiseeSaleRate(
      {super.key, required this.compId, this.formId, this.arrData});

  @override
  State<FranchiseeSaleRate> createState() => _FranchiseeSaleRateState();
}

class _FranchiseeSaleRateState extends State<FranchiseeSaleRate>
    with AddProductSaleRateInterface {
  final _formkey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  String selectedFranchiseeName = "";
  String selectedProductCategory = "";
  DateTime applicablefrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  String selectedCopyFranchiseeName = "";
  String selectedCopyFranchiseeId = "";
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var singleRecord;
/*  List<dynamic> Item_list=[
    {
      "id":1,
      "pname":"Gulakand Burfi",
      "rate":1000.00,
      "gst":12,
      "gstAmt":120,
      "net":1120.00,
    },
    {
      "id":2,
      "pname":"Mango Burfi",
      "rate":800.00,
      "gst":12,
      "gstAmt":96,
      "net":896.00,
    },
  ];*/
  List<dynamic> Item_list = [];
  List<dynamic> Updated_list = [];
  var editedItemIndex = null;
  List<dynamic> Inserted_list = [];

  List<dynamic> Deleted_list = [];
  bool isLoaderShow = false;
  bool showButton = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCompanyId();
    setVal();
    calculateTotalAmt();
    // _scrollController.addListener(_scrollListener);
    if (selectedCopyFranchiseeId != "") {
      callGetFrenchisee(page);
    }
  }

  setVal() async {
    print(widget.arrData);
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord =
        jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print(
        "singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }

  String companyId = "";
  getCompanyId() async {
    companyId = await AppPreferences.getCompanyId();
    setState(() {
      //companyId=companyId1;
      print("jjgjgjg   $companyId");
    });
  }

  int page = 1;
  bool isPagination = true;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetFrenchisee(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showButton == true) {
          await   showCustomDialog(context,callPostItemOpeningBal);
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            backgroundColor: Color(0xFFfffff5),
            appBar: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child: SafeArea(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.transparent,
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    leadingWidth: 0,
                    automaticallyImplyLeading: false,
                    title: Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (showButton == true) {
                             await   showCustomDialog(context,callPostItemOpeningBal);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: FaIcon(Icons.arrow_back),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!
                                    .translate("franchisee_sale_rate")!,
                                style: appbar_text_style,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                      // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(
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
                    height: SizeConfig.safeUsedHeight * .08,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
                CommonWidget.getCommonPadding(
                    SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
              ],
            ),
          ),
          Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
        ],
      ),
    );
  }


  Future<void> showCustomDialog(BuildContext context, Function onYesCallback) async {
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
                if(value=="yes"){
                  if (selectedCopyFranchiseeId ==
                      "") {
                    var snackBar = SnackBar(
                        content: Text(
                            "Select Franchisee Name !"));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  } else if (selectedCopyFranchiseeId !=
                      "") {
                    if (mounted) {
                      setState(() {
                        showButton = false;
                      });
                    }
                   await onYesCallback();
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Item_list.length == 0
            ? Container()
            : Container(
                width: SizeConfig.halfscreenWidth,
                padding: EdgeInsets.only(top: 0, bottom: 0),
                decoration: BoxDecoration(
                  // color:  CommonColor.DARK_BLUE,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Item_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}",
                      style:
                          item_regular_textStyle.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
        singleRecord['Insert_Right'] == false ||
                singleRecord['Update_Right'] == false ||
                showButton == false
            ? Container()
            : GestureDetector(
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

                  if (selectedCopyFranchiseeId == "") {
                    var snackBar =
                        SnackBar(content: Text("Select Franchisee Name !"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (selectedCopyFranchiseeId != "") {
                    if (mounted) {
                      setState(() {
                        showButton = false;
                      });
                    }
                    callPostItemOpeningBal();
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
                        child: Text(
                          ApplicationLocalizations.of(context)!
                              .translate("save")!,
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

  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: parentHeight * .01,
              left: parentWidth * .03,
              right: parentWidth * .03),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  //  getFieldTitleLayout("Invoice Detail"),
                  InvoiceInfo(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      singleRecord['Insert_Right'] == true ||
                              singleRecord['Update_Right'] == true
                          ? GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  editedItemIndex = null;
                                });
                                if (selectedCopyFranchiseeId != "") {
                                  editedItemIndex = null;
                                  goToAddOrEditProduct(null);
                                } else {
                                  CommonWidget.errorDialog(
                                      context, "Select franchisee first.");
                                }
                              },
                              child: Container(
                                  width: 140,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: CommonColor.THEME_COLOR,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ApplicationLocalizations.of(context)!
                                            .translate("add_item")!,
                                        style: item_heading_textStyle,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.plusCircle,
                                        color: Colors.black87,
                                        size: 20,
                                      )
                                    ],
                                  )))
                          : Container()
                    ],
                  ),
                  Item_list.isNotEmpty
                      ? get_purchase_list_layout(parentHeight, parentWidth)
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
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
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -44.0,
            child: FadeInAnimation(
              delay: Duration(microseconds: 1500),
              child: GestureDetector(
                onTap: () {
                  if (singleRecord['Update_Right'] == true) {
                    setState(() {
                      editedItemIndex = index;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditProduct(Item_list[index]);
                    }
                  }
                },
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                    width: parentWidth * .1,
                                    height: parentWidth * .1,
                                    decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${index + 1}",
                                      textAlign: TextAlign.center,
                                      style: item_heading_textStyle.copyWith(
                                          fontSize: 14),
                                    )),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: parentWidth * .70,
                                    //  height: parentHeight*.1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${Item_list[index]['Name']}",
                                          style: item_heading_textStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        /*  Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child:
                                          Text("${(Item_list[index]['quantity'])}.00 ${Item_list[index]['unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                        ),
                                        SizedBox(height: 5,),*/
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                CommonWidget.getCurrencyFormat(
                                                            double.parse(
                                                                Item_list[index]
                                                                        ['Rate']
                                                                    .toString()))
                                                        .toString() +
                                                    "/${Item_list[index]['Unit']}"
                                                // "${(Item_list[index]['Rate']).toStringAsFixed(2)}/kg "
                                                ,
                                                overflow: TextOverflow.clip,
                                                style: item_heading_textStyle
                                                    .copyWith(
                                                        color: Colors.black87),
                                              ),
                                              //Text("${(Item_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width:
                                                    SizeConfig.halfscreenWidth -
                                                        50,
                                                child: Text(
                                                  CommonWidget.getCurrencyFormat(
                                                              double.parse(Item_list[
                                                                          index]
                                                                      [
                                                                      'Net_Rate']
                                                                  .toString()))
                                                          .toString() +
                                                      "/${Item_list[index]['Unit']}",
                                                  // "${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/kg ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: item_heading_textStyle
                                                      .copyWith(
                                                          color: Colors.blue),
                                                ),
                                              ),

                                              //  Text(CommonWidget.getCurrencyFormat(Item_list[index]['net']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                singleRecord['Delete_Right'] == true
                                    ? Container(
                                        width: parentWidth * .1,
                                        // height: parentHeight*.1,
                                        color: Colors.transparent,
                                        child: DeleteDialogLayout(
                                            callback: (response) async {
                                          if (response == "yes") {
                                            showButton = true;
                                            if (Item_list[index]['ID'] != 0) {
                                              var deletedItem = {
                                                "Item_ID": Item_list[index]
                                                    ['Item_ID'],
                                                "ID": Item_list[index]['ID'],
                                              };
                                              Deleted_list.add(deletedItem);
                                              setState(() {
                                                Deleted_list = Deleted_list;
                                              });
                                            }

                                            var contain =
                                                Inserted_list.indexWhere(
                                                    (element) =>
                                                        element['Item_ID'] ==
                                                        Item_list[index]
                                                            ['Item_ID']);
                                            print(contain);
                                            if (contain >= 0) {
                                              print("REMOVE");
                                              Inserted_list.remove(
                                                  Inserted_list[contain]);
                                            }
                                            Item_list.remove(Item_list[index]);
                                            setState(() {
                                              Item_list = Item_list;
                                              Inserted_list = Inserted_list;
                                            });
                                            print(Inserted_list);
                                            await calculateTotalAmt();
                                          }
                                        }))
                                    : Container(),
                              ],
                            )),
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

  // String getFrenchiseeItemRateList="getFranchaiseeItemRateList";
  // String frenchiseeItemRate="franchiseeItemRate";
  Container InvoiceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            child: getApplicableFromLayout(
                SizeConfig.screenHeight, SizeConfig.screenWidth),
          ),
          SearchableLedgerDropdown(
              apiUrl: ApiConstants().getFilteredFranchisee + "?",
              titleIndicator: false,
              title: ApplicationLocalizations.of(context)!
                  .translate("franchisee")!,
              callback: (name, id) {
                // if(selectedCopyFranchiseeId==id){
                //   var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
                //   ScaffoldMessenger.of(context).showSnackBar(snack);
                // }
                // else {
                setState(() {
                  // showButton=true;
                  selectedCopyFranchiseeName = name!;
                  selectedCopyFranchiseeId = id!;

                  Item_list = [];
                  Updated_list = [];
                  Inserted_list = [];
                  Deleted_list = [];
                  callGetFrenchisee(1);
                });
                // }
                print(selectedCopyFranchiseeId);
              },
              ledgerName: selectedCopyFranchiseeName),
          /*  GetFranchiseeLayout(
              titleIndicator:false,
              title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
              callback: (name,id){
                setState(() {
                  selectedCopyFranchiseeName=name!;
                  selectedCopyFranchiseeId=id!;
                });
                setState(() {
                  Item_list=[];
                  Updated_list=[];
                  Inserted_list=[];
                  Deleted_list=[];
                });    callGetFrenchisee(1);
              },
              franchiseeName: selectedCopyFranchiseeName),*/
          Container(
            width: SizeConfig.screenWidth,
            child: getProductCategoryLayout(),
          ),
        ],
      ),
    );
  }

  Future<Object?> goToAddOrEditProduct(product) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddProductSaleRate(
                mListener: this,
                id: selectedCopyFranchiseeId,
                editproduct: product,
                exstingList: Item_list,
                dateNew: DateFormat('yyyy-MM-dd').format(applicablefrom),
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

  /* Widget to get add Product Layout */
  Widget getApplicableFromLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (name) {
          setState(() {
            showButton = true;
            applicablefrom = name!;
          });
          if (selectedCopyFranchiseeId != "") {
            setState(() {
              Item_list = [];
              Updated_list = [];
              Inserted_list = [];
              Deleted_list = [];
            });
            callGetFrenchisee(1);
          }
        },
        applicablefrom: applicablefrom);
  }

  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout() {
    return SearchableLedgerDropdown(
        apiUrl: ApiConstants().item_category + "?",
        titleIndicator: false,
        readOnly: singleRecord['Update_Right'] || singleRecord['Insert_Right'],
        title: ApplicationLocalizations.of(context)!.translate("category")!,
        callback: (name, id) {
          setState(() {
            //  showButton=true;
            selectedProductCategory = name!;
            //selectedCopyFranchiseeId=id!;
          });
          print(selectedProductCategory);
        },
        ledgerName: selectedProductCategory);
  }

  String TotalAmount = "0.00";
  calculateTotalAmt() async {
    print("Here");
    var total = 0.00;
    for (var item in Item_list) {
      total = total + item['Net_Rate'];
      print("hjfhjfeefbh  ${item['Net_Rate']}");
    }
    setState(() {
      TotalAmount = total.toStringAsFixed(2);
    });
  }

  @override
  addProductSaleRateDetail(dynamic item) async {
    // TODO: implement addProductDetail
    print(item);
    var itemLlist = Item_list;
    showButton = true;
    if (editedItemIndex != null) {
      var index = editedItemIndex;
      setState(() {
        Item_list[index]['ID'] = item['ID'];
        Item_list[index]['Item_ID'] =
            item['ID'] != null ? item['New_Item_ID'] : item['Item_ID'];
        Item_list[index]['New_Item_ID'] = item['New_Item_ID'];
        Item_list[index]['Name'] = item['Name'];
        Item_list[index]['Disc_Percent'] = item['Disc_Percent'];
        Item_list[index]['Rate'] = item['Rate'];
        Item_list[index]['GST'] = item['GST'];
        Item_list[index]['GST_Amount'] = item['GST_Amount'];
        Item_list[index]['Net_Rate'] = item['Net_Rate'];
        Item_list[index]['Unit'] = item['Unit'];
      });
      if (item['New_Item_ID'] != null) {
        print("#############3");
        print("present");
        setState(() {
          Item_list[index]['Item_ID'] = item['Item_ID'];
          Item_list[index]['New_Item_ID'] = item['New_Item_ID'];
        });
      }
      if (item['ID'] != null) {
        var contain = Updated_list.indexWhere(
            (element) => element['Item_ID'] == item['Item_ID']);
        print(contain);
        if (contain >= 0) {
          print("REMOVE");
          Updated_list.remove(Updated_list[contain]);
          Updated_list.add(item);
        } else {
          Updated_list.add(item);
        }
        setState(() {
          Updated_list = Updated_list;
          print("hvhfvbfbv   $Updated_list");
        });
      } else {
        setState(() {
          Item_list[index] = item;
        });
      }
    } else {
      itemLlist.add(item);
      Inserted_list.add(item);
      setState(() {
        Inserted_list = Inserted_list;
      });
      print(itemLlist);

      setState(() {
        Item_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex = null;
    });
    await calculateTotalAmt();
    // Sort itemDetails by Item_Name
    // itemLlist.sort((a, b) => a['Name'].compareTo(b['Name']));

    print("#############################################3\n ${Inserted_list}");
    print("#############################################3\n ${Updated_list}");

    print(Updated_list);
  }

  callPostItemOpeningBal() async {
    String baseurl = await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow = true;
      });
      FranchiseeSaleRequest model = FranchiseeSaleRequest(
          companyID: companyId,
          Franchisee_ID: selectedCopyFranchiseeId,
          Txn_Type: "S",
          date: DateFormat('yyyy-MM-dd').format(applicablefrom),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList());
      print("mosdeemmm  ${model.toJson()}");
      String apiUrl = baseurl + ApiConstants().franchisee_item_rate;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess: (data) async {
        print("  ITEM  $data ");
        setState(() {
          isLoaderShow = false;
          Item_list = [];
          Inserted_list = [];
          Updated_list = [];
          Deleted_list = [];
        });
        await callGetFrenchisee(1);
      }, onFailure: (error) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.errorDialog(context, error.toString());
      }, onException: (e) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.errorDialog(context, e.toString());
      }, sessionExpire: (e) {
        setState(() {
          isLoaderShow = false;
        });
        CommonWidget.gotoLoginScreen(context);
        // widget.mListener.loaderShow(false);
      });
    });
  }

  bool isApiCall = false;
  callGetFrenchisee(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
            TokenRequestModel(token: sessionToken, page: "");
        String apiUrl =
            "$baseurl${ApiConstants().franchisee_item_rate_list}?Franchisee_ID=$selectedCopyFranchiseeId&Date=${DateFormat('yyyy-MM-dd').format(applicablefrom)}&Company_ID=$companyId&Txn_Type=S";
        // &PageNumber=$page&PageSize=10";
        print("newwww  $apiUrl   $baseurl ");
        //  "?pageNumber=$page&PageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
          setState(() {
            isLoaderShow = false;
            disableColor = false;
            if (data != null) {
              // Item_list=data;
              print("ledger opening data....  $data");

              List<dynamic> _arrList = [];
              //  _arrList.clear();
              _arrList = data;
              if (_arrList.length < 10) {
                if (mounted) {
                  setState(() {
                    isPagination = false;
                  });
                }
              }
              if (page == 1) {
                setDataToList(_arrList);
              } else {
                setMoreDataToList(_arrList);
              }
            } else {
              isApiCall = true;
            }
          });
          print("  LedgerLedger  $data ");
        }, onFailure: (error) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          print("Here2=> $e");

          setState(() {
            isLoaderShow = false;
          });
          var val = CommonWidget.errorDialog(context, e);

          print("YES");
          if (val == "yes") {
            print("Retry");
          }
        }, sessionExpire: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setDataToList(List<dynamic> _list) {
    if (Item_list.isNotEmpty) Item_list.clear();
    if (mounted) {
      setState(() {
        Item_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        Item_list.addAll(_list);
      });
    }
  }
}
