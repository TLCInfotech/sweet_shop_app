
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/string_en.dart';

class ItemsActivity extends StatefulWidget {
  const ItemsActivity({super.key});

  @override
  State<ItemsActivity> createState() => _ItemsActivityState();
}

class _ItemsActivityState extends State<ItemsActivity> {

  final _formkey=GlobalKey<FormState>();
  TextEditingController itemName = TextEditingController();
  TextEditingController itemRate = TextEditingController();
  TextEditingController itemPkgSize = TextEditingController();

  List<dynamic> item_category=[
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

  String? selectedCategory="choose";


  List<dynamic> measuring_unit=[
    {
      "name":"kg",
      "id":123
    },
    {
      "name":"Ltr",
      "id":123
    },
    {
      "name":"Gram",
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
                StringEn.ITEM_TITLE,
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
            add_item_layout(context);
          }),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringEn.ITEM_TITLE,
              style: page_heading_textStyle,
            ),
            SizedBox(
              height: 10,
            ),
            get_items_list_layout()

          ],
        ),
      ),
    );
  }

  Future<dynamic> add_item_layout(BuildContext context) {
    return
      showDialog(
              context: context,
              builder:(BuildContext context){
                return AlertDialog(
                  title: Text(StringEn.ADD_ITEM,style: appbar_text_style,),
                  content: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: itemName,
                          decoration: InputDecoration(
                            hintText: 'Enter Item Name',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.6/2,
                              child: TextFormField(
                                controller: itemRate,
                                decoration: InputDecoration(
                                  hintText: 'Enter Item Rate',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.6/2,
                              child: TextFormField(
                                controller: itemPkgSize,
                                decoration: InputDecoration(
                                  hintText: 'Enter Pakage Size',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),

                          ],
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
                            child: Text('Add',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
  }

  Expanded get_items_list_layout() {
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
                          width:SizeConfig.imageBlockFromCardWidth,
                          height: 80,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Login_Background.jpg'), // Replace with your image asset path
                                fit: BoxFit.cover,
                              ),
                              // borderRadius: BorderRadius.only(
                              //   bottomLeft: Radius.circular(10),
                              //   topLeft: Radius.circular(10)
                              // )
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
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
                                      Text("Sweet Item 1 sjhdfjas",style: item_heading_textStyle,),
                                      Text("The descreption related to sweet if available.",style: item_regular_textStyle,),
                                      Text("500.00 per/kg",style: item_heading_textStyle,),

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



}
