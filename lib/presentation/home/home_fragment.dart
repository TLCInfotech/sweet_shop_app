import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/common_style.dart';
import '../../core/string_en.dart';

class HomeFragment extends StatefulWidget {
  final HomeFragmentInterface mListener;
  const HomeFragment({Key? key, required this.mListener}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                leading: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                title: Image(
                  width: SizeConfig.screenHeight * .1,
                  image: const AssetImage('assets/images/Shop_Logo.png'),
                  // fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFfffff5),
        body: Column(
          children: [
            // Container(
            //   height: SizeConfig.screenHeight * .12,
            //   decoration: const BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(
            //         bottomRight:Radius.circular(15.6),
            //         bottomLeft: Radius.circular(15.6),
            //         // topRight:Radius.circular(15.6),
            //         // topLeft:Radius.circular(15.6),
            //       ),
            //       boxShadow: [
            //         BoxShadow(
            //           color: CommonColor.DASHBOARD_SHADOW,
            //           blurRadius: 3.0,
            //         ),]
            //   ),
            //   child: getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
            // ),
            Container(
              height: SizeConfig.screenHeight * .75,
              child: Center(
                child: Text(
                  "Coming Soon..",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      fontFamily: 'Inter_SemiBold_Font',
                      color: CommonColor.BLACK_COLOR),
                ),
              ),
            ),
          ],
        ));
  }

  Widget getTopBar(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
          left: parentWidth * .05,
          right: parentWidth * .04,
          top: parentHeight * .04),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.menu,
                      size: parentHeight * .03,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                width: parentWidth * .2,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: parentWidth * .01),
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image(
                            width: parentHeight * .023,
                            height: parentHeight * .023,
                            image: const AssetImage('assets/images/home.png'),
                            color: Colors.transparent,
                            // fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Image(
            width: SizeConfig.screenHeight * .1,
            image: const AssetImage('assets/images/Shop_Logo.png'),
            // fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

abstract class HomeFragmentInterface {}
