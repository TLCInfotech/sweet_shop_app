import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              // color: Colors.red,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
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
                getFieldTitleLayout("Sale,Purchase,Expense"),
                salepurchasegraph(),
                const SizedBox(
                  height: 10,
                ),
                getFieldTitleLayout("Also Explore"),

                const SizedBox(
                  height: 10,
                ),
                sale_purchase_expense_container(),
                const SizedBox(
                  height: 10,
                ),
                getFieldTitleLayout("Yearly Report"),

                yearly_report_graph(),
              ],
            ),
          ),
        ));
  }

  Container yearly_report_graph() {
    return Container(
                height: 180,
                width: SizeConfig.screenWidth,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                    image: const DecorationImage(
                        image:
                            AssetImage("assets/images/home_page_pichart.png"),
                        fit: BoxFit.fill)),
              );
  }

  Row sale_purchase_expense_container() {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getSellPurchaseExpenseLayout(Colors.green, "10000", "Sell"),
                  getSellPurchaseExpenseLayout(
                      Colors.orange, "10000", "purchase"),
                  getSellPurchaseExpenseLayout(
                      Colors.deepPurple, "10000", "Expense"),
                ],
              );
  }

  Container salepurchasegraph() {
    return Container(
                height: 150,
                width: SizeConfig.screenWidth,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                    image: const DecorationImage(
                        image:
                            AssetImage("assets/images/home_page_graph1.png"),
                        fit: BoxFit.cover)),
              );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }
  Container getSellPurchaseExpenseLayout(
      MaterialColor boxcolor, String amount, String title) {
    return Container(
      height: 170,
      width: (SizeConfig.screenWidth * 0.85) / 3,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: boxcolor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 60,
            width: (SizeConfig.screenWidth * 0.85) / 3,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: boxcolor, borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              "$amount",
              style: subHeading_withBold,
            ),
          ),
          Text(
            "$title",
            style: item_heading_textStyle.copyWith(
              color: boxcolor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FaIcon(
            FontAwesomeIcons.solidArrowAltCircleRight,
            color: boxcolor,
          )
        ],
      ),
    );
  }
}

abstract class HomeFragmentInterface {}
