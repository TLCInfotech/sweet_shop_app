
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/parent_group_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_category/item_create_activity.dart';


class ExpenseGroup extends StatefulWidget {
  const ExpenseGroup({super.key});

  @override
  State<ExpenseGroup> createState() => _ExpenseGroupState();
}

class _ExpenseGroupState extends State<ExpenseGroup>with CategoryDialogInterface ,ParentGroupDialogInterface{
  TextEditingController categoryName = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController sequenseNoName = TextEditingController();
  TextEditingController sequenseNatureName = TextEditingController();
  final _groupNameFocus = FocusNode();
  final _sequenseNoFocus = FocusNode();
  final _sequenceNatureFocus = FocusNode();
  String parentCategory="";
  List<dynamic> expense_group=[
    {
      "name":"Category 1",
      "id":123
    },
    {
      "name":"Category 2",
      "id":123
    },
    {
      "name":"Category 3",
      "id":123
    },
  ];


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
                StringEn.EXPENSE_GROUP,
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
            SizedBox(
              height: .5,
            ),
            get_expense_group_list_layout()

          ],
        ),
      ),
    );
  }

  Expanded get_expense_group_list_layout() {
    return Expanded(
        child: ListView.separated(
          itemCount: [1, 2, 3, 4, 5, 6,7,8,9].length,
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
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width:80,
                          height: 70,
                          decoration:  BoxDecoration(
                              color: index %2==0?Color(0xFFEC9A32):Color(0xFF7BA33C),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.peopleGroup,color: Colors.white,),
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
                                      Text("Group Name",style: item_heading_textStyle,),
                                      Text("Parent Group - Seq No",style: item_regular_textStyle,),
                                      Text("Group Nature",style: item_regular_textStyle,),

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
                        decoration: BoxDecoration(
                          color: Color(0xFFfffff5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: SizeConfig.screenHeight*.03,
                              child: Center(
                                child: Text(
                                    StringEn.ADD_EXPENSE,
                                    style: page_heading_textStyle
                                ),
                              ),
                            ),
                            getFieldTitleLayout(StringEn.GROUP_NAME),
                            getGroupNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                            getFieldTitleLayout(StringEn.PARENT_GROUP),
                            getParentGroupLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                            getFieldTitleLayout(StringEn.SEQUENSE_NO),
                            getSequenceNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                            getFieldTitleLayout(StringEn.SEQUENSE_NATURE),
                            getSequenceNatureLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

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

  /* widget for Category layout */
  Widget getCategoryLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.01),
      child: Container(
        height: parentHeight * .055,
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
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: categoryName,
          decoration: textfield_decoration.copyWith(
              hintText: StringEn.CATEGORY,
              suffix: Text("%")
          ),
          validator: ((value) {
            if (value!.isEmpty) {
              return "Enter Category";
            }
            return null;
          }),

        ),
      ),
    );
  }
  /* widget for Category layout */
  Widget getGroupNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.01),
      child: Container(
        height: parentHeight * .055,
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
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: groupName,
          focusNode: _groupNameFocus,
          textInputAction: TextInputAction.next,
          decoration: textfield_decoration.copyWith(
              hintText: StringEn.GROUP_NAME,
          ),
          onEditingComplete: () {
            _groupNameFocus.unfocus();
           // FocusScope.of(context).requestFocus(_sequenseNoFocus);
          },
          validator: ((value) {
            if (value!.isEmpty) {
              return "Enter group name";
            }
            return null;
          }),

        ),
      ),
    );
  }
  /* widget for Category layout */
  Widget getSequenceNoLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.01),
      child: Container(
        height: parentHeight * .055,
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
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: sequenseNoName,
          focusNode: _sequenseNoFocus,
          textInputAction: TextInputAction.next,

          decoration: textfield_decoration.copyWith(
              hintText: StringEn.SEQUENSE_NO,
          ),
          onEditingComplete: () {
            _sequenseNoFocus.unfocus();
            //FocusScope.of(context).requestFocus(_sequenceNatureFocus);
          },
          validator: ((value) {
            if (value!.isEmpty) {
              return "Enter sequense no";
            }
            return null;
          }),

        ),
      ),
    );
  }
  /* widget for Category layout */
  Widget getSequenceNatureLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.01),
      child: Container(
        height: parentHeight * .055,
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
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: sequenseNatureName,
          focusNode: _sequenceNatureFocus,
          textInputAction: TextInputAction.done,

          decoration: textfield_decoration.copyWith(
              hintText: StringEn.SEQUENSE_NATURE,
          ),
          onEditingComplete: () {
            _sequenceNatureFocus.unfocus();
            //FocusScope.of(context).requestFocus(_sequenseNoFocus);
          },
          validator: ((value) {
            if (value!.isEmpty) {
              return "Enter sequence nature";
            }
            return null;
          }),

        ),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringEn.CLOSE,
                    textAlign: TextAlign.center,
                    style: text_field_textStyle,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {

              Navigator.pop(context);

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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringEn.SAVE,
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
      padding: EdgeInsets.only(
        top: parentHeight * .01),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if(mounted){

          }
          if (context != null) {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                  return Transform(
                    transform:
                    Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                    child: Opacity(
                      opacity: a1.value,
                      child: ParentGroupDialog(
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
        onDoubleTap: () {},
        child: Padding(
          padding: EdgeInsets.only(
            top: parentHeight * .01,
          ),
          child: Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .058,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          parentCategory==""?"Select Parent group":parentCategory,
                          style:parentCategory == ""? hint_textfield_Style:
                          text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: parentHeight * .03,
                          color: /*pollName == ""
                              ? CommonColor.HINT_TEXT
                              :*/ CommonColor.BLACK_COLOR,
                        ),
                      ],
                    ),
                  ),
                ),

              ]),
        ),
      ),
    );
  }

  @override
  selectCategory(String id, String name) {
    // TODO: implement selectCategory
setState(() {
  // parentCategory=name;
});
  }

  @override
  selectParentG(String id, String name) {
    // TODO: implement selectParentG
    setState(() {
      parentCategory=name;
    });
  }
}