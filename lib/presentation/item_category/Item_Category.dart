import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/common_style.dart';

class ItemCategoryActivity extends StatefulWidget {
  const ItemCategoryActivity({super.key});

  @override
  State<ItemCategoryActivity> createState() => _ItemCategoryActivityState();
}

class _ItemCategoryActivityState extends State<ItemCategoryActivity> {
  final _formkey=GlobalKey<FormState>();
  TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: AppBar(
          backgroundColor: Color(0xFFFBE404),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Item Category Activity",
            style: TextStyle(color: Colors.black87),
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
            showDialog(
                context: context,
                builder:(BuildContext context){
                  return AlertDialog(

                    title: Text("Add Item Category"),
                    content: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: categoryName,
                            decoration: InputDecoration(
                              hintText: 'Enter Item Category',
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
                              child: Text('Add',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });

          }),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item Category Activity ",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.separated(
                  itemCount: [1, 2, 3, 4, 5, 6,7].length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Card(
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
                                    child: Text("Item Category",style: item_heading_textStyle,),
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                ))

          ],
        ),
      ),
    );
  }
}
