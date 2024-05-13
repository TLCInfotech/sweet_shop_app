import 'package:flutter/material.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common_style.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class AddOrEditUserRights extends StatefulWidget {
  final  mListener;
  final dynamic editproduct;
  final id;

  const AddOrEditUserRights(
      {super.key,
        required this.mListener,
        required this.editproduct,
        this.id,
       });

  @override
  State<AddOrEditUserRights> createState() => _AddOrEditUserRightsState();
}

class _AddOrEditUserRightsState extends State<AddOrEditUserRights> {
  bool isLoaderShow = false;
  var selectedItemID = null;
  var oldItemId = 0;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  getCompanyId() async {
    String companyId1 = await AppPreferences.getCompanyId();
    setState(() {
      companyId = companyId1;
      api =
      "${ApiConstants().salePartyItem}?Company_ID=$companyId1&PartyID=${widget.id}";
    });
    print("CompanyID=> $companyId");
  }

  var companyId = "0";
  var selectedItemName = "";
  var api = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal() async {
    if (widget.editproduct != null) {
      setState(() {
        selectedItemID = widget.editproduct['Item_ID'] != null
            ? widget.editproduct['Item_ID']
            : null;
        selectedItemName = widget.editproduct['Item_Name'] != null
            ? widget.editproduct['Item_Name']
            : null;
      });
    }
    // await fetchItems();
    // await getCompanyId();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .05,
                right: SizeConfig.screenWidth * .05),
            child: Container(
              height: SizeConfig.screenHeight * 0.6,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * .08,
                      child: Center(
                        child: Text(
                            ApplicationLocalizations.of(context)!
                                .translate("user_right")!,
                            style: page_heading_textStyle),
                      ),
                    ),
                    getFieldTitleLayout(ApplicationLocalizations.of(context)!
                        .translate("user_name")!),
                    getAddSearchLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    SizedBox(
                      height: 5,
                    ),
                    getFieldTitleLayout(ApplicationLocalizations.of(context)!
                        .translate("user_right")!),
                    getInserUpdateDeleteCheckboxTile(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .05,
                right: SizeConfig.screenWidth * .05),
            child: getAddForButtonsLayout(
                SizeConfig.screenHeight, SizeConfig.screenWidth),
          ),
        ],
      ),
    );
  }
  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 5,
      ),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }

  //franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    print("sadas ${selectedItemName}");
    return SearchableDropdownWithObject(
      name: selectedItemName,
      status: "edit",
      apiUrl: "${ApiConstants().purchasePartyItem}?PartyID=${widget.id}&Date=2024-05-09&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item) async {
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['ID'].toString();
          selectedItemName = item['Name'].toString();

        });
      },
    );

    //   Container(
    //     height: parentHeight * .055,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: CommonColor.WHITE_COLOR,
    //       borderRadius: BorderRadius.circular(4),
    //       boxShadow: [
    //         BoxShadow(
    //           offset: Offset(0, 1),
    //           blurRadius: 5,
    //           color: Colors.black.withOpacity(0.1),
    //         ),
    //       ],
    //     ),
    //     child: TextFieldSearch(
    //       minStringLength: 0,
    //         label: 'Item',
    //         controller: _textController,
    //         decoration: textfield_decoration.copyWith(
    //           hintText: ApplicationLocalizations.of(context)!.translate("item_name")!,
    //           prefixIcon: Container(
    //               width: 50,
    //               padding: EdgeInsets.all(10),
    //               alignment: Alignment.centerLeft,
    //               child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
    //         ),
    //         textStyle: item_regular_textStyle,
    //         getSelectedValue: (v) {
    //           setState(() {
    //             selectedItemID = v.value;
    //             unit.text=v.unit;
    //             rate.text=v.rate;
    //             itemsList = [];
    //             gst.text=v.gst!="null"?v.gst:"";
    //           });
    //           calculateRates();
    //         },
    //         future: () {
    //           if (_textController.text != "")
    //             return fetchSimpleData(
    //                 _textController.text.trim());
    //         })
    //
    // );
  }

  Widget getInserUpdateDeleteCheckboxTile(){
    return Column(
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ) ,

          tileColor: Colors.transparent,
          value: true,
          onChanged: (bool? value) {

          },
          title:  Text("Insert", style: item_heading_textStyle),
        ),

         CheckboxListTile(

           contentPadding: EdgeInsets.all(0),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
           ) ,

           tileColor: Colors.transparent,
           value: true,
           onChanged: (bool? value) {

           },
           title:  Text("Update", style: item_heading_textStyle),
         ),

         CheckboxListTile(

           contentPadding: EdgeInsets.all(0),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
           ) ,

           tileColor: Colors.transparent,
           value: true,
           onChanged: (bool? value) {

           },
           title:  Text("Delete", style: item_heading_textStyle),
         ),

      ],
    );
  }


  /* Widget for Buttons Layout */
  Widget getAddForButtonsLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .45,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("close")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            var item = {};
            if (widget.editproduct != null) {
              item = {
                "New_Item_ID": selectedItemID,
                "Seq_No": widget.editproduct != null
                    ? widget.editproduct['Seq_No']
                    : null,
                "Item_ID": widget.editproduct != null
                    ? widget.editproduct['Item_ID']
                    : "",
                "Item_Name": selectedItemName,
              };
            } else {
              item = {
                "Item_ID": selectedItemID,
                "Item_Name": selectedItemName,
                "Seq_No": widget.editproduct != null
                    ? widget.editproduct['Seq_No']
                    : null,
              };
            }

            if (widget.mListener != null) {
              widget.mListener.AddOrEditUserScreenRightDetail(item);
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .45,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
abstract class AddOrEditUserScreenRightInterface {
  AddOrEditUserScreenRightDetail(dynamic item);
}
