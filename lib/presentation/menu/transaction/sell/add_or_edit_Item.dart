import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:textfield_search/textfield_search.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_diable_textformfield.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class TestItem {
  String label;
  dynamic value;
  dynamic unit;
  dynamic rate;
  dynamic gst;
  TestItem({required this.label, this.value, this.unit, this.rate, this.gst});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
        label: json['label'],
        value: json['value'],
        unit: "${json['unit']}",
        rate: "${json['rate']}",
        gst: "${json['gst']}");
  }
}

class AddOrEditItemSell extends StatefulWidget {
  final AddOrEditItemSellInterface mListener;
  final dynamic editproduct;
  final date;
  final id;
  final readOnly;
  final dateFinal;
  const AddOrEditItemSell(
      {super.key,
      required this.mListener,
      required this.editproduct,
      required this.date,
      this.id,
      this.readOnly,
      this.dateFinal});

  @override
  State<AddOrEditItemSell> createState() => _AddOrEditItemSellState();
}

class _AddOrEditItemSellState extends State<AddOrEditItemSell> {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode();

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode();

  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();

  TextEditingController amount = TextEditingController();

  TextEditingController discount = TextEditingController();
  FocusNode discountFocus = FocusNode();

  TextEditingController discountAmt = TextEditingController();

  TextEditingController taxableAmt = TextEditingController();

  TextEditingController gst = TextEditingController();
  FocusNode gstFocus = FocusNode();

  TextEditingController gstAmount = TextEditingController();

  TextEditingController netRate = TextEditingController();

  TextEditingController netAmount = TextEditingController();
  var selectedItemID = null;
  var oldItemId = 0;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  FocusNode searchFocus = FocusNode();

