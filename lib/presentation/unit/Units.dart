import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/common_style.dart';
import '../../core/string_en.dart';

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
            Text(
              StringEn.UNIT_TITLE,
              style: page_heading_textStyle,
            ),
            SizedBox(
              height: 10,
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
    return showDialog(
              context: context,
              builder:(BuildContext context){
                return AlertDialog(

                  title: Text(StringEn.ADD_UNIT,style: appbar_text_style,),
                  content: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: unitName,
                          decoration: InputDecoration(
                            hintText: StringEn.UNIT_NAME,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFFBE404))),
                            onPressed: () {
                              // Add login functionality
                              Navigator.pop(context);
                            },
                            child: Text(StringEn.ADD,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
  }
}
