import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';

import '../../../../core/colors.dart';
import '../../../../core/size_config.dart';


class UnitsActivity extends StatefulWidget {
  const UnitsActivity({super.key});

  @override
  State<UnitsActivity> createState() => _UnitsActivityState();
}

class _UnitsActivityState extends State<UnitsActivity> {
  final _formkey=GlobalKey<FormState>();
  TextEditingController unitName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.95),
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
                StringEn.UNIT_TITLE,
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
            add_unit_layout(context);
          }),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            get_unit_list_layout()

          ],
        ),
      ),
    );
  }

  Expanded get_unit_list_layout() {
    return Expanded(
        child: ListView.separated(
          itemCount: [1, 2, 3, 4, 5, 6].length,
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
                                Container(
                                  margin: const EdgeInsets.only(top: 15,left: 10,right: 40,bottom: 15),
                                  child: Text("Measuring Unit",style: item_heading_textStyle,),
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

  Future<dynamic> add_unit_layout(BuildContext context) {
    return  showGeneralDialog(
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
                        height: SizeConfig.screenHeight*0.25,
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
                                    StringEn.ADD_UNIT,
                                    style: page_heading_textStyle
                                ),
                              ),
                            ),

                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(top: 10, bottom: 10,),
                              child: Text(
                                StringEn.UNIT,
                                style: page_heading_textStyle,
                              ),
                            ),
                            Container(
                              height: SizeConfig.screenHeight * .055,
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
                                controller: unitName,
                                decoration: textfield_decoration.copyWith(
                                  hintText:"Enter unit measurment",
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),

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
}
