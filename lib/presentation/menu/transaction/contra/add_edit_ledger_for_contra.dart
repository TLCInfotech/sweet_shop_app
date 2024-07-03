import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}

class AddOrEditLedgerForContra extends StatefulWidget {
  final AddOrEditLedgerForContraInterface mListener;
  final dynamic editproduct;
  final newDate;
  final franId;
  final come;
  final debitNote;
  final companyId;
  final readOnly;
  final existingList;
  const AddOrEditLedgerForContra(
      {super.key,
      required this.mListener,
      required this.editproduct,
      this.newDate,
      this.franId,
      this.come,
      this.debitNote,
      this.companyId,
      this.readOnly, this.existingList});
  @override
  State<AddOrEditLedgerForContra> createState() =>
      _AddOrEditLedgerForContraState();
}

class _AddOrEditLedgerForContraState extends State<AddOrEditLedgerForContra> {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode ledgerFocus = FocusNode();
  final _ledgerKey = GlobalKey<FormFieldState>();

  TextEditingController amount = TextEditingController();
  FocusNode amountFocus = FocusNode();
  final _amountKey = GlobalKey<FormFieldState>();

  TextEditingController narration = TextEditingController();
  FocusNode narrationFocus = FocusNode();

  FocusNode searchFocus = FocusNode();

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var itemsList = [];
  var selectedItemID = null;
  var oldItemId = 0;
  var filteredItemsList = [];

