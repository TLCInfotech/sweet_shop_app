import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dialog/amount_type_dialog.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}

class AddOrEditLedgerForJournals extends StatefulWidget {
  final AddOrEditLedgerForJournalsInterface mListener;
  final dynamic editproduct;
  final newdate;
  final come;
  final companyId;
  final exstingList;
  const AddOrEditLedgerForJournals(
      {super.key,
      required this.mListener,
      required this.editproduct,
      required this.newdate,
      this.come,
      this.companyId, this.exstingList});

  @override
  State<AddOrEditLedgerForJournals> createState() =>
      _AddOrEditLedgerForJournalsState();
}

class _AddOrEditLedgerForJournalsState extends State<AddOrEditLedgerForJournals>
    with AmountTypeDialogInterface {
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
  var bankLedgerList = [];

  var selectedBankLedgerID = null;

  var oldItemId = 0;

  var filteredItemsList = [];
  fetchShows() async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = ApiConstants().baseUrl +
          ApiConstants().getLedgerWithoutBankCash +
          "?Company_ID=$companyId&${StringEn.lang}=$lang";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess: (data) async {
        if (data != null) {
          var topShowsJson = (data) as List;
          setState(() {
            bankLedgerList = topShowsJson.map((show) => (show)).toList();
            filteredItemsList = topShowsJson.map((show) => (show)).toList();
          });
        }
      }, onFailure: (error) {
        CommonWidget.errorDialog(context, error);
        return [];
        // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
        //  widget.mListener.loaderShow(false);
        //  Navigator.of(context, rootNavigator: true).pop();
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
      bankLedgerList = results;
    });

    print(bankLedgerList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in bankLedgerList) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }
  /* initialise the value*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  /* get the value layout*/
  setVal() async {
    if (widget.editproduct != null) {
      setState(() {
        selectedbankCashLedger = widget.editproduct['Ledger_Name'] != null
            ? widget.editproduct['Ledger_Name']
            : "";
        selectedBankLedgerID = widget.editproduct['Ledger_ID'] != null
            ? widget.editproduct['Ledger_ID']
            : "";
        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
        narration.text=widget.editproduct['Remark']!=null && widget.editproduct['Remark']!=""?widget.editproduct['Remark'].toString():narration.text;

        selectedLimitUnit = widget.editproduct['Amnt_Type']!=null && widget.editproduct['Amnt_Type']!=""?widget.editproduct['Amnt_Type'].toString():null;
      });
    }
    await fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
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
                  padding: const EdgeInsets.all(10),
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
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /* widget for narration layout */
  Widget getLedgerNarrationLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
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

  var selectedLimitUnit = null;

  var amttypemandatory=false;

  /* widget for ledger amount layout */
  Widget getILedgerAmountyLayout(double parentHeight, double parentWidth) {
    return Row(
      children: [
        Expanded(
          child: SingleLineEditableTextFormField(
              mandatory: true,
              txtkey: _amountKey,
            validation: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
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
          ),
        ),
        AmountTypeDialog(
          mandatory:amttypemandatory,
          mListener: this,
          selectedType: selectedLimitUnit,
          width: 130,
        )
      ],
    );
  }

  var selectedbankCashLedger = "";

  /* widget for ledger search layout */
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    return     SearchableDropdownWithObject(
      mandatory: true,
      txtkey: _ledgerKey,
      focusnext: amountFocus,
      focuscontroller: ledgerFocus,
      name: selectedbankCashLedger,
      status:  "edit",
      apiUrl: ApiConstants().getLedgerWithoutBankCash + "?Company_ID=${widget.companyId}",
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
          // selectedBankLedgerID = id;
          selectedBankLedgerID = item['ID'].toString();
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
    //   apiUrl: ApiConstants().getLedgerWithoutBankCash + "?Company_ID=${widget.companyId}",
    //   titleIndicator: false,
    //   ledgerName: selectedbankCashLedger,
    //   franchisee: widget.come,
    //   franchiseeName: selectedbankCashLedger,
    //   title: ApplicationLocalizations.of(context)!
    //       .translate("ledger_without_bank_cash")!,
    //   callback: (name, id) async{
    //     // print("FFFFFFFFFFFF ${widget.exstingList}");
    //     //
    //     // List l=widget.exstingList;
    //     // List n= await l.map((i) => i['Ledger_ID'].toString()).toList();
    //     // print("FFFFFFFFFFFF ${n.contains(id.toString())}");
    //     // if(n.contains(id.toString())){
    //     //   CommonWidget.errorDialog(context, "Already Exist!");
    //     // }
    //     // else {
    //       if (selectedBankLedgerID == id) {
    //         var snack =
    //         SnackBar(content: Text("Sale Ledger and Party can not be same!"));
    //         ScaffoldMessenger.of(context).showSnackBar(snack);
    //       } else {
    //         setState(() {
    //           selectedbankCashLedger = name!;
    //           selectedBankLedgerID = id;
    //         });
    //       }
    //     // }
    //     setState(() {
    //       amount.text = amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
    //     });
    //
    //
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
              hintText: ApplicationLocalizations.of(context)!.translate("ledger_without_bank_cash")!,
              prefixIcon: Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
            ),
            textStyle: item_regular_textStyle,
            getSelectedValue: (v) {
              setState(() {
                selectedBankLedgerID = v.value;
                bankLedgerList = [];
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

  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Text(
        title,
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
            bool v=_ledgerKey.currentState!.validate();
            bool q=_amountKey.currentState!.validate();
            if(selectedLimitUnit==null){
              setState(() {
                amttypemandatory=true;
              });
            }
            else{
              setState(() {
                amttypemandatory=false;
              });
            }
            if(selectedBankLedgerID!=null && v && q && selectedLimitUnit!=null){
              if (widget.editproduct != null) {
                item = {
                  // "Date":widget.newdate,
                  // "New_Date":widget.newdate,
                  "New_Ledger_ID": selectedBankLedgerID,
                  "Seq_No": widget.editproduct != null
                      ? widget.editproduct['Seq_No']
                      : null,
                  "Ledger_Name": selectedbankCashLedger,
                  "Ledger_ID": widget.editproduct['Ledger_ID'],
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Remark": narration.text!=""?narration.text:null,
                  "Amnt_Type": selectedLimitUnit,

                };
              } else {
                item = {
                  // "Date":widget.newdate,
                  "Seq_No": widget.editproduct != null
                      ? widget.editproduct['Seq_No']
                      : 0,
                  "Ledger_Name": selectedbankCashLedger,
                  "Ledger_ID": selectedBankLedgerID,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Remark": narration.text!=""?narration.text:null,
                  "Amnt_Type": selectedLimitUnit,

                };
              }
              if (widget.mListener != null) {
                widget.mListener.AddOrEditLedgerForJournalsDetail(item);
                Navigator.pop(context);
              }
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

  @override
  selectedAmountType(String name) {
    // TODO: implement selectedAmountType
    setState(() {
      selectedLimitUnit = name;
    });
  }
}

abstract class AddOrEditLedgerForJournalsInterface {
  AddOrEditLedgerForJournalsDetail(dynamic item);
}
