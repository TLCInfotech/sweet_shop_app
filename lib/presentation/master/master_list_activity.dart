import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/item_category/Item_Category.dart';
import 'package:sweet_shop_app/presentation/items/items.dart';
import 'package:sweet_shop_app/presentation/unit/Units.dart';

class MasterActivity extends StatefulWidget {
  const MasterActivity({Key? key}) : super(key: key);

  @override
  State<MasterActivity> createState() => _MasterActivityState();
}


class _MasterActivityState extends State<MasterActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Container(
          height: SizeConfig.screenHeight * .12,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight:Radius.circular(15.6),
                bottomLeft: Radius.circular(15.6),
                // topRight:Radius.circular(15.6),
                // topLeft:Radius.circular(15.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: CommonColor.DASHBOARD_SHADOW,
                  blurRadius: 3.0,
                ),]
          ),
          child: getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
        ),
        Container(
          height: SizeConfig.screenHeight*.88,
          child:  Column(
            children: [
              getCategoryAndItemLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
              getUnitAndReportLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            ],
          ),
        ),
      ],
    ));
  }


  Widget getTopBar(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(left: parentWidth*.05,right:  parentWidth*.05,top: parentHeight*.03),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardActivity()),
                        (Route<dynamic> route) => true,
                  );
                },
                onDoubleTap: (){},
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(image: AssetImage("assets/images/back.png"),
                      height: parentHeight*.035,
                      width: parentHeight*.035,
                    ),
                  ),
                ),
              ),
              Text(
                "Master Data",
                style: TextStyle(
                  fontFamily: "Inter_SemiBold_Font",
                  fontSize: SizeConfig.blockSizeHorizontal * 5.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: parentWidth * .01),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      width: parentHeight * .023,
                      height: parentHeight * .023,
                      image: const AssetImage('assets/images/back.png'),
                      color: Colors.transparent,

                      // fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget getCategoryAndItemLayout(double parentHeight,double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth*.02,right: parentWidth*.02,top: parentHeight*.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getCategoryLayout(parentHeight,parentWidth),
          getItemLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }
  Widget getCategoryLayout(double parentHeight,double parentWidth){
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ItemCategoryActivity()));
        // if(result = true){
        //   setState(() {
        //     iSMediaUpload == true || iSMediaUpload == null ? Container() : callGetLeaveCountsAPI();
        //   });
        // }
      },
      child: Container(
        height: parentHeight*.22,
        width: parentWidth*.38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: parentHeight*.19,
                  width: parentWidth*.005,
                  decoration: BoxDecoration(
                      color: CommonColor.MY_LEAVE,
                      borderRadius: BorderRadius.circular(1)
                  ),
                ),

              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: parentHeight*.1,
                  width: parentHeight*.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CommonColor.MY_LEAVE,width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "0",
                      style: TextStyle(
                        fontFamily: "Inter_SemiBold_Font",
                        fontSize: SizeConfig.blockSizeHorizontal * 8.0,
                        color: CommonColor.FULL_NAME.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04),
                  child: Text(
                    StringEn.CATEGORY,
                    style: TextStyle(
                      fontFamily: "Inter_SemiBold_Font",
                      fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                      color: CommonColor.FULL_NAME,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemLayout(double parentHeight,double parentWidth){
    return GestureDetector(
      onTap: ()  {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsActivity()));
      },
      child: Container(
        height: parentHeight*.22,
        width: parentWidth*.38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: parentHeight*.19,
                  width: parentWidth*.005,
                  decoration: BoxDecoration(
                      color: CommonColor.APPLIED_LEAVES,
                      borderRadius: BorderRadius.circular(1)
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: parentHeight*.1,
                  width: parentHeight*.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CommonColor.APPLIED_LEAVES,width: 1),
                  ),
                  child: Center(
                    child: Text(
                     "0",
                      style: TextStyle(
                        fontFamily: "Inter_SemiBold_Font",
                        fontSize: SizeConfig.blockSizeHorizontal * 8.0,
                        color: CommonColor.FULL_NAME.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Text(
                  StringEn.ITEM,
                  style: TextStyle(
                    fontFamily: "Inter_SemiBold_Font",
                    fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                    color: CommonColor.FULL_NAME,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getUnitAndReportLayout(double parentHeight,double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth*.02,right: parentWidth*.02,top: parentHeight*.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getUnitLayout(parentHeight,parentWidth),
          getUnitLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }
  
  Widget getUnitLayout(double parentHeight,double parentWidth){
    return GestureDetector(
      onTap: ()  {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsActivity()));

      },
      child: Container(
        height: parentHeight*.22,
        width: parentWidth*.38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: parentHeight*.19,
                  width: parentWidth*.005,
                  decoration: BoxDecoration(
                      color: CommonColor.DENIED_LEAVES,
                      borderRadius: BorderRadius.circular(1)
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: parentHeight*.1,
                  width: parentHeight*.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CommonColor.DENIED_LEAVES,width: 1),
                  ),
                  child: Center(
                    child: Text(
                     "0",
                      style: TextStyle(
                        fontFamily: "Inter_SemiBold_Font",
                        fontSize: SizeConfig.blockSizeHorizontal * 8.0,
                        color: CommonColor.FULL_NAME.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Text(
                  StringEn.UNIT,
                  style: TextStyle(
                    fontFamily: "Inter_SemiBold_Font",
                    fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                    color: CommonColor.FULL_NAME,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

abstract class MasterActivityInterface {
}