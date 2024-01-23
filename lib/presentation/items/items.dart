import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';

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
            "Item Activity",
            style: appbar_text_style,
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
            getAddItemLayout(context);
          }),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item Activity ",
              style: page_heading_textStyle,
            ),
            SizedBox(
              height: 10,
            ),
            getItemListLayout()

          ],
        ),
      ),
    );
  }

  Future<dynamic> getAddItemLayout(BuildContext context) {
    return showDialog(
              context: context,
              builder:(BuildContext context){
                return AlertDialog(
                  title: Text("Add Item"),
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

  Expanded getItemListLayout() {
    return Expanded(
              child: ListView.separated(
                itemCount: [1, 2, 3, 4, 5, 6].length,
                itemBuilder: (BuildContext context, int index) {
                  return  Card(
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
