import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class UserFragment extends StatefulWidget {
  final UserFragmentInterface mListener;
  const UserFragment({Key? key, required this.mListener}) : super(key: key);

  @override
  State<UserFragment> createState() => _UserFragmentState();
}


class _UserFragmentState extends State<UserFragment> {
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

abstract class UserFragmentInterface {
}