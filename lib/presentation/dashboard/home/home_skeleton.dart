import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/api/request_helper.dart';

class HomeSkeleton extends StatefulWidget {

  const HomeSkeleton({Key? key}) : super(key: key);

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton> {
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;
  bool isShowSkeleton = true;
  var statistics=[];

  var saleAmt=0;
  var expenseAmt=0;
  var returnAmt=0;
  var receiptAmt=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              // color: Colors.red,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                leadingWidth: 30,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                leading: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
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
        backgroundColor: const Color(0xFFfffff5),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                getFieldTitleLayout(),

                sale_purchase_expense_container(),
                const SizedBox(
                  height: 10,
                ),
                getFieldTitleLayout(),
                const SizedBox(
                  height: 10,
                ),
                weeklySalegraph(),
                yearly_report_graph(),
              ],
            ),
          ),
        ));
  }

  Container yearly_report_graph() {
    return   Container(
      height: 400,
      width: 400,
      color: CommonColor.BORDER_COLOR.withOpacity(0.4),
    );
  }

  sale_purchase_expense_container() {
    return Padding(
      padding:  EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getSellPurchaseExpenseLayout( ),
              getSellPurchaseExpenseLayout(),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getSellPurchaseExpenseLayout(),
              getSellPurchaseExpenseLayout(),
            ],
          ),
        ],
      ),
    );
  }

  Container weeklySalegraph() {
    return  Container(
      height: 400,
      width: SizeConfig.screenWidth,
      color: CommonColor.BORDER_COLOR.withOpacity(0.4),
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      color: CommonColor.BORDER_COLOR.withOpacity(0.4),
    );
  }

  Container getSellPurchaseExpenseLayout() {
    return   Container(
      height: 120,
      width: (SizeConfig.screenWidth * 0.85) / 2,
      // margin: EdgeInsets.all(10),
      color: CommonColor.BORDER_COLOR.withOpacity(0.4),
      alignment: Alignment.center,
    );
    
  }
}


