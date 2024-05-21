
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/group_nature_dialog.dart';
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
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dialog/parent_ledger_group_dialoug.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_obj_for_tax.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';


class ExpenseGroup extends StatefulWidget {
  final  formId;
  final  arrData;
  const ExpenseGroup({super.key, this.formId, this.arrData});

  @override
  State<ExpenseGroup> createState() => _ExpenseGroupState();
}

class _ExpenseGroupState extends State<ExpenseGroup> with LedegerGroupDialogInterface,GroupNatureDialogInterface{
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
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoaderShow=false;

  var editedItem=null;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  List group_nature= ['Asset','Liability','Income','Expense'];

  var selectedgroup=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetLedgerGroup(page);
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetLedgerGroup(page);
      }
    }
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
                                ApplicationLocalizations.of(context)!.translate("ledger_group")!,
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
          floatingActionButton: singleRecord['Insert_Right']==true ?FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  groupName.clear();
                  parentCategory="";
                  parentCategoryId=0;
                  sequenseNoName.clear();
                  sequenseNatureName.clear();
                  editedItem=null;
                  print("kvnnnvg  $editedItem");
                });

                add_category_layout(context);
              }):Container(),
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

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetLedgerGroup(page);

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
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: expense_group.length,
            controller: _scrollController,
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
                          print("ggfhfghgfhvg  $parentCategory");
                        });
                        // selectedgroup=expense_group[index]['Group_Nature'].toString();
                        if(expense_group[index]['Group_Nature'].toString()=="A"){
                          setState(() {
                            selectedgroup="Asset";
                          });
                        }

                        else if(expense_group[index]['Group_Nature'].toString()=="L"){
                          setState(() {
                            selectedgroup="Liability";
                          });
                        }
                        else if(expense_group[index]['Group_Nature'].toString()=="I"){
                          setState(() {
                            selectedgroup="Income";
                          });
                        }
                        else if(expense_group[index]['Group_Nature'].toString()=="E"){
                          setState(() {
                            selectedgroup="Expense";
                          });
                        }

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
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${expense_group[index]['Name']}",style: item_heading_textStyle,),
                                            expense_group[index]['Parent_Name']!=null?Text("${expense_group[index]['Parent_Name']}",style: item_regular_textStyle,):Container(),
                                            Text("${expense_group[index]['Group_Nature']}",style: item_regular_textStyle,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?DeleteDialogLayout(
                                      callback: (response ) async{
                                        if(response=="yes"){
                                          print("##############$response");
                                          await   callDeleteLedgerGroup(expense_group[index]['ID'].toString(),index);
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
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }

  Future<dynamic> add_category_layout(BuildContext context) {
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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

                              getParentGroupLayout(SizeConfig.screenHeight, SizeConfig.screenWidth, setState),
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
        );
      },pageBuilder: (context, animation2, animation1) {
      throw Exception('No widget to return in pageBuilder');
      }
    );
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
      readOnly:singleRecord['Update_Right'],
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
      readOnly:singleRecord['Update_Right'],
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
    return  Padding(
        padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
        child: parentCategory==""? SearchableDropdownWithObjectForTax(
          name:editedItem!=null && selectedgroup!=null?selectedgroup:"",
          status:   editedItem!=null?"edit":"",
          apiUrl:ApiConstants().group_nature+"?",
          titleIndicator: true,
          title: ApplicationLocalizations.of(context)!.translate("group_nature")!,
          callback: (item)async{

            setState(() {
              // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));

              selectedgroup=item['name'].toString();

            });
          },

        ): Container(
            height: parentHeight * .055,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, right: 10),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedgroup == null ? ApplicationLocalizations.of(context)!.translate("group_nature")!
                      : selectedgroup,
                  style: selectedgroup == null ? item_regular_textStyle : text_field_textStyle,
                ),
              ],
            )),
    );

      Padding(
          padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("group_nature")!,
            style: item_heading_textStyle,
          ),
          parentCategoryId==0?GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue =
                          Curves.easeInOutBack.transform(a1.value) -
                              1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: GroupNatureDialog(
                            mListener: this,
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation2, animation1) {
                      throw Exception(
                          'No widget to return in pageBuilder');
                    });
              }
            },
            child: Container(
                height: parentHeight * .055,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 10, right: 10),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedgroup == null ? ApplicationLocalizations.of(context)!.translate("group_nature")!
                          : selectedgroup,
                      style: selectedgroup == null ? item_regular_textStyle : text_field_textStyle,
                    ),
                    FaIcon(
                      FontAwesomeIcons.caretDown,
                      color: Colors.black87.withOpacity(0.8),
                      size: 16,
                    )
                  ],
                )),
          ):
          Container(
            height: parentHeight * .055,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, right: 10),
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
            child:Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color:CommonColor.TexField_COLOR),
                child: Text("$selectedgroup",style: item_regular_textStyle,)),
          ),
        ],
      ),
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
  Widget getParentGroupLayout(double parentHeight, double parentWidth,StateSetter setState){
    return
      Padding(
          padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
          child:  SearchableDropdownWithObject(
            name:editedItem!=null && parentCategory!=null?parentCategory:"",
            status:   editedItem!=null?"edit":"",
            apiUrl:ApiConstants().ledger_group+"?",
            titleIndicator: true,
            title: ApplicationLocalizations.of(context)!.translate("parent_group")!,
            callback: (item)async{
              print("hsdhkasj $item");
              if(item!=null) {
                setState(() {
                  parentCategory = item['Name'].toString();
                  parentCategoryId = item['ID'];
                  if (item['Group_Nature'].toString() == "A") {
                    setState(() {
                      selectedgroup = "Asset";
                    });
                  }

                  else if (item['Group_Nature'].toString() == "L") {
                    setState(() {
                      selectedgroup = "Liability";
                    });
                  }
                  else if (item['Group_Nature'].toString() == "I") {
                    setState(() {
                      selectedgroup = "Income";
                    });
                  }
                  else if (item['Group_Nature'].toString() == "E") {
                    setState(() {
                      selectedgroup = "Expense";
                    });
                  }

                  // selectedgroup=item['Group_Nature'].toString();
                });
              }
              else{
                setState(() {
                  selectedgroup = "";
                  parentCategory="";
                  parentCategoryId=0;
                });
              }
            },

          )
      );
      Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("parent_group")!,
            style: item_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child:  Row(
              children: [
                Expanded(
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
                          color: Colors.black.withOpacity(0.01),
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
                              Text(parentCategory==""?ApplicationLocalizations.of(context)!.translate("parent_group")!:parentCategory.toString(),
                                style:parentCategory=="" ? item_regular_textStyle:text_field_textStyle,),
                              FaIcon(FontAwesomeIcons.caretDown,
                                color: Colors.black87.withOpacity(0.8), size: 16,)
                            ],
                          )
                      ),
                    ),
                  ),
                ),
                Container(
                  height: (SizeConfig.screenHeight) * .055,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: CommonColor.WHITE_COLOR,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: IconButton(onPressed: (){
                    setState(() {
                      parentCategoryId=0;
                      parentCategory="";
                      selectedgroup=null;
                    });
                  }, icon: Icon(Icons.clear,color: Colors.red,)),
                )
              ],
            ),
          )
        ],
      ),
    );

  }

  callGetLedgerGroup(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().ledger_group}?Company_ID=$companyId&PageNumber=$page&PageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  print("responseeee   $data");
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
                }else{
                  isApiCall=true;
                }
              });
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
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        DeleteIRequestModel model = DeleteIRequestModel(
          companyId: companyId,
            id:removeId,
            modifier: uid,
            modifierMachine: deviceId
        );
        String apiUrl = baseurl + ApiConstants().ledger_group+"?Company_ID=$companyId";
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
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }
  callPostLedgerGroup() async {
    String companyId = await AppPreferences.getCompanyId();
    String seqNoText = sequenseNoName.text.trim();
    String groupNameText = groupName.text.trim();
    String seqNatureText = selectedgroup.substring(0).trim();
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostLedgerGroupRequestModel model = PostLedgerGroupRequestModel(
          companyID:companyId,
          name: groupNameText,
          seqNo:seqNoText ,
          parentId:parentCategoryId==0?null:parentCategoryId.toString() ,
          groupNature: seqNatureText.substring(0,1),
          creator: creatorName,
          creatorMachine: deviceId,
        );

        //  widget.mListener.loaderShow(true);
        String apiUrl = baseurl + ApiConstants().ledger_group;
        apiRequestHelper.callAPIsForPostMsgAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                sequenseNoName.clear();
                groupName.clear();
                selectedgroup=null;
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
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }

  callUpdateLadgerGroup() async {
    String companyId = await AppPreferences.getCompanyId();
    String seqNoText = sequenseNoName.text.trim();
    String groupNameText = groupName.text.trim();
    String seqNatureText = selectedgroup.substring(0).trim();
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutLedgerGroupRequestModel model = PutLedgerGroupRequestModel(
            name:groupNameText ,
            seqNo:seqNoText ,
            parentId:parentCategoryId==0?null:parentCategoryId.toString() ,
            groupNature:seqNatureText.substring(0,1) ,
            Modifier: creatorName,
            creatorMachine: deviceId,
            companuId: companyId,
        );
        print("MODAL");
        print(model.toJson());
        String apiUrl = baseurl + ApiConstants().ledger_group+"/"+editedItem['ID'].toString()+"?Company_ID=$companyId";
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
                selectedgroup=null;
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
            }, onException: (e) {
              // widget.mListener.loaderShow(false);
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
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
  selectCategory(int id, String name,String nature) {
    // TODO: implement selectCategory
  setState(() {
    parentCategory=name;
    parentCategoryId=id;
    selectedgroup=nature;
  });
  }

  @override
  selctedGroupNature(String code, String name) {
    // TODO: implement selctedGroupNature
   setState(() {
     selectedgroup=name;
   });
  }



}
