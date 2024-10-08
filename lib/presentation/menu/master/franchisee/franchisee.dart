import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee/franchisee_create_activity.dart';
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


class AddFranchiseeActivity extends StatefulWidget {
  final  formId;
  final  arrData;
  final String logoImage;
  const AddFranchiseeActivity({super.key, required mListener, this.formId, this.arrData, required this.logoImage});

  @override
  State<AddFranchiseeActivity> createState() => _AddFranchiseeActivityState();
}

class _AddFranchiseeActivityState extends State<AddFranchiseeActivity> {

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
        callGetFranchisee(page);
      }
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetFranchisee(page);
    setVal();
  }

  List<dynamic> franchiseeList = [];
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    print("Here");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetFranchisee(page);

  }

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
/* Widget to get sale ledger Name Layout */
  Widget getFranchiseeSearchLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():
    SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().getFilteredFranchisee}?",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context).translate("franchisee"),
        franchiseeName: selectedFranchiseeName!=""? selectedFranchiseeName:"",
        franchisee:selectedFranchiseeName,
        callback: (name,id)async{
          setState(() {
            selectedFranchiseeName = name!;
            selectedFranchiseeId = id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedFranchiseeId);
          var item={
            "Name":name,
            "ID":id
          };
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateFranchisee(
              editItem: item,   logoImage: widget.logoImage,
              readOnly:singleRecord['Update_Right']
          )));
          setState(() {
            page=1;
          });
          await     callGetFranchisee(page);

          // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
          //   mListener: this,
          //   ledgerList: item,
          //   readOnly:singleRecord['Update_Right'],
          // )));
          // await callGetLedger(0);
        },
        ledgerName: selectedFranchiseeName);
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
                                ApplicationLocalizations.of(context).translate("franchisee"),
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
                await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFranchisee(
                  logoImage: widget.logoImage,
                )));
                setState(() {
                  page=1;
                });
                await callGetFranchisee(page);
              }):Container(),
          body:Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFranchiseeSearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                    const SizedBox(
                      height: 10,
                    ),
                    get_franchisee_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: franchiseeList.isEmpty && isApiCall  ? true : false,
                  child:CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth, ApplicationLocalizations.of(context).translate("no_data"))),
            ],
          )
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
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
            itemCount: franchiseeList.length,
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
                                  CreateFranchisee(editItem: franchiseeList[index],
                                  readOnly: singleRecord['Update_Right'],
                                    logoImage: widget.logoImage,
                                  )));
                          setState(() {
                            page = 1;
                          });
                          callGetFranchisee(page);

                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: (index)%2==0?Colors.green:Colors.blueAccent,
                                child:  FaIcon(
                                  FontAwesomeIcons.user,
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
                                            Text(franchiseeList[index]['Name'],style: item_heading_textStyle,),
                                            SizedBox(height: 5,),
                                            franchiseeList[index]['Contact_No']!=null? Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(FontAwesomeIcons.phone,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(child: Text(franchiseeList[index]['Contact_No'],overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ],
                                            ):Container(),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                FaIcon(FontAwesomeIcons.locationDot,size: 15,color: Colors.black.withOpacity(0.7),),
                                                SizedBox(width: 10,),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        franchiseeList[index]['Address']!=null?TextSpan(text:"${franchiseeList[index]['Address']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['District']!=null?TextSpan(text:"${franchiseeList[index]['District']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['State']!=null?TextSpan(text:"${franchiseeList[index]['State']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                                        franchiseeList[index]['Pin_Code']!=null?TextSpan(text:"- ${franchiseeList[index]['Pin_Code']} ",style: item_regular_textStyle,):TextSpan(text: 'Hello '),
                                       
                                                      ],
                                                    ),
                                                  ),
                                                )
                                       
                                              ],
                                            ),
                                       
                                          ],
                                        ),
                                                                           ),
                                     ),
                                    singleRecord['Delete_Right']==true?  DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await  callDeleteFranchisee(franchiseeList[index]['ID'].toString(),index);
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


  callGetFranchisee(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getFilteredFranchisee}?Company_ID=$companyId&${StringEn.lang}=$lang&PageNumber=$page&${StringEn.pageSize}";
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
    if (franchiseeList.isNotEmpty) franchiseeList.clear();
    if (mounted) {
      setState(() {
        franchiseeList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        franchiseeList.addAll(_list);
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
                franchiseeList.removeAt(index);
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
}
