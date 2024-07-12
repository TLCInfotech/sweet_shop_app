import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';
import 'create_sell_activity.dart';

class SellActivity extends StatefulWidget {
final String? comeFor;
final DateTime? dateNew;
final franhiseeID;
final  formId;
final  arrData;
final String logoImage;
final franchiseeName;
  const SellActivity({super.key, required mListener,  this.comeFor,   this.dateNew, this.franhiseeID, this.formId, this.arrData, this.franchiseeName, required this.logoImage});

  @override
  State<SellActivity> createState() => _SellActivityState();
}

class _SellActivityState extends State<SellActivity>with CreateSellInvoiceInterface {
  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> saleInvoice_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;
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
    _scrollController.addListener(_scrollListener);
    if(widget.dateNew!=null){
      setState(() {
        invoiceDate=widget.dateNew!;
      });
    }

    if(widget.franhiseeID!=null){
      setState(() {
        selectedFranchiseeId=widget.franhiseeID.toString();
        selectedFranchiseeName=widget.franchiseeName;
      });
    }
    gerSaleInvoice(page);
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
    print("@@@@@@@@@@@@@@@@@@@@@@@@@2 ${widget.franchiseeName}");

    print(partyBlank);
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        gerSaleInvoice(page);
      }
    }
  }
  setDataToList(List<dynamic> _list) {
    if (saleInvoice_list.isNotEmpty) saleInvoice_list.clear();
    if (mounted) {
      setState(() {
        saleInvoice_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        saleInvoice_list.addAll(_list);
      });
    }
  }
  bool partyBlank=true;
  //FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await gerSaleInvoice(page);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
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
                              widget.comeFor=="dash"?Container():GestureDetector(
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
                                child: Center(
                                  child: Text(
                                    ApplicationLocalizations.of(context)!.translate("sale_invoice")!,
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
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getPurchaseDateLayout(),
                        const SizedBox(
                          height: 2,
                        ),
                        getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                        const SizedBox(
                          height: 10,
                        ),
                       saleInvoice_list.isNotEmpty? getTotalCountAndAmount():
                        Container(),
                        const SizedBox(
                          height: .5,
                        ),
                        get_purchase_list_layout()
                      ],
                    ),
                  ),
                  Visibility(
                      visible: saleInvoice_list.isEmpty && isApiCall  ? true : false,
                      child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                ],
              ),
            ),
            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        ),
        singleRecord['Insert_Right']==true ? Positioned(
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
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      CreateSellInvoice(
                        logoImage: widget.logoImage,
                        dateNew:   invoiceDate,
                        Invoice_No: null,//DateFormat('dd-MM-yyyy').format(newDate),
                        mListener:this,
                      )));
                  selectedFranchiseeId="";
                  partyBlank=false;
                  saleInvoice_list=[];
                  await  gerSaleInvoice(1);

                }),
          ),
        ):Container(),
      ],
    );
  }
  /*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "No data available.",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 4.2,
            fontFamily: 'Inter_Medium_Font',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget getTotalCountAndAmount() {
    return Container(
      margin: EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          // width: SizeConfig.halfscreenWidth,
          width: SizeConfig.screenWidth*0.9,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${saleInvoice_list.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!} ", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }
  String TotalAmount="0.00";
  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in saleInvoice_list ){
      total=total+item['Total_Amount'];
      print(item['Total_Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            saleInvoice_list.clear();
          });
          setState(() {
            invoiceDate=date!;
          });
          gerSaleInvoice(1);
        },
        applicablefrom: invoiceDate
    );
  }

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return partyBlank==false?Container():SearchableLedgerDropdown(
      apiUrl: ApiConstants().ledgerWithoutImage+"?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      franchisee: "edit",
      franchiseeName: selectedFranchiseeName,
      readOnly: singleRecord['Update_Right']||singleRecord['Insert_Right'],
       title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (name,id){
          setState(() {
            selectedFranchiseeName = name!;
            selectedFranchiseeId = id.toString()!;
            saleInvoice_list=[];
            gerSaleInvoice(1);
          });

        print("############3");
        print(selectedFranchiseeId+"\n"+selectedFranchiseeName);
      },

    );

  }

  Expanded get_purchase_list_layout() {
    return Expanded(
        child:RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: saleInvoice_list.length,
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
                      onTap: () async{

                       await   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            CreateSellInvoice(
                              logoImage: widget.logoImage,
                              dateNew: invoiceDate,
                              Invoice_No: saleInvoice_list[index]['Invoice_No'],//DateFormat('dd-MM-yyyy').format(newDate),
                              mListener:this,
                              readOnly:singleRecord['Update_Right'] ,
                              editedItem:saleInvoice_list[index],
                              come:"edit",
                            )));
                       selectedFranchiseeId="";
                       partyBlank=false;
                       saleInvoice_list=[];
                       await  gerSaleInvoice(1);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: (index)%2==0?Colors.green:Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child:  const FaIcon(
                                    FontAwesomeIcons.moneyCheck,
                                    color: Colors.white,
                                  )
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
                                            Text("${saleInvoice_list[index]['Vendor_Name']}",style: item_heading_textStyle,),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(child: Text("Invoice No. - ${saleInvoice_list[index]['Fin_Invoice_No']}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(child: Text(CommonWidget.getCurrencyFormat(saleInvoice_list[index]['Total_Amount']),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ],
                                            ),],
                                        ),
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?      DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await   callDeleteSaleInvoice(saleInvoice_list[index]['Invoice_No'].toString(),saleInvoice_list[index]['Seq_No'].toString(),index);
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
        String apiUrl;

          apiUrl = "${baseurl}${ApiConstants().getSaleInvoice}?Company_ID=$companyId&Franchisee_ID=$selectedFranchiseeId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&PageNumber=$page&${StringEn.pageSize}";

        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                isLoaderShow=false;
                partyBlank=true;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList.clear();
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

                  calculateTotalAmt();
                }else{
                  isApiCall=true;
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

  callDeleteSaleInvoice(String removeId,String seqNo,int index) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Invoice_No": removeId,
          "Modifier": uid,
          "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().getSaleInvoice+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                saleInvoice_list.removeAt(index);
              });
              if(saleInvoice_list.length==0){
                setState(() {
                  TotalAmount="0.00";
                });
              }
              calculateTotalAmt();
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

    setState(() {
      saleInvoice_list.clear();
      invoiceDate=updateDate;
    });
    gerSaleInvoice(1);
    Navigator.pop(context);
  }
}
