import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/deleteDialog.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_category_layout.dart';
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
import '../../../../data/domain/itemCategory/post_item_category_request_model.dart';
import '../../../../data/domain/itemCategory/put_item_category_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';


class ItemCategoryActivity extends StatefulWidget {
  final  formId;
  final  arrData;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const ItemCategoryActivity({super.key, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<ItemCategoryActivity> createState() => _ItemCategoryActivityState();
}

class _ItemCategoryActivityState extends State<ItemCategoryActivity> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController categoryName = TextEditingController();
  final _categoryKey = GlobalKey<FormFieldState>();

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  String parentCategory="";
  int parentCategoryId=0;
  TextEditingController seqNo = TextEditingController();
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
        callGetItemCategory(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetItemCategory(page);
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }

  List<dynamic> _arrListNew = [];

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetItemCategory(page);

  }
  var selectedCategoryName=null;
/* Widget to get sale ledger Name Layout */
  Widget getCategorySearchLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():
    SearchableDropdownWithObject(
        apiUrl: "${ApiConstants().item_category}?",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("item_category")!,
        // franchiseeName: selectedCategoryName!=""? selectedCategoryName:"",
        // franchisee:selectedCategoryName,
        callback: (item)async{
          setState(() {
            selectedCategoryName=item;
            page=1;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });

            setState(() {
            editedItem=selectedCategoryName;
            categoryName.text=selectedCategoryName['Name'];
            parentCategory=selectedCategoryName['Parent_Name']==null?"":selectedCategoryName['Parent_Name'];
            parentCategoryId=selectedCategoryName['Parent_ID']==null?0:selectedCategoryName['Parent_ID'];
            seqNo.text=selectedCategoryName['Seq_No']!=null?selectedCategoryName['Seq_No'].toString():"";
          });
          await  add_category_layout(context,singleRecord['Update_Right']);

          await callGetItemCategory(page);

          // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
          //   mListener: this,
          //   ledgerList: item,
          //   readOnly:singleRecord['Update_Right'],
          // )));
          // await callGetLedger(0);
        },
      name: selectedCategoryName,);
  }
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
                                ApplicationLocalizations.of(context)!.translate("item_category")!,
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
          floatingActionButton:singleRecord['Insert_Right']==true ? FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  editedItem=null;
                  categoryName.clear();
                  parentCategory="";
                  parentCategoryId=0;
                  seqNo.clear();
                });
                add_category_layout(context,true);

              }):Container(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getCategorySearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
                    const SizedBox(
                      height: 10,
                    ),
                    get_category_items_list_layout()

                  ],
                ),
              ),
              // Visibility(
              //     visible: expense_group.isEmpty && isApiCall  ? true : false,
              //     child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
            ],
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
           ApplicationLocalizations.of(context).translate("no_data"),
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

  Future<dynamic> add_category_layout(BuildContext context,updateRight) {
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
                        height: SizeConfig.screenHeight*0.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFfffff5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Container(
                                height: SizeConfig.screenHeight*.08,
                                child: Center(
                                  child: Text(
                                      ApplicationLocalizations.of(context)!.translate("item_category")!,
                                      style: page_heading_textStyle
                                  ),
                                ),
                              ),
                              getCategoryLayout(SizeConfig.screenHeight,SizeConfig.screenWidth,updateRight),
                              getAddCategoryLayout(SizeConfig.screenHeight, SizeConfig.screenWidth,updateRight),
                              getseqNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth,updateRight),
                              const SizedBox(height: 20,),
                            ],
                          ),
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

  /* widget for seq no layout */
  Widget getseqNoLayout(double parentHeight, double parentWidth, bool updateRight) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      controller: seqNo,
      readOnly: updateRight,
      focuscontroller: null,
      focusnext: null,
      title:  ApplicationLocalizations.of(context)!.translate("sequence_no")!,
      callbackOnchage: (value) {
        setState(() {
          seqNo.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9  ]')),
    );

  }

  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth, bool updateRight){
    return Padding(
        padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
        child:  SearchableLedgerDropdown(
            apiUrl:ApiConstants().item_category+"?",
            franchisee: editedItem!=null?"edit":"",
            readOnly: updateRight,
            franchiseeName: editedItem!=null && editedItem['Parent_Name']!=null?editedItem['Parent_Name']:"",
            title:  ApplicationLocalizations.of(context)!.translate("parent_category")!,
            callback: (name,id){

              setState(() {
                parentCategory=name!;
                parentCategoryId=int.parse(id!);
              });

            },
            ledgerName: parentCategory)
    );


      GetCategoryLayout(
        title: ApplicationLocalizations.of(context)!.translate("parent_category")!,
        callback: (name,id){
          setState(() {
            parentCategory=name!;
            parentCategoryId=id!;
            print("jkfgjgjgbbg  $id");
          });
    },
        selectedProductCategory: parentCategory
    );

  }

  /* widget for Category layout */
  Widget getCategoryLayout(double parentHeight, double parentWidth, bool updateRight) {
    return SingleLineEditableTextFormField(
      mandatory: true,
      txtkey: _categoryKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
    //  readOnly: editedItem!=null?false:true,
      controller: categoryName,
      readOnly:updateRight ,
      focuscontroller: null,
      focusnext: null,
      title:  ApplicationLocalizations.of(context)!.translate("category")!,
      callbackOnchage: (value) {
        setState(() {
          categoryName.text = value;
        });
        _categoryKey.currentState!.validate();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z ]')),
    );

  }

  /* widget for title layout */
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

  Widget getCloseButton(double parentHeight, double parentWidth){
    return singleRecord['Update_Right']==false? GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onDoubleTap: () {},
      child: Container(
        height:parentHeight*.05,
        width: parentWidth*.90,
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
    ):  Padding(
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
              bool v=_categoryKey.currentState!.validate();
              if(v) {
                if (editedItem != null) {
                  print("jgbgbgbggn");
                  callUpdateItemCategory();
                } else {
                  callPostItemCategory();
                }
              }
             //Navigator.pop(context);
            },
            onDoubleTap: () {},
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



  Expanded get_category_items_list_layout() {
    return Expanded(
        child:RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _arrListNew.length,
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
                      onTap: ()async{

                        print(_arrListNew[index]);
                        setState(() {
                          editedItem=_arrListNew[index];
                          categoryName.text=_arrListNew[index]['Name'];
                          parentCategory=_arrListNew[index]['Parent_Name']==null?"":_arrListNew[index]['Parent_Name'];
                          parentCategoryId=_arrListNew[index]['Parent_ID']==null?0:_arrListNew[index]['Parent_ID'];
                          seqNo.text=_arrListNew[index]['Seq_No'].toString();
                        });
                        add_category_layout(context,singleRecord['Update_Right']);
                      },
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
                              width:60,
                              height: 40,
                              decoration:  BoxDecoration(
                                  color: index %2==0?const Color(0xFFEC9A32):const Color(0xFF7BA33C),
                                  borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),
                              alignment: Alignment.center,
                              child: Text("${(index+1).toString()}",style: const TextStyle(),),
                            ),
                            Expanded(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            // margin: const EdgeInsets.only(top: 15,left: 10,right: 40,bottom: 2),
                                            child: Text(_arrListNew[index]['Name'],style: item_heading_textStyle,),
                                          ),
                                          _arrListNew[index]['Parent_Name']!=null? Container(
                                            child: Text(_arrListNew[index]['Parent_Name'],style: item_regular_textStyle,),
                                          ):Container(),
                                        ],
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?   Positioned(
                                        top: 0,
                                        right: 0,
                                        child:DeleteDialogLayout(
                                          callback: (response ) async{
                                            if(response=="yes"){
                                              print("##############$response");
                                              await callDeleteItemCategory(_arrListNew[index]['ID'].toString(),index);
                                            }
                                          },
                                        )
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

  callGetItemCategory(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().item_category}?Company_ID=$companyId&${StringEn.lang}=$lang&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
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
              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error);
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
    if (_arrListNew.isNotEmpty) _arrListNew.clear();
    if (mounted) {
      setState(() {
        _arrListNew.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        _arrListNew.addAll(_list);
      });
    }
  }

  callDeleteItemCategory(String removeId,int index) async {
    print("DELETE");
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
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
        String apiUrl = baseurl + ApiConstants().item_category+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                _arrListNew.removeAt(index);
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

  callPostItemCategory() async {
    String companyId = await AppPreferences.getCompanyId();
    String catName = categoryName.text.trim();
    String seqNoText = seqNo.text.trim();
    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostItemCategoryRequestModel model = PostItemCategoryRequestModel(
            CompanyId: companyId,
            Lang: lang,
            Name: catName,
            Parent_ID:parentCategoryId.toString(),
            Seq_No: seqNoText,
            Creator: creatorName,
            Creator_Machine: deviceId
        );

        //  widget.mListener.loaderShow(true);
        String apiUrl = baseurl + ApiConstants().item_category;
        apiRequestHelper.callAPIsForPostMsgAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print("  LedgerLedger  $data ");
              setState(() {
                isLoaderShow=false;
                callGetItemCategory(page);
              });
              Navigator.pop(context);

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

  callUpdateItemCategory() async {
    String companyId = await AppPreferences.getCompanyId();
    String catName = categoryName.text.trim();
    String seqNoText = seqNo.text.trim();
    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutItemCategoryRequestModel model = PutItemCategoryRequestModel(
          companyId: companyId,
            modifier: creatorName,
            name:catName ,
            modifierMachine: deviceId,
            // companyId: companyId
        );
        if(editedItem['Parent_ID']!=parentCategoryId && parentCategoryId!=0){
          model.parentId=parentCategoryId.toString();
          // seqNo: seqNoText,
        }
        if(editedItem['Seq_No']!= int.parse(seqNoText)){
          model.seqNo=seqNoText.toString();
        }

        print("MODAL");
        print(model.toJson());
        String apiUrl =baseurl + ApiConstants().item_category+"/"+editedItem['ID'].toString()+"?Company_ID=$companyId&${StringEn.lang}=$lang";

        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
            onSuccess:(value)async{
              print("  Put Call :   $value ");

              setState(() {
                editedItem=null;
                categoryName.clear();
                parentCategory="";
                parentCategoryId=0;
                seqNo.clear();
              });
              var snackBar = SnackBar(content: Text('Item Category Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              setState(() {
                page=1;
              });

              await  callGetItemCategory(page);
              Navigator.pop(context);

            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
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

}
