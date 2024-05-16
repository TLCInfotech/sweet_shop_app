import 'package:flutter/material.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/searchable_drop_form_list.dart';

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
bool updateV=true;
bool deleteV=true;
bool insertV=true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal() async {
    if (widget.editproduct != null) {
      setState(() {
        insertV=widget.editproduct['Insert_Right'];
        updateV=widget.editproduct['Update_Right'];
        deleteV=widget.editproduct['Delete_Right'];
        print("vbvnvbnvbnvbn   $insertV");
        selectedItemID = widget.editproduct['Form_ID'] != null
            ? widget.editproduct['Form_ID']
            : null;
        selectedItemName = widget.editproduct['Form'] != null
            ? widget.editproduct['Form']
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
                          "Screen Right",
                            style: page_heading_textStyle),
                      ),
                    ),
                    getFieldTitleLayout("Screen Name"),
                    getAddSearchLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    SizedBox(
                      height: 5,
                    ),
                    // getFieldTitleLayout(ApplicationLocalizations.of(context)!
                    //     .translate("user_right")!),
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
    return SearchableDropdownWithFormList(
      name: selectedItemName,
      come: widget.editproduct!=null?"disable":"",
      status: "edit",
      apiUrl:"${ApiConstants().formList}?",
      titleIndicator: false,
      title:"Screen Name",
      callback: (item) async {
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['Form_ID'].toString();
          selectedItemName = item['Form'].toString();

        });
      },
    );
  }

  Widget getInserUpdateDeleteCheckboxTile(){
    return Column(
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ) ,

          tileColor: Colors.transparent,
          value: insertV,
          onChanged: (bool? value) {
setState(() {
  insertV=!insertV;
});
          },
          title:  Text("Insert", style: item_heading_textStyle),
        ),

         CheckboxListTile(
           controlAffinity: ListTileControlAffinity.leading,
           contentPadding: EdgeInsets.all(0),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
           ) ,

           tileColor: Colors.transparent,
           value: updateV,
           onChanged: (bool? value) {
setState(() {
  updateV=!updateV;
});
           },
           title:  Text("Update", style: item_heading_textStyle),
         ),

         CheckboxListTile(
           controlAffinity: ListTileControlAffinity.leading,
           contentPadding: EdgeInsets.all(0),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
           ) ,

           tileColor: Colors.transparent,
           value: deleteV,
           onChanged: (bool? value) {
           setState(() {
             deleteV=!deleteV;
             print("kjjkfjfd $deleteV");
           });
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
                "Form": selectedItemName,
                "Form_ID": widget.editproduct != null
                    ? widget.editproduct['Form_ID']
                    : "",
                "Insert_Right": insertV,
                "Update_Right": updateV,
                "Delete_Right": deleteV,
              };
            } else {
              item = {
                "Form_ID": selectedItemID,
                "Form": selectedItemName,
                "Insert_Right": insertV,
                "Update_Right": updateV,
                "Delete_Right": deleteV,

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
