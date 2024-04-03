import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

                getFieldTitleLayout(" Explore"),

                sale_purchase_expense_container(),
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
      child: SfCircularChart(
        title: ChartTitle(text: 'Expense analysis',alignment: ChartAlignment.near),
        series: <CircularSeries>[
          PieSeries<ExpenseData, String>(
            dataSource: [
              ExpenseData('Food', 300),
              ExpenseData('Rent', 600),
              ExpenseData('Transport', 200),
              ExpenseData('Utilities', 150),
            ],
            xValueMapper: (ExpenseData data, _) => data.category,
            yValueMapper: (ExpenseData data, _) => data.amount,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              connectorLineSettings: ConnectorLineSettings(
                color: Colors.blue,
                length: '8%',
                type: ConnectorType.line,
              ),
            ),
          )
        ],
      ),
    );
  }

   sale_purchase_expense_container() {
    return Column(
      children: [
        Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getSellPurchaseExpenseLayout(Colors.green, "10000", "Sale"),
                      getSellPurchaseExpenseLayout(Colors.orange, "10000", "Expense"),
                    ],
                  ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getSellPurchaseExpenseLayout(Colors.blue, "10000", "Return"),
            getSellPurchaseExpenseLayout(Colors.deepPurple, "10000", "Receipt"),
          ],
        ),
      ],
    );
  }

  Container weeklySalegraph() {
    return  Container(
      height: 400,
      width: SizeConfig.screenWidth,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Weekly Sales analysis',alignment: ChartAlignment.near),
        // Enable legend
        // legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(title: AxisTitle(text: "Sale Amount ",textStyle: item_regular_textStyle )),
        series: <ChartSeries>[
          ColumnSeries<SalesData, String>(
            dataSource: [
              SalesData('Mon', 30),
              SalesData('Tue', 40),
              SalesData('Wed', 35),
              SalesData('Thu', 50),
              SalesData('Fri', 45),
              SalesData('Sat', 60),
              SalesData('Sun', 55),
            ],
            xValueMapper: (SalesData sales, _) => sales.day,
            yValueMapper: (SalesData sales, _) => sales.sales,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      ),
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

  Container getSellPurchaseExpenseLayout( MaterialColor boxcolor, String amount, String title) {
    return   Container(
      height: 120,
      width: (SizeConfig.screenWidth * 0.85) / 2,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: boxcolor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 60,
            width: (SizeConfig.screenWidth * 0.85) / 2,
            // margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: boxcolor, borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              CommonWidget.getCurrencyFormat(double.parse(amount)),
              style: subHeading_withBold.copyWith(fontSize:18 ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$title",
                style: item_heading_textStyle.copyWith(
                  color: boxcolor,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              FaIcon(
                FontAwesomeIcons.solidArrowAltCircleRight,
                color: boxcolor,
              )
            ],
          )

        ],
      ),
    );

    //   Container(
    //   height: 170,
    //   width: (SizeConfig.screenWidth * 0.85) / 3,
    //   // margin: EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //       color: boxcolor.withOpacity(0.3),
    //       borderRadius: BorderRadius.circular(5)),
    //   alignment: Alignment.center,
    //   child: Column(
    //     children: [
    //       Container(
    //         height: 60,
    //         width: (SizeConfig.screenWidth * 0.85) / 3,
    //         margin: const EdgeInsets.all(15),
    //         decoration: BoxDecoration(
    //             color: boxcolor, borderRadius: BorderRadius.circular(5)),
    //         alignment: Alignment.center,
    //         child: Text(
    //           "$amount",
    //           style: subHeading_withBold,
    //         ),
    //       ),
    //       Text(
    //         "$title",
    //         style: item_heading_textStyle.copyWith(
    //           color: boxcolor,
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       FaIcon(
    //         FontAwesomeIcons.solidArrowAltCircleRight,
    //         color: boxcolor,
    //       )
    //     ],
    //   ),
    // );
  }
}

abstract class HomeFragmentInterface {}
class SalesData {
  final String day;
  final int sales;

  SalesData(this.day, this.sales);
}

class ExpenseData {
  final String category;
  final double amount;

  ExpenseData(this.category, this.amount);
}