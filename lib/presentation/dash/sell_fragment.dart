import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class SellFragment extends StatefulWidget {
  const SellFragment({Key? key}) : super(key: key);

  @override
  State<SellFragment> createState() => _SellFragmentState();
}


class _SellFragmentState extends State<SellFragment> {
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
