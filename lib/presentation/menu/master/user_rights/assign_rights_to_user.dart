import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/data/domain/user_rights/user_rigts_request_model.dart';
import 'package:sweet_shop_app/presentation/menu/master/user_rights/add_or_edit_user_rights.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class AssignRightsToUser extends StatefulWidget {
  final  AssignRightsToUserInterface mListener;
  final editedItem;
  final come;
  final uId;
  final readOnly;

  const AssignRightsToUser({super.key,required this.mListener, this.editedItem, this.come, this.uId, this.readOnly});

  @override
  State<AssignRightsToUser> createState() => _AssignRightsToUserState();
}

class _AssignRightsToUserState extends State<AssignRightsToUser>  with SingleTickerProviderStateMixin,AddOrEditUserScreenRightInterface{
  final ScrollController _scrollController = ScrollController();
  late AnimationController _Controller;
  bool disableColor = false;

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";


  List<dynamic> Item_list=[];


  List<dynamic> Deleted_list=[];
  List<dynamic> OldData=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  var companyId="0";
  bool isLoaderShow=false;
  final _formkey = GlobalKey<FormState>();
  var editedItemIndex=null;

  bool addAll=false;

  var copyFromFranchiseeName="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    setData();
    if(widget.editedItem!=null){
      getUserRights(1,widget.editedItem['UID']);
    }
  }
  setData()async{
    await getCompanyId();

    if(widget.come=="edit"){

      // await gerSaleInvoice(1);
      print("#######################3 ${widget.editedItem}");

      setState(() {
        selectedFranchiseeId=widget.editedItem['UID'].toString();
        selectedFranchiseeName=widget.editedItem['UID'];
      });
    }


  }

  getCompanyId()async{
    String companyId1 = await AppPreferences.getCompanyId();
    setState(() {
      companyId=companyId1;
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
                                ApplicationLocalizations.of(context)!.translate("user_right")!,
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
                widget.readOnly==false?Container():  Container(
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
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            getUserPermissions();
             if(selectedFranchiseeId==""){
              var snackBar=SnackBar(content: Text("Select Party Name !"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(Item_list.length==0){
              var snackBar=SnackBar(content: Text("Add atleast one Item!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if( selectedFranchiseeId!= " " && Item_list.length>0){
              if (mounted) {
                setState(() {
                  disableColor = true;
                });
              }

              if(widget.editedItem==null) {
                print("#######");
                callPostUser();
              }
              else {
                print("dfsdf");
                callPostUser();
              }
            }

          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.screenWidth*.90,
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

  Widget getAllFields(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight*0.6,
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .01 ),
            child: Container(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    InvoiceInfo(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.readOnly==false?Container():
                        GestureDetector(
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());

                               if(addAll==false) {
                                 setState(() {
                                   addAll = !addAll;
                                 });
                                 getAllForms();
                               }
                             },
                            child: Container(
                                width: SizeConfig.halfscreenWidth,
                                padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color:addAll? CommonColor.THEME_COLOR:Colors.transparent,
                                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ApplicationLocalizations.of(context)!.translate("add_all")!,
                                      style: item_heading_textStyle,),
                                    FaIcon(FontAwesomeIcons.plusCircle,
                                      color: Colors.black87, size: 20,)
                                  ],
                                )
                            )
                        ),
                        widget.readOnly==false?Container():
                        GestureDetector(
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              if(selectedFranchiseeId!="") {
                                if (context != null) {
                                  editedItemIndex=null;
                                  goToAddOrEditItem(null);
                                }
                              }
                              else{
                                CommonWidget.errorDialog(context, "Select User !");
                              }
                            },
                            child: Container(
                                width: SizeConfig.halfscreenWidth,
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
                                      ApplicationLocalizations.of(context)!.translate("add_screen")!,
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
      ),
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
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          widget.readOnly==false?Container():  getCopyFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          // SizedBox(width: 5,),
        ],
      ),
    );
  }

  Widget getCopyFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return  SearchableLedgerDropdown(
      apiUrl: ApiConstants().userList+"?",
      titleIndicator: true,
      ledgerName: copyFromFranchiseeName,
      franchisee: copyFromFranchiseeName,
      franchiseeName: copyFromFranchiseeName,
      title: "Copy Rights From ",
      callback: (name,id)async{
        if(copyFromFranchiseeName==""){
          setState(() {
            OldData=Item_list;
          });
        }
        if(name==""){
          setState(() {
            Item_list=OldData;
          });
          setState(() {
            copyFromFranchiseeName = name!;
          });
        }
        else {
          setState(() {
            Item_list=[];
            copyFromFranchiseeName = name!;
          });
          await getUserRights(1, copyFromFranchiseeName);

          print("############3");
          print(copyFromFranchiseeName + "\n" + copyFromFranchiseeName);
        }
      },

    );

  }

  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      apiUrl: ApiConstants().userList+"?",
      titleIndicator: true,
      ledgerName: selectedFranchiseeName,
      franchisee: widget.come,
      readOnly: false,
      come:"disable",
      franchiseeName: widget.come=="edit"? widget.editedItem['UID']:"",
      title: ApplicationLocalizations.of(context)!.translate("user")!,
      callback: (name,id){

          setState(() {
            selectedFranchiseeName = name!;
            selectedFranchiseeId = name;
          });

        print("############3");
        print(selectedFranchiseeId+"\n"+selectedFranchiseeName);
      },

    );

  }

  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: Item_list.length,
        padding: EdgeInsets.only(bottom: 500),
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
                    if(widget.readOnly==true){
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
                                          Text("${Item_list[index]['Form']}",style: item_heading_textStyle,),

                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                    children: [
                                                      Item_list[index]['Insert_Right']==true?Text("Insert ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),):Container(),
                                                      Item_list[index]['Update_Right']==true &&  Item_list[index]['Insert_Right']==true ?Text(", ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),):Container(),
                                                      Item_list[index]['Update_Right']==true?Text("Update",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),):Container(),
                                                      Item_list[index]['Delete_Right']==true && (   Item_list[index]['Insert_Right']==true ||Item_list[index]['Update_Right']==true )?Text(", ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),):Container(),
                                                      Item_list[index]['Delete_Right']==true?Text("Delete",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),):Container(),
                                                    ],
                                                  )),
                                            ],
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
                                      child:DeleteDialogLayout(
                                          callback: (response ) async{
                                            if(response=="yes"){

                                              // print(Item_list);
                                              // print(Deleted_list);
                                              // var contain = Deleted_list.indexWhere((element) => element['Form_ID']== Item_list[index]['Form_ID']);
                                              // print("##############$response");
                                              // print(contain);
                                              // if(contain>=1){
                                              //   callDeleteUser(Item_list[index]['Form_ID'],index);
                                              // }
                                              // else{

                                                setState(() {
                                                  Item_list.remove(Item_list[index]);
                                                });
                                              // }
                                            }
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
              Text("Add Screen",
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
              child: AddOrEditUserRights(
                mListener: this,
                editproduct:product,
                id: selectedFranchiseeId,
                exstingList:Item_list,
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

  @override
  AddOrEditUserScreenRightDetail(item) {
    // TODO: implement AddOrEditUserScreenRightDetail
    var itemLlist=Item_list;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['Form_ID']=item['Form_ID'];
        Item_list[index]['Form']=item['Form'];
        Item_list[index]['Insert_Right']=item['Insert_Right'];
        Item_list[index]['Update_Right']=item['Update_Right'];
        Item_list[index]['Delete_Right']=item['Delete_Right'];
      });

        // var contain = Item_list.indexWhere((element) => element['Form_ID']== item['Form_ID']);
        // print(contain);
        // if(contain>=0){
        //   print("REMOVE");
        //   Item_list.remove(Item_list[contain]);
        //   Item_list.add(item);
        // }else{
        //   Item_list.add(item);
        // }
        setState(() {
          Item_list = Item_list;
          print("hvhfvbfbv   $Item_list");
        });

    }
    else
    {
      itemLlist.add(item);
      // Inserted_list.add(item);
      // setState(() {
      //   Inserted_list=Inserted_list;
      // });
      // print(itemLlist);

      setState(() {
        Item_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex=null;
    });
    print("List");
    print(Item_list);


  }
  
  getUserRights(int page,UID) async {
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
        String apiUrl = "${baseurl}${ApiConstants().userPermission}?Company_ID=$companyId&UID=${UID}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList =data;

                  setState(() {
                    Item_list=data;
                  });
                  for(var ele in data){
                    setState(() {
                      Deleted_list.add(ele);
                    });
                  }
                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  userLisstttttttt  $data ");
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

  callPostUser() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        UserRightsModel model = UserRightsModel(
          UID:selectedFranchiseeId ,
          companyID: companyId ,
          creater: creatorName,
          createrMachine: deviceId,
          iNSERT: Item_list.toList(),
        );

        String apiUrl =baseurl + ApiConstants().userPermission;
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              print("  userPermissionnnn  $data ");
              setState(() {
                isLoaderShow=true;
                Item_list=[];
                Deleted_list=[];
              });
              widget.mListener.backToUserList();

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

  getAllForms() async {
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
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().formList}?Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  print("################# ${data.length}");
                  for (var ele in data) {
                    print("Available###############3");
                    var i=Deleted_list.indexWhere((element) => element['Form_ID']==ele['Form_ID']);
                    if(i<0) {
                      _arrList.add({
                        "Form_ID": ele['Form_ID'],
                        "Form": ele['Form'],
                        "Insert_Right": true,
                        "Update_Right": true,
                        "Delete_Right": true,
                        "Seq_No": null
                      });
                    }
                    else{
                      _arrList.add(Deleted_list[i]);
                    }

                  }
                  setState(() {
                    Item_list=_arrList;
                  });

                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  userLisstttttttt  $data ");
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

  callDeleteUser(String removeId,int index) async {
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
          "Form_ID": removeId,
          "UID": selectedFranchiseeId,
          "Modifier": uid,
          "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().userPermission+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data)async{
              setState(() {
                isLoaderShow=false;
                Item_list.removeAt(index);
                var i=Deleted_list.indexWhere((element) => element['Form_ID']==removeId);
                Deleted_list.removeAt(i);
              });
              print(" ######## LedgerLedger  $Item_list \n $Deleted_list ");
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


  getUserPermissions() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    String uid=await AppPreferences.getUId();
    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    print("objectgggg   $date  ");
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getUserPermission}?UID=$uid&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                if(data!=null){
                  if (mounted) {
                    AppPreferences.setMasterMenuList(jsonEncode(data['MasterSub_ModuleList']));
                    AppPreferences.setTransactionMenuList(jsonEncode(data['TransactionSub_ModuleList']));
                    // AppPreferences.setReportMenuList(jsonEncode(apiResponse.reportMenu));
                  }

                }else{
                }
              });
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }

}

abstract class AssignRightsToUserInterface {
  backToUserList();
}
