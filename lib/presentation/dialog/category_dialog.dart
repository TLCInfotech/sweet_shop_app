import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryDialogInterface mListener;

  const CategoryDialog({super.key, required this.mListener});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog>{

  bool isLoaderShow = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();


  }
  List pollDuration=["1 day","2 days","3 days","4 days"];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.08,
                    child: Center(
                      child: Text(
                        "Select Duration",
                        style: TextStyle(
                          fontFamily: "Montserrat_Bold",
                          fontSize: SizeConfig.blockSizeHorizontal * 5.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: SizeConfig.screenHeight*.42,
                      child: getList(SizeConfig.screenHeight,SizeConfig.screenWidth)),

                ],
              ),
            ),
          ),
          getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
        ],
      ),
    );
  }

  Widget getList(double parentHeight,double parentWidth){
    return Padding(
      padding:EdgeInsets.only(top: parentHeight*.0),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: pollDuration.length,
          itemBuilder:(BuildContext context, int index){
            return Padding(
              padding:EdgeInsets.only(left: parentWidth*.1,right: parentWidth*.1),
              child: GestureDetector(
                onTap: (){
                  if(widget.mListener!=null){
                    widget.mListener.selectCategory(index.toString(),pollDuration.elementAt(index));
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: parentHeight*.06,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        color: CommonColor.PROFILE_BORDER,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pollDuration.elementAt(index),
                        style: TextStyle(
                          fontFamily: "Montserrat_Medium",
                          fontSize: SizeConfig.blockSizeHorizontal * 4.3,
                          color: CommonColor.SICK_LEAVE.withOpacity(0.8),
                          fontWeight: FontWeight.w500,

                        ),

                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          // Scaffold.of(context).openDrawer();
        },
        child: Container(
          height: parentHeight*.065,
          decoration: BoxDecoration(
            color: CommonColor.THEME_COLOR,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
          ),
          child:Center(
            child: Text(
              StringEn.CLOSE,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CommonColor.WHITE_COLOR,
                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto_Medium',
              ),
            ),
          ),
        ),
      ),
    );
  }




}


abstract class CategoryDialogInterface{
  selectCategory(String id,String name);
}