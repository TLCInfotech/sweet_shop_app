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

class SearchableDropdownWithExistingList extends StatefulWidget{
  final title;
  final name;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final status;
  final come;
  final insertedList;
  final focuscontroller;
  final txtkey;
  final focusnext;
  final mandatory;
  SearchableDropdownWithExistingList({required this.title, required this.callback, required this.name,this.titleIndicator,this.come,required this.apiUrl,this.status,this.insertedList,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory});

  @override
  State<SearchableDropdownWithExistingList> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithExistingList> with  SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetLedger();
    print("gggggg ${widget.status}");
    if(widget.status=="edit"){
      print(":::::: ${widget.name}");
      _controller.text=widget.name;
    }
    else{
      _controller.clear();
      setState(() {
        selected=null;
      });
    }
    searchFocus.addListener(_onFocusChange);
  }
  FocusNode searchFocus = FocusNode() ;
  void _onFocusChange() {
    if (!searchFocus.hasFocus) {
      if(selected==null){
        FocusManager.instance.primaryFocus?.unfocus();
        _controller.clear();
        var snackBar=SnackBar(content: Text("No item available !"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  @override
  void dispose() {
    searchFocus.removeListener(_onFocusChange);
    searchFocus.dispose();
    super.dispose();
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
            ledger_list=[];
            if(data!=null) {

              print(" FFFFFFFFFFFFFF ${data.length}");
              if(widget.insertedList!=null||widget.insertedList!=[]){
                List ext=widget.insertedList;
                List l =(data).map((e) =>e['Name'] ).toList();

                for(var el in l)
                {
                  var contains=ext.contains(el);
                  if(contains==false){
                    var index=l.indexOf(el);

                    ledger_list.add(data[index]);
                  }
                }
                setState(() {
                  ledger_list = ledger_list;
                  filteredStates=ledger_list;
                });
              }
              else {
                setState(() {
                  ledger_list = data;
                  filteredStates = ledger_list;
                });
              }

              print(" FFFFFFFFFFFFFF ${ledger_list.length} ${filteredStates.length}");

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
  final FocusNode reqFocus=FocusNode();
  var selectedItem=null;
  var selected=null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.0):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator!=false? widget.mandatory==true?
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text:widget.title,style: item_heading_textStyle,),
                TextSpan(text:"*",style: item_heading_textStyle.copyWith(color: Colors.red),),
              ],
            ),
          )
              : Text(
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
                key: widget.txtkey,
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: (){
                    setState(() {
                      callGetLedger();
                    });
                  },
                  onChanged: (v)async{
                    if(v.isEmpty) {
                      setState(() {
                        selected=null;
                        print("knjbnbnjbnbn  $v");
                      });
                      await widget.callback(selected);
                    }
                  },
                  textInputAction: TextInputAction.none,
                //  enabled: widget.come=="disable"?false:true, // Change input action to "none"
                  focusNode: searchFocus,
                  controller: _controller,
                  decoration: textfield_decoration.copyWith(
                    // labelText: '${widget.title}',
                      hintText: "${widget.title}",
                      border: OutlineInputBorder(),
                      suffixIcon: _controller.text=="" ?Icon(Icons.search):IconButton(onPressed: (){
    setState(() {
    _controller.clear();
    });
    widget.callback("");
    }, icon: Icon(Icons.clear)),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16.0,
                      height: 0
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    ),
                  ),
                ),

                suggestionsCallback: (pattern)async  {
                  return await _getSuggestions(pattern);

                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['Name']),
                  );
                },
                validator: (value) {
                  print("kkjggkg   $value");
                  if (value!.isEmpty) {
                    return '';
                  }

                  },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    selectedItem = suggestion['Name'];
                    selected=suggestion;
                    _controller.text=suggestion['Name'];
                  });
                  widget.callback(suggestion);
                  widget.focuscontroller.unfocus();
                  FocusScope.of(context).requestFocus(widget.focusnext);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    // matches.retainWhere((s) => s['Name'].toLowerCase().contains(query.toLowerCase()));
    print(matches
        .where((s) => s['Name'].toLowerCase().contains(query.toLowerCase()))
        .toList());
    // return matches;
    return matches
        .where((s) => s['Name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  Future<bool> _onBackPressed() {
    return CommonWidget.showExitDialog(context, "", "1");
  }
}
