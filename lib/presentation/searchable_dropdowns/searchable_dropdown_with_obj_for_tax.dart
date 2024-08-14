import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
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

class SearchableDropdownWithObjectForTax extends StatefulWidget{
  final title;
  final name;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final status;
  final readOnly;
  SearchableDropdownWithObjectForTax({required this.title, required this.callback, required this.name,this.titleIndicator,required this.apiUrl,this.status, this.readOnly});




  @override
  State<SearchableDropdownWithObjectForTax> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithObjectForTax> with  SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetLedger();
    print("gggggg ${widget.status}");
    if(widget.status=="edit"){
      print(":::::: ${widget.name}");
      _controller.text=widget.name!=null?widget.name:"";
    }
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

  List<dynamic> ledger_list = [];

  var filteredStates = [];


  callGetLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + widget.apiUrl+"Company_ID=$companyId&${StringEn.lang}=$lang";
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
                      setState(() {
                        callGetLedger();
                      });
                    },
                    textInputAction: TextInputAction.none, // Change input action to "none"
                    controller: _controller,
                    enabled: widget.readOnly==false?false:true,
                    decoration: textfield_decoration.copyWith(
                      // labelText: '${widget.title}',
                        hintText: "${widget.title}",
                        border: OutlineInputBorder(),
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
                          (_controller.text == "" )
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
                      ),
                    ),
                  ),

                  suggestionsCallback: (pattern) {
                    return _getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['name']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      selectedItem = suggestion['name'];
                      _controller.text=suggestion['name'];
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

    matches.retainWhere((s) => s['name'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
