import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Units extends StatefulWidget {
  const Units({super.key});

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {
  final _formkey=GlobalKey<FormState>();
  TextEditingController unitName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: AppBar(
          backgroundColor: Color(0xFFFBE404),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            onPressed: () {},
          ),
          title: Text(
            "Measuring Units",
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

                    title: Text("Add Unit"),
                    content: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: unitName,
                            decoration: InputDecoration(
                              hintText: 'Enter Unit Measurement',
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
              "Mesuring Units ",
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
              itemCount: [1, 2, 3, 4, 5, 6].length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: Colors.white,
                  title: Text("Kg"),
                  leading: FaIcon(FontAwesomeIcons.weightHanging),
                  trailing: FaIcon(
                    FontAwesomeIcons.trash,
                    size: 18,
                    color: Colors.redAccent,
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
