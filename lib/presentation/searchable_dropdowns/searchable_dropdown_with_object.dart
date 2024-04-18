import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/ledger_dialog.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/string_en.dart';
import '../../data/api/constant.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/commonRequest/get_toakn_request.dart';
import '../dialog/franchisee_dialog.dart';

class TestItem {
  String label;
  dynamic value;
  dynamic unit;
  dynamic rate;
  dynamic gst;
  TestItem({required this.label, this.value,this.unit,this.rate,this.gst});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],unit:"${json['unit']}",rate:"${json['rate']}",gst:"${json['gst']}");
  }
}

class SearchableDropdownWithObject extends StatefulWidget{
  final title;
  final ledgerName;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  SearchableDropdownWithObject({required this.title, required this.callback, required this.ledgerName,this.titleIndicator,required this.apiUrl});




  @override
  State<SearchableDropdownWithObject> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithObject> with  SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetLedger();
  }
  List<dynamic> ledger_list = [];

  var filteredStates = [];

  Future<List> fetchSimpleData(searchstring) async {
    List<dynamic> _list = [];
    List<dynamic> results = [];
    // if (searchstring.isEmpty) {
    //   // if the search field is empty or only contains white-space, we'll display all users
    //   results = filteredStates;
    // } else {

    results = filteredStates
        .where((user) =>
        user["Name"]
            .toLowerCase()
            .contains(searchstring.toLowerCase()))
        .toList();
    // we use the toLowerCase() method to make it case-insensitive
    // }

    // Refresh the UI
    setState(() {
      ledger_list = results;
    });

    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in ledger_list) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }

  callGetLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + widget.apiUrl+"Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            isLoaderShow=false;
            if(data!=null) {
              setState(() {
                ledger_list = data;
                filteredStates=ledger_list;
              });
              print("  LedgerLedger  $data ");
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);

            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });

    });
  }

  final TextEditingController _controller = TextEditingController();

  var selectedItem=null;

  @override
  Widget build(BuildContext context) {
    return

      Padding(
        padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleIndicator!=false? Text(
              widget.title,
              style: item_heading_textStyle,
            ):Container(),
            Padding(
              padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
              child:  Container(
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
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    onTap: (){
                      // _controller.clear();
                    },
                    textInputAction: TextInputAction.none, // Change input action to "none"
                    controller: _controller,
                    decoration: textfield_decoration.copyWith(
                      // labelText: '${widget.title}',
                        hintText: "${widget.title}",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search)
                    ),
                  ),

                  suggestionsCallback: (pattern) {
                    return _getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['Name']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      selectedItem = suggestion['Name'];
                      _controller.text=suggestion['Name'];
                    });
                    widget.callback(suggestion);
                  },
                ),
              ),

              // Container(
              //     height: SizeConfig.screenHeight * .055,
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
              //         initialList: filteredStates,
              //         minStringLength: 0,
              //         label: 'Ledger',
              //         controller: _textController,
              //         decoration: textfield_decoration.copyWith(
              //           hintText:widget.title,
              //           prefixIcon: Container(
              //               width: 50,
              //               padding: EdgeInsets.all(10),
              //               alignment: Alignment.centerLeft,
              //               child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
              //         ),
              //         textStyle: item_regular_textStyle,
              //         getSelectedValue: (v)async {
              //           await widget.callback(v.label,v.value);
              //           setState(() {
              //             ledger_list=[];
              //           });
              //
              //         },
              //         future: () {
              //           // if (_textController.text != "")
              //             return
              //               fetchSimpleData(
              //                 _textController.text.trim());
              //         })
              //
              // ),
            )
          ],
        ),
      );
  }
  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    matches.retainWhere((s) => s['Name'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
