import 'package:flutter/material.dart';

import '../../../core/common_style.dart';
import '../../../core/localss/application_localizations.dart';
import '../../../core/size_config.dart';

class PurchaseDashActivity extends StatefulWidget {
  const PurchaseDashActivity({Key? key}) : super(key: key);

  @override
  State<PurchaseDashActivity> createState() => _PurchaseDashActivityState();
}

class _PurchaseDashActivityState extends State<PurchaseDashActivity> {
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
            margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: AppBar(
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              leading: Container(),
              title:  Container(
                width: SizeConfig.screenWidth,
                child: Center(
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("purchase")!,
                    style: appbar_text_style,),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
              backgroundColor: Colors.white,

            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFfffff5),
      body: Container(

      ),
    );
  }



}
