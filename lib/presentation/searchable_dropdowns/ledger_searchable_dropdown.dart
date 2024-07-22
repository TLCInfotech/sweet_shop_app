import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/commonRequest/get_toakn_request.dart';

class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}

class SearchableLedgerDropdown extends StatefulWidget{
  final title;
  final ledgerName;
  final Function(String?,String?) callback;
  final titleIndicator;
  final apiUrl;
  final franchisee;
  final come;
  final franchiseeName;
  final suffixicon;
  final readOnly;
  final focuscontroller;
  final txtkey;
  final focusnext;
  final mandatory;
  SearchableLedgerDropdown({required this.title, required this.callback, required this.ledgerName,this.titleIndicator,required this.apiUrl, this.franchisee, this.franchiseeName, this.come,this.suffixicon, this.readOnly,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory});




  @override
  State<SearchableLedgerDropdown> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableLedgerDropdown> with  SingleTickerProviderStateMixin {


  bool isLoaderShow = false;
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  final TextEditingController _controller = TextEditingController();

  var selectedItem=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
    // searchFocus.addListener(() {
    //   if (!searchFocus.hasFocus) {
    //     // Clear text when the field loses focus
    //     _controller.clear();
    //   }
    // });
    searchFocus.addListener(_onFocusChange);  
  }

  void _onFocusChange() {
    if (!searchFocus.hasFocus) {
      if(selectedItem==null){
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
  setdata()async{
    await callGetLedger();
    if(widget.franchisee=="edit"){
      print(":::::: ${widget.franchiseeName}\n ${widget.ledgerName}");
      _controller.text=widget.franchiseeName!=null?widget.franchiseeName:"";
    }
  }
  List<dynamic> ledger_list = [];

  var filteredStates = [];

  @override
  Widget build(BuildContext context) {
    return

      Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
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
              child:    TypeAheadFormField(
                key: widget.txtkey,
                getImmediateSuggestions: true,
                textFieldConfiguration: TextFieldConfiguration(

                  onChanged: (v)async{
                    if(v.isEmpty) {
                      setState(() {
                        selectedItem=null;
                        print("knjbnbnjbnbn  $v");
                      });
                      await widget.callback(null,null);
                    }
                  },
                  onSubmitted: (v){
                    if(_controller.text.replaceAll(" ", "").length!=widget.ledgerName.toString().replaceAll(" ", "").length){
                      setState(() {
                        _controller.clear();
                      });
                      widget.callback("","");
                      searchFocus.unfocus();
                    }},
                  onTapOutside: (event) {
                 },
                  onEditingComplete: () {
                    print("onchangedddddd2222  ");
                    if(_controller.text.replaceAll(" ", "").length!=widget.ledgerName.toString().replaceAll(" ", "").length){
                      setState(() {
                        _controller.clear();
                      });
                      widget.callback("","");
                      searchFocus.unfocus();
                    }
                  },
                  onTap: (){
                   // _controller.clear();
                    setState(() {
                      callGetLedger();
                    });
                  },
                  textInputAction: TextInputAction.none, // Change input action to "none"
                  controller: _controller,
                  //enabled: widget.come=="disable"?false:true,
                  enabled: widget.readOnly==false?false:true,
                  focusNode: searchFocus,
                  decoration: textfield_decoration.copyWith(
                    // labelText: '${widget.title}',
                    hintText: "${widget.title}",
                    border: OutlineInputBorder(),
                    suffixIcon: widget.come=="disable"?null: (_controller.text=="" || _controller.text==null)?Icon(Icons.search):IconButton(onPressed: (){
                      setState(() {
                        _controller.clear();
                      });
                      widget.callback("","");
                      searchFocus.requestFocus();
                      // Optionally, trigger the suggestion box to show manually
                      _controller.text = _controller.text; // Trigger a rebuild
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
                suggestionsCallback: (pattern) {
                  return _getSuggestions(pattern);
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
                    _controller.text=suggestion['Name'];
                  });
                  widget.callback(suggestion['Name'],(suggestion['ID']).toString());
                  if(widget.focuscontroller!=null) {
                    widget.focuscontroller.unfocus();
                    FocusScope.of(context).requestFocus(widget.focusnext);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }


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
              print("  LedgerLedgersearrr  $data ");
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



  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    matches.retainWhere((s) => s['Name'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
