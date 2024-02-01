import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class PurchaseFragment extends StatefulWidget {
  const PurchaseFragment({Key? key}) : super(key: key);

  @override
  State<PurchaseFragment> createState() => _PurchaseFragmentState();
}


class _PurchaseFragmentState extends State<PurchaseFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child:  Container(
        height: SizeConfig.screenHeight*.88,
        child: Center(
          child: Text(
            "Coming Soon...",
            style:  TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 6,
                fontFamily: 'Inter_SemiBold_Font',
                color: CommonColor.BLACK_COLOR),
          ),
        ),
      ),
    ));
  }
}
