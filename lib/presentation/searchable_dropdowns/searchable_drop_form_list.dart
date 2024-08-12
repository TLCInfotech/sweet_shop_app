import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  dynamic unit;
  dynamic rate;
  dynamic gst;
  TestItem({required this.label, this.value,this.unit,this.rate,this.gst});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],unit:"${json['unit']}",rate:"${json['rate']}",gst:"${json['gst']}");
  }
}

class SearchableDropdownWithFormList extends StatefulWidget{
  final title;
  final name;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final status;
  final come;
  final insertedList;
  SearchableDropdownWithFormList({required this.title, required this.callback, required this.name,this.titleIndicator,this.come,required this.apiUrl,this.status,this.insertedList});

  @override
  State<SearchableDropdownWithFormList> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithFormList> with  SingleTickerProviderStateMixin {
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
    _speech = stt.SpeechToText();
  }
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            _controller.text = _text;
            setState(() => _isListening = false);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
        user["Form"]
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
          {'label': "${ele['Form']}", 'value': "${ele['Form_ID']}"}));
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

              if(widget.insertedList!=null||widget.insertedList!=[]){
                List ext=widget.insertedList;
                List l =(data).map((e) =>e['Form_ID'] ).toList();

                for(var el in l)
                {
                  var contains=ext.contains(el);
                  print(contains);
                  if(contains==false){
                    var index=l.indexOf(el);
                    print(data[index]);
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
  final FocusNode reqFocus=FocusNode();
  var selectedItem=null;
  var selected=null;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  enabled: widget.come=="disable"?false:true, // Change input action to "none"
                  focusNode: searchFocus,
                  controller: _controller,
                  decoration: textfield_decoration.copyWith(
                    // labelText: '${widget.title}',
                      hintText: "${widget.title}",
                      border: OutlineInputBorder(),
                    suffixIcon: widget.come=="disable"?null: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //(_controller.text != "")?Container():
                        IconButton(
                          onPressed: (){
                            setState(() {
                              searchFocus.requestFocus();
                              _listen();
                              if(_isListening==false){
                                _controller.clear();
                              }
                            });
                          },
                          icon: Icon(_isListening
                              ? Icons.mic
                              : Icons.mic_none),
                        ),
                        (_controller.text == "" ||
                            _controller.text == null)
                            ? const Icon(Icons.search)
                            : IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                            });
                            widget.callback("");
                            searchFocus.requestFocus();
                            _controller.text =
                                _controller.text; // Trigger a rebuild
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),                      ),
                ),

                suggestionsCallback: (pattern) {
                  return _getSuggestions(pattern);

                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['Form']),
                  );
                },
                validator: (value) {
                  print("kkjggkg   $value");
                  if (value!.isEmpty) {
                    return 'Please select a city';
                  }},
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    print("knjbnbnjbnbn2222  $suggestion  $selected");
                    selectedItem = suggestion['Form'];
                    selected=suggestion;
                    _controller.text=suggestion['Form'];
                  });
                  widget.callback(suggestion);
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

    matches.retainWhere((s) => s['Form'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }


  Future<bool> _onBackPressed() {
    return CommonWidget.showExitDialog(context, "", "1");
  }
}
