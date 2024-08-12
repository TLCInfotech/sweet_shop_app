import 'package:flutter/material.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/getFranchisee.dart';


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
        title: ApplicationLocalizations.of(context)!.translate("franchisee")!,
        callback: (name,id){
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