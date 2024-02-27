import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_category_layout.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/itemCategory/get_toakn_request.dart';
import '../../../../data/domain/itemCategory/post_item_category_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';


class ItemCategoryActivity extends StatefulWidget {
  const ItemCategoryActivity({super.key});

  @override
  State<ItemCategoryActivity> createState() => _ItemCategoryActivityState();
}

class _ItemCategoryActivityState extends State<ItemCategoryActivity> {
  TextEditingController categoryName = TextEditingController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  String parentCategory="";
  int parentCategoryId=0;
  TextEditingController seqNo = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetItemCategory();
  }
  List<dynamic> _arrListNew = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),

              backgroundColor: Colors.white,
              title: Text(
                ApplicationLocalizations.of(context)!.translate("item_category")!,
                style: appbar_text_style,),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFBE404),
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.black87,
          ),
          onPressed: () {
            add_category_layout(context);

          }),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: .5,
            ),
            get_category_items_list_layout()

          ],
        ),
      ),
    );
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
                        height: SizeConfig.screenHeight*0.5,
                        decoration: BoxDecoration(
                          color: Color(0xFFfffff5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.screenHeight*.08,
                              child: Center(
                                child: Text(
                                    ApplicationLocalizations.of(context)!.translate("add_category")!,
                                    style: page_heading_textStyle
                                ),
                              ),
                            ),
                            getCategoryLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                            getAddCategoryLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),

                            getseqNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                            SizedBox(height: 20,),

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
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation2, animation1) {
          throw Exception('No widget to return in pageBuilder');
        });
  }

  /* widget for seq no layout */
  Widget getseqNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ ApplicationLocalizations.of(context)!.translate("sequence_no")!;
        }
        return null;
      },
      controller: seqNo,
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
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return GetCategoryLayout(
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
  Widget getCategoryLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ ApplicationLocalizations.of(context)!.translate("category")!;
        }
        return null;
      },
      controller: categoryName,
      focuscontroller: null,
      focusnext: null,
      title:  ApplicationLocalizations.of(context)!.translate("category")!,
      callbackOnchage: (value) {
        setState(() {
          categoryName.text = value;
        });
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
              callPostItemCategory();
                //Navigator.pop(context);

            },
            onDoubleTap: () {},
            child: Container(
              height: parentHeight * .05,
              width: parentWidth*.45,
              decoration: BoxDecoration(
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
        child: ListView.separated(
          itemCount: _arrListNew.length,
          itemBuilder: (BuildContext context, int index) {
            return  AnimationConfiguration.staggeredList(
              position: index,
              duration:
              const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: -44.0,
                child: FadeInAnimation(
                  delay: Duration(microseconds: 1500),
                  child: Card(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10,top: 5,bottom: 5),
                          width:60,
                          height: 40,
                          decoration:  BoxDecoration(
                              color: index %2==0?Color(0xFFEC9A32):Color(0xFF7BA33C),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          alignment: Alignment.center,
                          child: Text("${(index+1).toString().padLeft(2, '0')}",style: TextStyle(),),
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
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child:IconButton(
                                      icon:  FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: (){},
                                    ) )
                              ],
                            )

                        )
                      ],
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
        ));
  }



  callGetItemCategory() async {
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = ApiConstants().baseUrl + ApiConstants().item_category;
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            setState(() {
              _arrListNew=data;
            });
            // _arrListNew.addAll(data.map((arrData) =>
            // new EmailPhoneRegistrationModel.fromJson(arrData)));
            print("  LedgerLedger  $data ");
          }, onFailure: (error) {
            CommonWidget.noInternetDialog(context, error);
            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });

    });
  }
  callPostItemCategory() async {
    String catName = categoryName.text.trim();
    String seqNoText = seqNo.text.trim();
    String creatorName = await AppPreferences.getUId();
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
/*model={  "Name": catName,
     "Parent_ID" :parentCategoryId.toString(),
      "Seq_No": seqNo.text,
      "Creator": creatorName,
      "Creator_Machine": deviceId
};*/
      PostItemCategoryRequestModel model = PostItemCategoryRequestModel(
          Name: catName,
        Parent_ID:parentCategoryId.toString(),
        Seq_No: seqNoText,
        Creator: creatorName,
        Creator_Machine: deviceId
      );

      //  widget.mListener.loaderShow(true);
      String apiUrl = ApiConstants().baseUrl + ApiConstants().item_category;
      apiRequestHelper.callAPIsForPostLoginAPI(apiUrl, model.toJson(), "",
          onSuccess:(value,uid){
            print("  LedgerLedger  $value ");
            Navigator.pop(context);
            }, onFailure: (error) {
            CommonWidget.noInternetDialog(context, "Signup Error");
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
