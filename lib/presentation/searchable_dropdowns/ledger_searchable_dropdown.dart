import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';


class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}

class SearchableLedgerDropdown extends StatefulWidget {
  final  title;
  final  ledgerName;
  final Function(String?, String?) callback;
  final  titleIndicator;
  final  apiUrl;
  final  franchisee;
  final  franchiseeName;
  final  suffixicon;
  final  readOnly;
  final  focuscontroller;
  final  txtkey;
  final  focusnext;
  final  mandatory;

  SearchableLedgerDropdown({
     this.title,
     required this.callback,
     this.ledgerName,
    this.titleIndicator = true,
     this.apiUrl,
     this.franchisee,
     this.franchiseeName,
     this.suffixicon,
    this.readOnly = true,
     this.focuscontroller,
     this.txtkey,
     this.focusnext,
    this.mandatory = false,
  });

  @override
  State<SearchableLedgerDropdown> createState() =>
      _SearchableLedgerDropdownState();
}

class _SearchableLedgerDropdownState extends State<SearchableLedgerDropdown>
    with SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  FocusNode searchFocus = FocusNode();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  final TextEditingController _controller = TextEditingController();
  var selectedItem;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    setdata();
    searchFocus.addListener(_onFocusChange);
    _speech = stt.SpeechToText();
  }

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

  void _onFocusChange() {
    if (!searchFocus.hasFocus) {
      if (selectedItem == null) {
        FocusManager.instance.primaryFocus?.unfocus();
        _controller.clear();
        var snackBar = const SnackBar(content: Text("No item available!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  void dispose() {
    searchFocus.removeListener(_onFocusChange);
    searchFocus.dispose();
    _speech.stop();
    super.dispose();
  }

  setdata() async {
    await callGetLedger();
    if (widget.franchisee == "edit") {
      _controller.text =
      widget.franchiseeName != null ? widget.franchiseeName : "";
    }
  }

  List<dynamic> ledger_list = [];
  var filteredStates = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.titleIndicator != false
          ? EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02)
          : EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator != false
              ? widget.mandatory == true
              ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.title,
                  style: item_heading_textStyle,
                ),
                TextSpan(
                  text: "*",
                  style: item_heading_textStyle.copyWith(
                      color: Colors.red),
                ),
              ],
            ),
          )
              : Text(
            widget.title,
            style: item_heading_textStyle,
          )
              : Container(),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child: Container(
              height: SizeConfig.screenHeight * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: TypeAheadFormField(
                key: widget.txtkey,
                getImmediateSuggestions: true,
                textFieldConfiguration: TextFieldConfiguration(
                  onChanged: (v) async {
                    if (v.isEmpty) {
                      setState(() {
                        selectedItem = null;
                      });
                      await widget.callback(null, null);
                    }
                  },
                  onSubmitted: (v) {
                    if (_controller.text.replaceAll(" ", "").length !=
                        widget.ledgerName
                            .toString()
                            .replaceAll(" ", "")
                            .length) {
                      setState(() {
                        _controller.clear();
                      });
                      widget.callback("", "");
                      searchFocus.unfocus();
                    }
                  },
                  onEditingComplete: () {
                    if (_controller.text.replaceAll(" ", "").length !=
                        widget.ledgerName
                            .toString()
                            .replaceAll(" ", "")
                            .length) {
                      setState(() {
                        _controller.clear();
                      });
                      widget.callback("", "");
                      searchFocus.unfocus();
                    }
                  },
                  onTap: () {
                    setState(() {
                      callGetLedger();
                    });
                  },
                  textInputAction: TextInputAction.none,
                  controller: _controller,
                  enabled: widget.readOnly == false ? false : true,
                  focusNode: searchFocus,
                  decoration: textfield_decoration.copyWith(
                    hintText: "${widget.title}",
                    border: const OutlineInputBorder(),
                    suffixIcon:  Row(
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
                            widget.callback("", "");
                            searchFocus.requestFocus();
                            _controller.text =
                                _controller.text; // Trigger a rebuild
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16.0,
                      height: 0,
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.redAccent, width: 2.0),
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
                  if (value!.isEmpty) {
                    return '';
                  }
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    selectedItem = suggestion['Name'];
                    _controller.text = suggestion['Name'];
                  });
                  widget.callback(
                      suggestion['Name'], (suggestion['ID']).toString());
                  if (widget.focuscontroller != null) {
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
    results = filteredStates
        .where((user) => user["Name"]
        .toLowerCase()
        .contains(searchstring.toLowerCase()))
        .toList();
    setState(() {
      ledger_list = results;
    });
    for (var ele in ledger_list) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }

  callGetLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl = await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow = true;
      });
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + widget.apiUrl + "Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess: (data) {
            isLoaderShow = false;
            if (data != null) {
              setState(() {
                ledger_list = data;
                filteredStates = ledger_list;
              });
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);
          }, sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
          });
    });
  }

  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);
    matches.retainWhere(
            (s) => s['Name'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
