
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';


class ExpenseGroup extends StatefulWidget {
  const ExpenseGroup({super.key});

  @override
  State<ExpenseGroup> createState() => _ExpenseGroupState();
}

class _ExpenseGroupState extends State<ExpenseGroup>{
  TextEditingController categoryName = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController sequenseNoName = TextEditingController();
  TextEditingController sequenseNatureName = TextEditingController();
  final _groupNameFocus = FocusNode();
  final _sequenseNoFocus = FocusNode();
  final _sequenceNatureFocus = FocusNode();
  String parentCategory="";
  int parentCategoryId=0;
  String ParentGroupid="";
  List<dynamic> expense_group=[
  {
  "ID" : "13",
  "Name" : "Employee",
  "Parent_ID" : "34",
  "Seq_No" : "36",
  "Group_Nature" : "A"
}
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
          itemCount: expense_group.length,
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

              PostData();
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
  Widget getParentGroupLayout(double parentHeight, double parentWidth){
    return GetCategoryLayout(
        title:   ApplicationLocalizations.of(context)!.translate("parent_category")!,
        callback: (name,id){
          setState(() {
            parentCategory=name!;
            parentCategoryId=id!;
          });
        },
        selectedProductCategory: parentCategory
    );

  }

}
