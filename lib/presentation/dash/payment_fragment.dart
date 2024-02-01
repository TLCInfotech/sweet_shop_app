import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class PaymentFragment extends StatefulWidget {
  const PaymentFragment({Key? key}) : super(key: key);

  @override
  State<PaymentFragment> createState() => _PaymentFragmentState();
}


class _PaymentFragmentState extends State<PaymentFragment> {
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
