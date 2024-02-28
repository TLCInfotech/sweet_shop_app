
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/delete_request_model.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/ledgerGroup/post_ledger_group_request_model.dart';
import '../../../../data/domain/ledgerGroup/put_ledger_group_request_model.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dialog/parent_ledger_group_dialoug.dart';


class ExpenseGroup extends StatefulWidget {
  const ExpenseGroup({super.key});

  @override
  State<ExpenseGroup> createState() => _ExpenseGroupState();
}

class _ExpenseGroupState extends State<ExpenseGroup> with LedegerGroupDialogInterface{
  TextEditingController groupName = TextEditingController();
  TextEditingController sequenseNoName = TextEditingController();
  TextEditingController sequenseNatureName = TextEditingController();
  final _groupNameFocus = FocusNode();
  final _sequenseNoFocus = FocusNode();
  final _sequenceNatureFocus = FocusNode();
  String parentCategory="";
  int parentCategoryId=0;
  String ParentGroupid="";
  bool isApiCall = false;
  late InternetConnectionStatus internetStatus;
/*  List<dynamic> expense_group=[
  {
  "ID" : "13",
  "Name" : "Employee",
  "Parent_ID" : "34",
  "Seq_No" : "36",
  "Group_Nature" : "A"
}
  ];*/

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoaderShow=false;

  var editedItem=null;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetLedgerGroup(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetLedgerGroup(page);
  }

