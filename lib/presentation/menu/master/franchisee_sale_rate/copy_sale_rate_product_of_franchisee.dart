import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../../../core/colors.dart';
import '../../../../core/common_style.dart';
import '../../../../core/string_en.dart';
import '../../../dialog/franchisee_dialog.dart';


class CopySaleRateProductOfFranchisee extends StatefulWidget {
  final CopySaleRateProductOfFranchiseeInterface mListener;

  const CopySaleRateProductOfFranchisee({super.key, required this.mListener});

  @override
  State<CopySaleRateProductOfFranchisee> createState() => _CopySaleRateProductOfFranchiseeState();
}

class _CopySaleRateProductOfFranchiseeState extends State<CopySaleRateProductOfFranchisee> with FranchiseeDialogInterface {

  String selectedCopyFranchiseeName="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringEn.FRANCHISEE_NAME,
            style: page_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.screenHeight * .005),
            child: Container(
              height: SizeConfig.screenHeight * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child:  GestureDetector(
                onTap: (){
                  showGeneralDialog(
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionBuilder: (context, a1, a2, widget) {
                        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                        return Transform(
                          transform:
                          Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                          child: Opacity(
                            opacity: a1.value,
                            child:FranchiseeDialog(
                              mListener: this,
                            ),
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 200),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation2, animation1) {
                        throw Exception('No widget to return in pageBuilder');
                      });
                },
                onDoubleTap: (){},
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCopyFranchiseeName == "" ? StringEn.FRANCHISEE_NAME
                          : selectedCopyFranchiseeName,
                        style: selectedCopyFranchiseeName == ""
                            ? hint_textfield_Style
                            : text_field_textStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // textScaleFactor: 1.02,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: SizeConfig.screenHeight * .03,
                        color: /*pollName == ""
                                ? CommonColor.HINT_TEXT
                                :*/
                        CommonColor.BLACK_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedCopyFranchiseeName=name;
    });

    if(widget.mListener!=null){
      widget.mListener.selectedFranchiseeToCopySaleRateProduct(id,name);
    }

  }
}

abstract class CopySaleRateProductOfFranchiseeInterface{
  selectedFranchiseeToCopySaleRateProduct(String id,String name);
}