  getCompanyId() async {
    String companyId1 = await AppPreferences.getCompanyId();
    setState(() {
      companyId = companyId1;
      api =
          "${ApiConstants().salePartyItem}?Company_ID=$companyId1&PartyID=${widget.id}&Date=${widget.dateFinal}";
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
        print("jfjhfhjfhjf   ${ widget.editproduct['Rate']}");
        selectedItemID = widget.editproduct['Item_ID'] != null
            ? widget.editproduct['Item_ID']
            : null;
        selectedItemName = widget.editproduct['Item_Name'] != null
            ? widget.editproduct['Item_Name']
            : null;
        unit.text = widget.editproduct['Unit'].toString();
        quantity.text = widget.editproduct['Quantity'].toString();
        rate.text =  widget.editproduct['Rate']==null?"0":
        widget.editproduct['Rate'].toString();
        amount.text = widget.editproduct['Amount'].toString();
        discount.text = widget.editproduct['Disc_Percent'] == null
            ? "0"
            : widget.editproduct['Disc_Percent'].toString();
        discountAmt.text = widget.editproduct['Disc_Amount'].toString();
        taxableAmt.text = widget.editproduct['Taxable_Amount'].toString();
        gst.text = widget.editproduct['GST_Rate'].toString();
        gstAmount.text = widget.editproduct['GST_Amount'].toString();
        netRate.text = widget.editproduct['Net_Rate'].toString();
        netAmount.text = widget.editproduct['Net_Amount'].toString();
      });
      await calculateRates();
    }
    // await fetchItems();
    // await getCompanyId();
  }

  var itemsList = [];
  var filteredItemsList = [];

  fetchItems() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl = await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl =
          "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&PartyID=${widget.id}&Date=${widget.dateFinal}";
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
      itemsList = results;
    });

    print(itemsList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in filteredItemsList) {
      _list.add(new TestItem.fromJson({
        'label': "${ele['Name']}",
        'value': "${ele['ID']}",
        "unit": ele['Unit'],
        "rate": ele['Rate'],
        'gst': ele['GST_Rate']
      }));
    }
    return _list;
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
              height: SizeConfig.screenHeight * 0.8,
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
                                .translate("item_detail")!,
                            style: page_heading_textStyle),
                      ),
                    ),
                    getFieldTitleLayout(ApplicationLocalizations.of(context)!
                        .translate("item_name")!),
                    getAddSearchLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getItemQuantityLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getRateAndAmount(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getItemDiscountandAmtLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getTaxableAmtLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getITemgstAndGstAmtLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getItemNetRateAndNetAmtLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
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

  //franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    print("sadas ${selectedItemName}");
    return SearchableDropdownWithObject(
      name: selectedItemName,
      status: "edit",
      apiUrl:
          "${ApiConstants().purchasePartyItem}?PartyID=${widget.id}&Date=${widget.dateFinal}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item) async {
        setState(() {
          // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
          selectedItemID = item['ID'].toString();
          selectedItemName = item['Name'].toString();
          unit.text = item['Unit'];
          rate.text =item['Rate']==null?"0":item['Rate'].toString();
          gst.text = item['GST_Rate'] != null ? item['GST_Rate'] : "";
        });
        await calculateRates();
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

  /* widget for item quantity layout */
  Widget getItemQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      suffix: Text("${unit.text}"),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER + StringEn.QUANTITY;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: quantity,
      focuscontroller: null,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("quantity")!,
      callbackOnchage: (value) async {
        setState(() {
          quantity.text = value;
          amountedited=false;
        });
        await calculateRates();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

    Container(
      height: parentHeight * .055,
      // width: (parentWidth*0.8)/2,
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
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: quantity,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.QUANTITY,
          suffix: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Text(
                "${unit.text}",
                style: item_regular_textStyle,
              )),
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Item Quantity";
          }
          return null;
        }),
        onChanged: (value) async {
          await calculateRates();
        },
        onTapOutside: (event) {},
      ),
    );
  }
  var amountedited=false;

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleLineEditableTextFormField(
        parentWidth: (parentWidth),
        validation: (value) {
          if (value!.isEmpty) {
            return StringEn.ENTER + StringEn.QUANTITY;
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: rate,
        focuscontroller: null,
        focusnext: null,
        title: ApplicationLocalizations.of(context)!.translate("rate")!,
        callbackOnchage: (value) async {
          setState(() {
            rate.text = value;
            amountedited=false;
          });
          await calculateRates();
        },
        textInput: TextInputType.number,
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
      ),
      /*    SingleLineEditableTextFormField(
            parentWidth: (parentWidth),
            title: ApplicationLocalizations.of(context)!.translate("rate")!,
            controller: rate
        ),*/
      SingleLineEditableTextFormField(
        parentWidth: (parentWidth),
        validation: (value) {
          if (value!.isEmpty) {
            return StringEn.ENTER + StringEn.QUANTITY;
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: amount,
        focuscontroller: null,
        focusnext: null,
        title: ApplicationLocalizations.of(context)!.translate("amount")!,
        callbackOnchage: (value) async {
          print("########### $value");
          setState(() {
            amount.text = value;
            amountedited=true;
          });
          await calculateRates();
          // await calculateRates();
        },
        textInput: TextInputType.numberWithOptions(
          decimal: true
         ),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ./]')),
      ),
     /* GetDisableTextFormField(
          parentWidth: (parentWidth),
          title: ApplicationLocalizations.of(context)!.translate("amount")!,
          controller: amount)*/
    ]);
  }

  /* widget for product discount layout */
  Widget getItemDiscountandAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleLineEditableTextFormField(
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return StringEn.ENTER + StringEn.DICOUNT;
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: discount,
          focuscontroller: null,
          focusnext: null,
          title:
              ApplicationLocalizations.of(context)!.translate("disc_percent")!,
          callbackOnchage: (value) async {
            setState(() {
              discount.text = value;
            });
            await calculateRates();
          },
          textInput: TextInputType.number,
          maxlines: 1,
          format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
        ),
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title:
                ApplicationLocalizations.of(context)!.translate("disc_amount")!,
            controller: discountAmt),
      ],
    );
  }

  /* widget for product gst layout */
  Widget getTaxableAmtLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
        title:
            ApplicationLocalizations.of(context)!.translate("taxable_amount")!,
        controller: taxableAmt);
  }

  /* widget for product gst layout */
  Widget getITemgstAndGstAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleLineEditableTextFormField(
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return StringEn.ENTER + StringEn.DICOUNT;
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: gst,
          focuscontroller: null,
          focusnext: null,
          title:
              ApplicationLocalizations.of(context)!.translate("gst_percent")!,
          callbackOnchage: (value) async {
            setState(() {
              gst.text = value;
            });
            await calculateRates();
          },
          textInput: TextInputType.number,
          maxlines: 1,
          format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
        ),
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title:
                ApplicationLocalizations.of(context)!.translate("gst_amount")!,
            controller: gstAmount),
      ],
    );
  }

  /* widget for product gst layout */
  Widget getItemNetRateAndNetAmtLayout(
      double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title: ApplicationLocalizations.of(context)!.translate("net_rate")!,
            controller: netRate),
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title:
                ApplicationLocalizations.of(context)!.translate("net_amount")!,
            controller: netAmount),
      ],
    );
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
                "Quantity": int.parse(quantity.text),
                "Unit": "kg",
                "Rate": double.parse(rate.text),
                "Amount": double.parse(amount.text),
                "Disc_Percent": discount.text == "" || discount.text == null
                    ? double.parse("00.00")
                    : double.parse(discount.text),
                "Disc_Amount": double.parse(discountAmt.text),
                "Taxable_Amount": double.parse(taxableAmt.text),
                "GST_Rate": gst.text == "" || gst.text == null
                    ? double.parse("00.00")
                    : double.parse(gst.text),
                "GST_Amount": double.parse(gstAmount.text),
                "Net_Rate": double.parse(netRate.text),
                "Net_Amount": double.parse(netAmount.text),
              };
            } else {
              item = {
                "Item_ID": selectedItemID,
                "Item_Name": selectedItemName,
                "Quantity": int.parse(quantity.text),
                "Unit": "kg",
                "Rate": double.parse(rate.text),
                "Amount": double.parse(amount.text),
                "Disc_Percent": discount.text == "" || discount.text == null
                    ? double.parse("00.00")
                    : double.parse(discount.text),
                "Disc_Amount": double.parse(discountAmt.text),
                "Taxable_Amount": double.parse(taxableAmt.text),
                "GST_Rate": gst.text == "" || gst.text == null
                    ? double.parse("00.00")
                    : double.parse(gst.text),
                "GST_Amount": double.parse(gstAmount.text),
                "Net_Rate": double.parse(netRate.text),
                "Net_Amount": double.parse(netAmount.text),
                "Seq_No": widget.editproduct != null
                    ? widget.editproduct['Seq_No']
                    : null,
              };
            }

            if (widget.mListener != null) {
              widget.mListener.AddOrEditItemSellDetail(item);
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

  calculateAmt() {
    var amt = int.parse(quantity.text) * double.parse(rate.text);
    setState(() {
      amount.text = amt.toString();
    });
  }

  calculateDiscountAmt() {
    double amt = amount.text == "" ? 0.0 : double.parse(amount.text);
    double disAmts = discount.text == "" ? 0.0 : double.parse(discount.text);
    var disAmt = amt * (disAmts / 100);
    setState(() {
      discountAmt.text = disAmt.toStringAsFixed(2);
    });
  }

  calculateTaxableAmt() {
    double amt = amount.text == "" ? 0.0 : double.parse(amount.text);
    double disAmt =
        discountAmt.text == "" ? 0.0 : double.parse(discountAmt.text);
    var taxAmt = amt - disAmt;
    setState(() {
      taxableAmt.text = taxAmt.toStringAsFixed(2);
    });
  }

  calculateGstAmt() {
    double taxbleAmunt =
        taxableAmt.text == "" ? 0.0 : double.parse(taxableAmt.text);
    double gstText = gst.text == "" ? 0.0 : double.parse(gst.text);
    var gstAmt = taxbleAmunt * (gstText / 100);
    setState(() {
      gstAmount.text = gstAmt.toStringAsFixed(2);
    });
  }

  calculateNetAmt() {
    double taxbleAmunt =
        taxableAmt.text == "" ? 0.0 : double.parse(taxableAmt.text);
    double gstAmt = gstAmount.text == "" ? 0.0 : double.parse(gstAmount.text);
    var netamt = taxbleAmunt + gstAmt;
    setState(() {
      netAmount.text = netamt.toStringAsFixed(2);
    });
  }

  calculateNetRate() {
    double netAmt = netAmount.text == "" ? 0.0 : double.parse(netAmount.text);
    double quantityAmt =
        quantity.text == "" ? 0.0 : double.parse(quantity.text);
    var netRates = netAmt / quantityAmt;
    setState(() {
      netRate.text = netRates.toStringAsFixed(2);
    });
  }

  calculateRates() async {
    if (quantity.text != "" && rate.text != "") {
      if(amountedited==false) {
        await calculateAmt();
      }
      await calculateGstAmt();
      await calculateDiscountAmt();
      await calculateTaxableAmt();
      await calculateNetAmt();
      await calculateNetRate();
    }
  }
}

abstract class AddOrEditItemSellInterface {
  AddOrEditItemSellDetail(dynamic item);
}