  List<dynamic> expense_group = [];


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFfffff5),
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
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                child: AppBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  backgroundColor: Colors.white,
                  title: Center(
                    child: Text(
                      ApplicationLocalizations.of(context)!.translate("ledger_group")!,
                      style: appbar_text_style,),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                add_category_layout(context);

              }),
          body: Container(
            margin: const EdgeInsets.all(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: .5,
                    ),
                    get_expense_group_list_layout()

                  ],
                ),
                Visibility(
                    visible: expense_group.isEmpty && isApiCall  ? true : false,
                    child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
              ],
            ),
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
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


  Expanded get_expense_group_list_layout() {
    return Expanded(
        child: ListView.separated(
          itemCount: expense_group.length,
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

                      print(expense_group[index]);
                      setState(() {
                        editedItem=expense_group[index];
                        groupName.text=expense_group[index]['Name'];
                        parentCategory=expense_group[index]['Parent_Name']==null?"":expense_group[index]['Parent_Name'];
                        parentCategoryId=expense_group[index]['Parent_ID']==null?0:expense_group[index]['Parent_ID'];
                        sequenseNoName.text=expense_group[index]['Seq_No'].toString();
                        sequenseNatureName.text=expense_group[index]['Group_Nature'].toString();
                        print("ggfhfghgfhvg  $parentCategory");
                      });
                      add_category_layout(context);
                    },
                    onDoubleTap: (){},
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width:80,
                            height: 70,
                            decoration:  BoxDecoration(
                                color: index %2==0?const Color(0xFFEC9A32):const Color(0xFF7BA33C),
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            alignment: Alignment.center,
                            child: const FaIcon(FontAwesomeIcons.peopleGroup,color: Colors.white,),
                          ),
                          Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${expense_group[index]['Name']}",style: item_heading_textStyle,),
                                        Text("${expense_group[index]['Parent_ID']}- ${expense_group[index]['Seq_No']}",style: item_regular_textStyle,),
                                        Text("${expense_group[index]['Group_Nature']}",style: item_regular_textStyle,),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child:IconButton(
                                        icon:  const FaIcon(
                                          FontAwesomeIcons.trash,
                                          size: 18,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: (){
                                          callDeleteLedgerGroup(expense_group[index]['ID'].toString(),index);
                                        },
                                      ) )
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
            return const SizedBox(
              height: 5,
            );
          },
        ));
  }

  Future<dynamic> add_category_layout(BuildContext context) {
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
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
                      child: Container(
                        height: SizeConfig.screenHeight*0.6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFfffff5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: SizeConfig.screenHeight*.03,
                              child: Center(
                                child: Text(
                                    ApplicationLocalizations.of(context)!.translate("add_ledger_group")!,
                                    style: page_heading_textStyle
                                ),
                              ),
                            ),
                            getGroupNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                            getParentGroupLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                            // getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("sequence_no")!),
                            getSequenceNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                            // getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("sequence_nature")!),
                            getSequenceNatureLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                            const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                    getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  ],
                ),
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

  /* widget for Category layout */
  Widget getGroupNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("group_name")!;
        }
        return null;
      },
      controller: groupName,
      focuscontroller: _groupNameFocus,
      focusnext: _sequenseNoFocus,
      title: ApplicationLocalizations.of(context)!.translate("group_name")!,
      callbackOnchage: (value) {
        setState(() {
          groupName.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }
  /* widget for Category layout */
  Widget getSequenceNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("sequence_no")!;
        }
        return null;
      },
      controller: sequenseNoName,
      focuscontroller: _sequenseNoFocus,
      focusnext: _sequenceNatureFocus,
      title: ApplicationLocalizations.of(context)!.translate("sequence_no")!,
      callbackOnchage: (value) {
        setState(() {
          sequenseNoName.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

  }
  /* widget for Category layout */
  Widget getSequenceNatureLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("sequence_nature")!;
        }
        return null;
      },
      controller: sequenseNatureName,
      focuscontroller: _sequenceNatureFocus,
      focusnext: _sequenceNatureFocus,
      title: ApplicationLocalizations.of(context)!.translate("sequence_nature")!,
      callbackOnchage: (value) {
        setState(() {
          sequenseNatureName.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      maxlength: 2,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }

  PostData()async{
  var data=  {
    "Name" : groupName.text,
    "Parent_ID" : ParentGroupid,
    "Seq_No" : sequenseNoName.text,
    "Group_Nature" :sequenseNatureName.text,
    "Creator" : "System",
    "Creator_Machine": "TLC1"
    } ;
    expense_group.add(data);
    setState(() {
      expense_group=expense_group;
    });
    print(expense_group);

  }

  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            onDoubleTap: () {},
            child: Container(
              height:parentHeight*.05,
              width: parentWidth*.45,
              // width: SizeConfig.blockSizeVertical * 20.0,
              decoration: const BoxDecoration(
                color: CommonColor.HINT_TEXT,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ApplicationLocalizations.of(context)!.translate("close")!,
                    textAlign: TextAlign.center,
                    style: text_field_textStyle,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if(editedItem!=null){
                print("jgbgbgbggn");
                callUpdateLadgerGroup();
              }else{
                callPostLedgerGroup();
              }
              //Navigator.pop(context);
            },
            onDoubleTap: () {},
        /*    onTap: () {

              PostData();
              Navigator.pop(context);

            },
            onDoubleTap: () {},*/
            child: Container(
              height: parentHeight * .05,
              width: parentWidth*.45,
              decoration: const BoxDecoration(
                color: CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                ),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    editedItem!=null?ApplicationLocalizations.of(context)!.translate("update")!:
                    ApplicationLocalizations.of(context)!.translate("save")!,
                    textAlign: TextAlign.center,
                    style: text_field_textStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget For Category Layout */
  Widget getParentGroupLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("select_category")!,
            style: item_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child: Container(
              height: (SizeConfig.screenHeight) * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child:  GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (context != null) {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                              1.0;
                          return Transform(
                            transform:
                            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: a1.value,
                              child: LedegerGroupDialog(
                                mListener: this,
                                expense_group: expense_group,
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
                },
                child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10, right: 10),
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
                        Text(parentCategory==""?ApplicationLocalizations.of(context)!.translate("select_category")!:parentCategory,
                          style:parentCategory=="" ? item_regular_textStyle:text_field_textStyle,),
                        FaIcon(FontAwesomeIcons.caretDown,
                          color: Colors.black87.withOpacity(0.8), size: 16,)
                      ],
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );

  }



  callGetLedgerGroup(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();


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
        String apiUrl = "${ApiConstants().baseUrl}${ApiConstants().ledger_group}?pageNumber=$page&pageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isApiCall=true;
                isLoaderShow=false;
                List<dynamic> _arrList = [];
                _arrList=data;
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
              });

              // expense_group.addAll(data.map((arrData) =>
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

  setDataToList(List<dynamic> _list) {
    if (expense_group.isNotEmpty) expense_group.clear();
    if (mounted) {
      setState(() {
        expense_group.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        expense_group.addAll(_list);
      });
    }
  }

  callDeleteLedgerGroup(String removeId,int index) async {
    String uid = await AppPreferences.getUId();

    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      DeleteIRequestModel model = DeleteIRequestModel(
          id:removeId,
          modifier: uid,
          modifierMachine: deviceId
      );
      String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger_group;
      apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            setState(() {
              isLoaderShow=false;
              expense_group.removeAt(index);
            });
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
  }
  callPostLedgerGroup() async {
    String seqNoText = sequenseNoName.text.trim();
    String groupNameText = groupName.text.trim();
    String seqNatureText = sequenseNatureName.text.trim();
    String creatorName = await AppPreferences.getUId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostLedgerGroupRequestModel model = PostLedgerGroupRequestModel(
          name: groupNameText,
        seqNo:seqNoText ,
        parentId:parentCategoryId.toString() ,
        groupNature: seqNatureText,
        creator: creatorName,
        creatorMachine: deviceId,
      );

      //  widget.mListener.loaderShow(true);
      String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger_group;
      apiRequestHelper.callAPIsForPostMsgAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            setState(() {
              isLoaderShow=false;
              callGetLedgerGroup(page);
            });
            Navigator.pop(context);

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
  }

  @override
  selectCategory(int id, String name) {
    // TODO: implement selectCategory
  setState(() {
    parentCategory=name;
    parentCategoryId=id;
  });
  }

  callUpdateLadgerGroup() async {
    String seqNoText = sequenseNoName.text.trim();
    String groupNameText = groupName.text.trim();
    String seqNatureText = sequenseNatureName.text.trim();
    String creatorName = await AppPreferences.getUId();
    AppPreferences.getDeviceId().then((deviceId) {

      PutLedgerGroupRequestModel model = PutLedgerGroupRequestModel(
         name:groupNameText ,
        seqNo:seqNoText ,
        parentId:parentCategoryId.toString() ,
        groupNature:seqNatureText ,
        Modifier: creatorName,
        creatorMachine: deviceId
      );
    /*  if(editedItem['Parent_ID']!=parentCategoryId && parentCategoryId!=0){
        model.parentId=parentCategoryId.toString();
        // seqNo: seqNoText,
      }
      if(editedItem['Seq_No']!= int.parse(seqNo)){
        model.seqNo=seqNo.toString();
      }*/

      print("MODAL");
      print(model.toJson());

      //  widget.mListener.loaderShow(true);
      String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger_group+"/"+editedItem['ID'].toString();

      print(apiUrl);
      apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
          onSuccess:(value)async{
            print("  Put Call :   $value ");

            setState(() {
              editedItem=null;
              groupName.clear();
              parentCategory="";
              parentCategoryId=0;
              sequenseNoName.clear();
              sequenseNatureName.clear();
            });
            var snackBar = SnackBar(content: Text('Item Category Updated Successfully'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            setState(() {
              page=1;
            });

            await  callGetLedgerGroup(page);
            Navigator.pop(context);

          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error.toString());
            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            // widget.mListener.loaderShow(false);
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });
    });
  }

}
