import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return GestureDetector(
      onTap: () async{
        showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                  1.0;
              return Transform(
                transform:
                Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                child: Opacity(
                  opacity: a1.value,
                  child: FranchiseeDialog(
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
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedCopyFranchiseeName == "" ? StringEn.FRANCHISEE_NAME : selectedCopyFranchiseeName,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
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