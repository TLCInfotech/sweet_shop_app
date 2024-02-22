import 'package:flutter/material.dart';
import '../../../../core/string_en.dart';
import '../../../common_widget/getFranchisee.dart';


class CopySaleRateProductOfFranchisee extends StatefulWidget {
  final CopySaleRateProductOfFranchiseeInterface mListener;

  const CopySaleRateProductOfFranchisee({super.key, required this.mListener});

  @override
  State<CopySaleRateProductOfFranchisee> createState() => _CopySaleRateProductOfFranchiseeState();
}

class _CopySaleRateProductOfFranchiseeState extends State<CopySaleRateProductOfFranchisee>  {


  String selectedCopyFranchiseeName="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetFranchiseeLayout(
        title:  StringEn.FRANCHISE,
        callback: (name){
          setState(() {
            selectedCopyFranchiseeName=name!;
          });
          if(widget.mListener!=null){
            widget.mListener.selectedFranchiseeToCopySaleRateProduct("1",name!);
          }

        },
        franchiseeName: selectedCopyFranchiseeName);

  }

}

abstract class CopySaleRateProductOfFranchiseeInterface{
  selectedFranchiseeToCopySaleRateProduct(String id,String name);
}