  fetchShows() async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = ApiConstants().baseUrl +
          ApiConstants().getBankCashLedger +
          "?Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess: (data) async {
        if (data != null) {
          var topShowsJson = (data) as List;
          setState(() {
            itemsList = topShowsJson.map((show) => (show)).toList();
            filteredItemsList = topShowsJson.map((show) => (show)).toList();
          });
        }
      }, onFailure: (error) {
        CommonWidget.errorDialog(context, error);
        return [];
      }, onException: (e) {
        CommonWidget.errorDialog(context, e);
        return [];
      }, sessionExpire: (e) {
        CommonWidget.gotoLoginScreen(context);
        return [];
        // widget.mListener.loaderShow(false);
      });
    });
  }

  Future<List> fetchSimpleData(searchstring) async {
    print(searchstring);
    List<dynamic> _list = [];
    List<dynamic> results = [];
    if (searchstring.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = filteredItemsList;
    } else {
      results = filteredItemsList
          .where((user) =>
              user["Name"].toLowerCase().contains(searchstring.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      itemsList = results;
    });

    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in itemsList) {
      _list.add(TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal() async {
    print(widget.editproduct);
    if (widget.editproduct != null) {
      setState(() {
        selectedItemID = widget.editproduct['Ledger_ID'] != null
            ? widget.editproduct['Ledger_ID']
            : null;
        selectedbankCashLedger = widget.editproduct['Ledger_Name'];
        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
        narration.text=widget.editproduct['Remark']!=null && widget.editproduct['Remark']!=""?widget.editproduct['Remark'].toString():narration.text;

      });
      print(oldItemId);
    }
    await fetchShows();
  }

/*  setVal(){
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['ledgerName'];
        amount.text=widget.editproduct['amount'].toString();
        narration.text=widget.editproduct['narration'].toString();
      });
    }
  }*/

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
              height: SizeConfig.screenHeight * 0.7,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * .08,
                    child: Center(
                      child: Text(
                          ApplicationLocalizations.of(context)!
                              .translate("add_ledger")!,
                          style: page_heading_textStyle),
                    ),
                  ),
                  // getFieldTitleLayout(ApplicationLocalizations.of(context)!
                  //     .translate("ledger_name")!),
                  getAddSearchLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth),
                  getILedgerAmountyLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth),
                  getLedgerNarrationLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth),

                  /*   SizedBox(height: 20,),
                  getButtonLayout()*/
                ],
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

  /* widget for product gst layout */
  Widget getLedgerNarrationLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: narration,
      focuscontroller: narrationFocus,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("narration")!,
      callbackOnchage: (value) async {
        setState(() {
          amount.text = amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
          narration.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z ]')),
    );
  }

  /* widget for product rate layout */
  Widget getILedgerAmountyLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: true,
        txtkey: _amountKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      readOnly: widget.readOnly,
        controller: amount,
        focuscontroller: amountFocus,
        focusnext: narrationFocus,
      title: ApplicationLocalizations.of(context)!.translate("amount")!,
      callbackOnchage: (value) async {
        setState(() {
          amount.text = value;
        });
        _amountKey.currentState!.validate();
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );
  }

  var selectedbankCashLedger = "";
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    return
      SearchableDropdownWithObject(
        mandatory: true,
        txtkey: _ledgerKey,
        focusnext: amountFocus,
        focuscontroller: ledgerFocus,
        name: selectedbankCashLedger,
        status:  "edit",
        apiUrl:ApiConstants().getBankCashLedger + "?Company_ID=${widget.companyId}",
        titleIndicator: true,
        title: ApplicationLocalizations.of(context)!.translate("ledger")!,
        callback: (item)async{
          // print("FFFFFFFFFFFF ${widget.exstingList}");
          //
          // List l=widget.exstingList;
          // List n= await l.map((i) => i['Ledger_ID'].toString()).toList();
          // print("FFFFFFFFFFFF ${n.contains(item['ID'].toString())}");
          // if(n.contains(item['ID'].toString())){
          //   CommonWidget.errorDialog(context, "Already Exist!");
          // }
          // else {
          setState(() {
            // selectedbankCashLedger = name!;
            // selectedItemID = id;
            selectedItemID = item['ID'].toString();
            selectedbankCashLedger=item['Name'].toString();
          });
          // }
          setState(() {
            amount.text = amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
          });
          _ledgerKey.currentState!.validate();
        },

      );

    //   SearchableLedgerDropdown(
    //   mandatory: true,
    //   txtkey: _ledgerKey,
    //   focusnext: amountFocus,
    //   focuscontroller: ledgerFocus,
    //   apiUrl: ApiConstants().getBankCashLedger + "?Company_ID=${widget.companyId}",
    //   titleIndicator: true,
    //   ledgerName: selectedbankCashLedger,
    //   franchisee: widget.come,
    //   franchiseeName: widget.come == "edit" ? selectedbankCashLedger : "",
    //   title: ApplicationLocalizations.of(context)!.translate("party")!,
    //   callback: (name, id) async{
    //     print("FFFFFFFFFFFF ${widget.existingList}");
    //
    //     // List l=widget.existingList;
    //     // List n= await l.map((i) => i['Ledger_ID'].toString()).toList();
    //     // print("FFFFFFFFFFFF ${n.contains(id.toString())}");
    //     // if(n.contains(id.toString())){
    //     //   CommonWidget.errorDialog(context, "Already Exist!");
    //     // }
    //     // else {
    //       setState(() {
    //         if (widget.franId == id) {
    //           selectedbankCashLedger = "";
    //           CommonWidget.errorDialog(
    //               context, "You can not select same ledger.");
    //         } else {
    //           selectedbankCashLedger = name!;
    //           selectedItemID = id;
    //         }
    //       });
    //     // }
    //     setState(() {
    //       amount.text = amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
    //     });
    //
    //   },
    // );





    /*Container(
        height: parentHeight * .055,
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
        child: TextFieldSearch(
            label: 'Item',
            controller: _textController,
            decoration: textfield_decoration.copyWith(
              hintText: ApplicationLocalizations.of(context)!.translate("ledger_name")!,
              prefixIcon: Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
            ),
            textStyle: item_regular_textStyle,
            getSelectedValue: (v) {
              setState(() {

                if(widget.franId==v.value){
                  _textController.clear();
                  CommonWidget.errorDialog(context, "You can not select same ledger.");
                }
                else{
                  setState(() {
                    selectedItemID = v.value;
                  });
                }
                print("newwww  ${widget.franId}   $selectedItemID");
                itemsList = [];
              });
            },
            minStringLength: 0,
            future: () {
              if (_textController.text != "")
                return fetchSimpleData(
                    _textController.text.trim());
            })
    );*/
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }

  /* Widget for Buttons Layout0 */
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
            bool v=_ledgerKey.currentState!.validate();
            bool q=_amountKey.currentState!.validate();
            if(selectedItemID!=null && v && q)  {
              var item = {};
              if (widget.editproduct != null) {
                if(widget.editproduct['Seq_No']!=null) {
                  item = {
                    "New_Ledger_ID": selectedItemID,
                    "Ledger_Name": selectedbankCashLedger,
                    "Seq_No": widget.editproduct != null
                        ? widget.editproduct['Seq_No']
                        : null,
                    "Ledger_ID": widget.editproduct['Ledger_ID'],
                    "Amount": amount.text != "" ? double.parse(
                        double.parse(amount.text).toStringAsFixed(2)) : null,
                    "Remark": narration.text != "" ? narration.text : null,
                    "Date": widget.newDate,

                  };
                }
                else{
                  item = {
                    "New_Ledger_ID": selectedItemID,
                    "Ledger_Name": selectedbankCashLedger,
                    "Seq_No": widget.editproduct != null
                        ? widget.editproduct['Seq_No']
                        : null,
                    "Ledger_ID":selectedItemID,
                    "Amount": amount.text != "" ? double.parse(
                        double.parse(amount.text).toStringAsFixed(2)) : null,
                    "Remark": narration.text != "" ? narration.text : null,
                    "Date": widget.newDate,

                  };
                }
              } else {
                item = {
                  "Ledger_Name": selectedbankCashLedger,
                  "Date": widget.newDate,
                  //  "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                  "Ledger_ID": selectedItemID,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Remark": narration.text!=""?narration.text:null,
                };
              }
              widget.mListener.AddOrEditLedgerForContraDetail(item);
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .45,
            decoration: const BoxDecoration(
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

abstract class AddOrEditLedgerForContraInterface {
  AddOrEditLedgerForContraDetail(dynamic item);
}
