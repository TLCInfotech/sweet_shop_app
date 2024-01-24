import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/size_config.dart';
import '../../core/string_en.dart';



class AddFranchiseeActivity extends StatefulWidget {
  const AddFranchiseeActivity({super.key, required mListener});

  @override
  State<AddFranchiseeActivity> createState() => _AddFranchiseeActivityState();
}

class _AddFranchiseeActivityState extends State<AddFranchiseeActivity> {
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
                StringEn.FRANCHISEE_TITLE,
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
            add_franchisee_layout(context);
          }),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringEn.FRANCHISEE_TITLE,
              style: page_heading_textStyle,
            ),
            SizedBox(
              height: 10,
            ),
            get_franchisee_list_layout()

          ],
        ),
      ),
    );
  }

  Expanded get_franchisee_list_layout() {
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: (index)%2==0?Colors.green:Colors.blueAccent,
                            child:  FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            )
                            // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
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
                                      Text("Mr. Franchisee Name ",style: item_heading_textStyle,),
                                      SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.phone,size: 15,color: Colors.black.withOpacity(0.7),),
                                          SizedBox(width: 10,),
                                          Expanded(child: Text("9876543455",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FaIcon(FontAwesomeIcons.locationDot,size: 15,color: Colors.black.withOpacity(0.7),),
                                          SizedBox(width: 10,),
                                          Expanded(child: Text("Jarag Nagar Road , Kolhapur, Mahaarastra - 416012",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        ],
                                      ),
                
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

  add_franchisee_layout(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          content: MyDialog(),
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  final _formkey=GlobalKey<FormState>();
  TextEditingController franchiseeName = TextEditingController();
  TextEditingController franchiseeContactPerson = TextEditingController();
  TextEditingController franchiseeAddress = TextEditingController();
  TextEditingController franchiseeMobileNo = TextEditingController();
  TextEditingController franchiseeContactNo= TextEditingController();
  TextEditingController franchiseeEmail = TextEditingController();



  String ?selectedState = null; // Initial dummy data

  List<String> StateData = ['Maharashtra', 'Karnataka', 'MP'];

  String ?selectedCity = null; // Initial dummy data

  List<String> CityData = ['Kolhapur', 'Mumbai', 'Pune','Bengluru'];


  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: SizeConfig.safeUsedHeight,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color:  Color(0xFFfffff5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(
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
                  StringEn.ADD_FRANCHISEE,
                  style: appbar_text_style,),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
          
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 10,bottom: 20,),
                      child: Text(
                        StringEn.ADD_FRANCHISEE_TITLE,
                        style: page_heading_textStyle,
                      ),
                    ),
                    getFranchiseeNameLayout(),
                    SizedBox(height: 10.0),
                    getContactPersonLayout(),
                    SizedBox(height: 10.0),
                    getAddressLayout(),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCityLayout(),
                        getStateayout(),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    getMobileNoLayout(),
                    SizedBox(height: 10.0),
                    getContactNoLayout(),
                    SizedBox(height: 10.0),
                    getEmailLayout(),
                    SizedBox(height: 20.0),
                    getButtonLayout()
          
          
          
                  ],
                ),
              ),
            ),
          
          ),
        ),
      ),
    );
  }


  /* widget for button layout */
  Widget getButtonLayout(){
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.THEME_COLOR)),
        onPressed: () {
          Navigator.pop(context);
        },
        child:  Text(StringEn.ADD,
            style: button_text_style),
      ),
    );
  }

  /* widget for franchisee email layout */
  Widget getEmailLayout(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: franchiseeEmail,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_EMAIL,
      ),
    );
  }


  /* widget for franchisee Contact No layout */
  Widget getContactNoLayout(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: franchiseeMobileNo,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_CONTACTNO,
      ),
    );
  }

  /* widget for franchisee mobile layout */
  Widget getMobileNoLayout(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: franchiseeMobileNo,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_MOBILENO,
      ),
    );
  }



  /* widget for franchisee state layout */
  Widget getStateayout(){
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      width: SizeConfig.halfscreenWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(color: Colors.grey.withOpacity(0.5))
      ),
      child: DropdownButton<String>(
        hint: Text(StringEn.FRANCHISEE_STATE,style: hint_textfield_Style,),
        underline: SizedBox(),
        isExpanded: true,
        value: selectedState,
        onChanged: (newValue) {
          setState(() {
            selectedState = newValue!;
          });
        },
        items: StateData.map((String state) {
          return DropdownMenuItem<String>(
            value: state,
            child: Text(state),
          );
        }).toList(),
      ),
    );
  }

  /* widget for franchisee city layout */
  Widget getCityLayout(){
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      width: SizeConfig.halfscreenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border:Border.all(color: Colors.grey.withOpacity(0.5))
      ),
      child: DropdownButton<String>(
        hint: Text(StringEn.FRANCHISEE_CITY,style: hint_textfield_Style,),
        underline: SizedBox(),
        isExpanded: true,
        value: selectedCity,
        onChanged: (newValue) {
          setState(() {
            selectedCity = newValue!;
          });
        },
        items: CityData.map((String city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          );
        }).toList(),
      ),
    );
  }


  /* widget for Contact Person layout */
  Widget getContactPersonLayout(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeContactPerson,
      decoration: textfield_decoration.copyWith(
        hintText:StringEn.FRANCHISEE_CONTACT_PERSON,
      ),
    );
  }


  /* widget for Address layout */
  Widget getAddressLayout(){
    return TextFormField(
      maxLines: 4,
      keyboardType: TextInputType.streetAddress,
      controller: franchiseeAddress,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_ADDRESS,
      ),
    );
  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeName,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_NAME,
      ),
    );
  }
}

