import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee/franchisee_create_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/sale_invoice_addiction/create_sale_invoice_addition.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/searchable_dropdown_with_object.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/delete_request_model.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';


class SaleInvoiceAdditionListActivity extends StatefulWidget {
  final  formId;
  final  arrData;
  final String logoImage;
  const SaleInvoiceAdditionListActivity({super.key, required mListener, this.formId, this.arrData, required this.logoImage});

  @override
  State<SaleInvoiceAdditionListActivity> createState() => _SaleInvoiceAdditionListActivityState();
}

class _SaleInvoiceAdditionListActivityState extends State<SaleInvoiceAdditionListActivity>with CrateSaleOrderInterface{

  bool isLoaderShow=false;
  bool isApiCall = false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();
  var  singleRecord;
  setVal()async{
    print(widget.arrData);
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }
  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getInvoiceAddition(page);
      }
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    getInvoiceAddition(page);
    setVal();
  }

  List<dynamic> InvoiceAddList = [];
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    print("Here");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await getInvoiceAddition(page);

  }

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
/* Widget to get sale ledger Name Layout */
  Widget getFranchiseeSearchLayout(double parentHeight, double parentWidth) {
    return SearchableDropdownWithObject(
      mandatory: true,
      name: selectedFranchiseeName,
      status:  "edit",
      apiUrl:"${ApiConstants().ledger_list}?",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (item)async{

        // List l=widget.exstingList;
        // List n= await l.map((i) => i['Expense_ID'].toString()).toList();
        // print("FFFFFFFFFFFF ${n.contains(item['ID'].toString())}");
        // if(n.contains(item['ID'].toString())){
        //   CommonWidget.errorDialog(context, "Already Exist!");
        // }
        // else {
        setState(() {
          selectedFranchiseeId = item['ID'].toString();
          selectedFranchiseeName = item['Name'].toString();
          page=1;
          isPagination=true;
        });
        InvoiceAddList.clear();
        getInvoiceAddition(page);


      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
            backgroundColor: Color(0xFFfffff5),
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
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
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
                            child:Center(
                              child: Text(
                                ApplicationLocalizations.of(context).translate("sale_invoice_addition"),
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
            floatingActionButton:singleRecord['Insert_Right']==true? FloatingActionButton(
                backgroundColor: Color(0xFFFBE404),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ),
                onPressed: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => CrateSaleOrder(
                    itemName: "",   logoImage: widget.logoImage, dateNew: DateTime.now(), mListener: this, order_No: null,
                    readOnly:true,title: ApplicationLocalizations.of(context).translate("sale_invoice_addition"), setText: ApplicationLocalizations.of(context).translate("sale_invoice_addition"),
                  )));
                  setState(() {
                    page=1;
                  });
                  await getInvoiceAddition(page);
                }):Container(),
            body:Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: getFromDate()),
                          Container(alignment: Alignment.center,width: 40,child: Text("To",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontWeight: FontWeight.w600),),),
                          Expanded(child: geToDate())
                        ],
                      ),
                      getFranchiseeSearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                      getPartyNameLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                      const SizedBox(
                        height: 10,
                      ),
                      get_franchisee_list_layout()
                    ],
                  ),
                ),
                Visibility(
                    visible: InvoiceAddList.isEmpty && isApiCall  ? true : false,
                    child:CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth, ApplicationLocalizations.of(context).translate("no_data"))),
              ],
            )
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  String selectedItemName = "";
  String selectedItemId = "";
  /* Widget to get Franchisee Name Layout */
  Widget getPartyNameLayout(double parentHeight, double parentWidth) {
    return  SearchableLedgerDropdown(
      apiUrl:
      "${ApiConstants().item_list}?Date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&",
      titleIndicator: false,
      ledgerName: "",
      franchisee: "edit",
      franchiseeName:"",
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("item")!,
      callback: (name, id) {
        setState(() {
          selectedItemName = name!;
          selectedItemId = id.toString()!;
          page=1;
          isPagination=true;
        });
        InvoiceAddList.clear();
        getInvoiceAddition(page);
        // array_list = [];
        // getReportList(1);
      },
    );  /* return CommonDropdown(
      mandatory: true,
      apiUrl: ApiConstants().ledger+"?Group_ID=null&",
      nameField:"Name",
      idField:"ID",
      titleIndicator: true,
      ledgerName: selectedVendorName,
      franchiseeName:  selectedVendorName,
      franchisee: selectedVendorName!=null?"edit":"",
      readOnly:widget.editedItem!=null?false: true,
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (item)async {
        print(item);
        setState(() {
          showButton = true;
          selectedVendorName = item['Name']!;
          selectedVendorId = item['ID'].toString();
          partyState=item['State'];
          partygst=item['GST_No'];
          position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
        });
        print("kghj  $company_details");
        if(company_details!=null){
          visibility=company_details[0]['State']==partyState?true:false;
        }else{
          visibility=false;
        }
        // company_details!=[]?
        // company_details[0]['State']==partyState?true:false:false,
        // cAndsgstApplicable:company_details!=[]?
        // company_details[0]['State']==partyState?true:false:false,
        await getRoutebyPartId();

        print("############3");
        print(selectedVendorId + "\n" + selectedVendorName);

      },
    );
*/

  }
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  /* Widget to get add Invoice date Layout */
  Widget getFromDate(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            from=date!;
            page=1;
            isPagination=true;
          });
          getInvoiceAddition(page);
        },
        applicablefrom: from
    );
  }

  Widget geToDate(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {

            to=date!;
            page=1;
            isPagination=true;
          });
          getInvoiceAddition(page);
        },
        applicablefrom: to
    );
  }


  Expanded get_franchisee_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () => refreshList(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: InvoiceAddList.length,
            controller: _scrollController,
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
                      onTap: ()async{

                        await Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                CrateSaleOrder(
come: "edit",
                                  oldUnit:InvoiceAddList[index]['Unit']!=null?InvoiceAddList[index]['Unit'].toString():"" ,
                                  itemName: InvoiceAddList[index]['Item_Name'].toString(),
                                  readOnly:true,
                                  order_No:InvoiceAddList[index]['Item_ID'].toString() ,
                                  logoImage: widget.logoImage, dateNew: DateTime.parse(InvoiceAddList[index]['Applicable_From']), mListener: this,  title: ApplicationLocalizations.of(context).translate("sale_invoice_addition"), setText: ApplicationLocalizations.of(context).translate("sale_invoice_addition"),
                                )));
                        setState(() {
                          page = 1;
                        });
                        getInvoiceAddition(page);

                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:CommonColor.THEME_COLOR,
                                  child: Text("${index+1}")
                                // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
                              ),
                            ),
                            Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(InvoiceAddList[index]['Item_Name'],style: item_heading_textStyle,),
                                            SizedBox(height: 5,),
                                            InvoiceAddList[index]['Applicable_From']!=null?
                                            Text("Date: ${DateFormat('dd-MM-yy').format(DateTime.parse(InvoiceAddList[index]['Applicable_From']))}",overflow: TextOverflow.clip,style: item_heading_textStyle,):Container(),
                                            SizedBox(height: 5,),

                                          ],
                                        ),
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?  DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await  callDeleteFranchisee(InvoiceAddList[index]['ID'].toString(),index);
                                        }
                                      },
                                    ):Container()
                                  ],
                                )

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
        ));
  }


  getInvoiceAddition(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().saleInvoiceAddition}?Company_ID=$companyId&From_Date=${DateFormat('yyyy-MM-dd').format(from)}&Item_ID=$selectedItemId&Ledger_ID=$selectedFranchiseeId&To_Date=${DateFormat('yyyy-MM-dd').format(to)}&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  if (_arrList.length < 50) {
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
                }else{
                  isApiCall=true;
                  InvoiceAddList.clear();
                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
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

  setDataToList(List<dynamic> _list) {
    if (InvoiceAddList.isNotEmpty) InvoiceAddList.clear();
    if (mounted) {
      setState(() {
        InvoiceAddList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        InvoiceAddList.addAll(_list);
      });
    }
  }

  callDeleteFranchisee(String removeId,int index) async {
    String uid = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        DeleteIRequestModel model = DeleteIRequestModel(
            id:removeId,
            modifier: uid,
            modifierMachine: deviceId,
            companyId: companyId
        );
        String apiUrl = baseurl + ApiConstants().franchisee+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                InvoiceAddList.removeAt(index);
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

            }, onException: (e) {
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

      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }

  @override
  backToList(DateTime updateDate) {
    // TODO: implement backToList
 Navigator.pop(context);
  }
}
