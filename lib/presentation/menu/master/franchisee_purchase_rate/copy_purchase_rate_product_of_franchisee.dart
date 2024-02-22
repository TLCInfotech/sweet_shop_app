import 'package:flutter/material.dart';
import '../../../../core/string_en.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../dialog/franchisee_dialog.dart';


class CopyPurchaseRateProductOfFranchisee extends StatefulWidget {
  final CopyPurchaseRateProductOfFranchiseeInterface mListener;

  const CopyPurchaseRateProductOfFranchisee({super.key, required this.mListener});

  @override
  State<CopyPurchaseRateProductOfFranchisee> createState() => _CopyPurchaseRateProductOfFranchiseeState();
}

class _CopyPurchaseRateProductOfFranchiseeState extends State<CopyPurchaseRateProductOfFranchisee> {

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
          widget.mListener.selectedFranchiseeToCopyPurchaseRateProduct("1",name!);
        },
        franchiseeName: selectedCopyFranchiseeName);
  }

}

abstract class CopyPurchaseRateProductOfFranchiseeInterface{
  selectedFranchiseeToCopyPurchaseRateProduct(String id,String name);
}