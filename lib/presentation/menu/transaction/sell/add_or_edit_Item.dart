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
import '../../../common_widget/get_diable_textformfield.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';
import '../../../searchable_dropdowns/serchable_drop_down_for_existing_list.dart';

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
  final exstingList;
  const AddOrEditItemSell(
      {super.key,
      required this.mListener,
      required this.editproduct,
      required this.date,
      this.id,
      this.readOnly,
      this.dateFinal,
      this.exstingList});

  @override
  State<AddOrEditItemSell> createState() => _AddOrEditItemSellState();
}

class _AddOrEditItemSellState extends State<AddOrEditItemSell> {
  final _formkey = GlobalKey<FormState>();
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode();
  final _itemKey = GlobalKey<FormFieldState>();

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode();
  final _quantityKey = GlobalKey<FormFieldState>();


  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();
  FocusNode rateFocus = FocusNode();
  final _rateKey = GlobalKey<FormFieldState>();


  TextEditingController amount = TextEditingController();
  FocusNode amountFocus = FocusNode();

  TextEditingController discount = TextEditingController();
  FocusNode discountFocus = FocusNode();

  TextEditingController discountAmt = TextEditingController();
  FocusNode discountAmtFocus = FocusNode();

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
  List insertedList=[];

  setVal() async {
    if (widget.editproduct != null) {
      setState(() {
        print("jfjhfhjfhjf   ${widget.editproduct['Rate']}");
        selectedItemID = widget.editproduct['Item_ID'] != null
            ? widget.editproduct['Item_ID']
            : null;
        selectedItemName = widget.editproduct['Item_Name'] != null
            ? widget.editproduct['Item_Name']
            : null;
        unit.text = widget.editproduct['Unit'].toString();
        quantity.text=widget.editproduct['Quantity']!="" &&widget.editproduct['Quantity']!=null?double.parse(widget.editproduct['Quantity'].toString()).toStringAsFixed(2):"";
        rate.text  =widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        previousRate=widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";

        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
        discount.text = widget.editproduct['Disc_Percent']!=0 && widget.editproduct['Disc_Percent']!="" &&widget.editproduct['Disc_Percent']!=null?double.parse( widget.editproduct['Disc_Percent'].toString()).toStringAsFixed(2):"";
        discountAmt.text = widget.editproduct['Disc_Amount']!=0 &&widget.editproduct['Disc_Amount']!="" &&widget.editproduct['Disc_Amount']!=null?double.parse( widget.editproduct['Disc_Amount'].toString()).toStringAsFixed(2):"";

        taxableAmt.text =widget.editproduct['Taxable_Amount']!=0 &&widget.editproduct['Taxable_Amount']!="" &&widget.editproduct['Taxable_Amount']!=null?double.parse( widget.editproduct['Taxable_Amount'].toString()).toStringAsFixed(2):"";

        gst.text =widget.editproduct['GST_Rate']!=0 &&widget.editproduct['GST_Rate']!="" &&widget.editproduct['GST_Rate']!=null?double.parse( widget.editproduct['GST_Rate'].toString()).toStringAsFixed(2):"";

        gstAmount.text =widget.editproduct['GST_Amount']!=0 &&widget.editproduct['GST_Amount']!="" &&widget.editproduct['GST_Amount']!=null?double.parse( widget.editproduct['GST_Amount'].toString()).toStringAsFixed(2):"";

        netRate.text =widget.editproduct['Net_Rate']!=0 &&widget.editproduct['Net_Rate']!="" &&widget.editproduct['Net_Rate']!=null?double.parse( widget.editproduct['Net_Rate'].toString()).toStringAsFixed(2):"";

        netAmount.text =widget.editproduct['Net_Amount']!=0 &&widget.editproduct['Net_Amount']!="" &&widget.editproduct['Net_Amount']!=null?double.parse( widget.editproduct['Net_Amount'].toString()).toStringAsFixed(2):"";

      });
      await calculateRates();
    }
    List list= widget.exstingList;
    setState(() {
      insertedList=list.map((e) =>e['Item_Name'] ).toList();
    });
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
                child: Form(
                  key: _formkey,
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
    return SearchableDropdownWithExistingList(
      txtkey: _itemKey,
      name: selectedItemName,
      come: widget.editproduct!=null?"disable":"",
      status: selectedItemName==""?"":"edit",
      focuscontroller: itemFocus,
      focusnext: quantityFocus,
      apiUrl: "${ApiConstants().purchasePartyItem}?PartyID=${widget.id}&Date=${widget.dateFinal}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      insertedList:insertedList,
      callback: (item) async {
        await calculateGstAmt();
        await calculateNetAmt();
        if(insertedList.contains(item['Name'])){
          CommonWidget.errorDialog(context,"Already Exist");
          setState(() {
            selectedItemName="";
            selectedItemID="";
          });
        }
        else {
          setState(() {
            selectedItemID = item['ID'].toString();
            selectedItemName = item['Name'].toString();
            unit.text = item['Unit']!=null?item['Unit']:null;
            rate.text = item['Rate'] == null? "" : item['Rate'].toString();
            previousRate=item['Rate'] == null? "" : item['Rate'].toString();
            gst.text = item['GST_Rate'] != null ? item['GST_Rate'] : "";
          });
        }
        await calculateRates();
        _itemKey.currentState!.validate();
        _rateKey.currentState!.validate();

      },
    );
/*    print("sadas ${selectedItemName}");
    return SearchableDropdownWithObject(
      name: selectedItemName,
      status: "edit",
      apiUrl:
          "${ApiConstants().purchasePartyItem}?PartyID=${widget.id}&Date=${widget.dateFinal}&",
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item) async {
        List l=widget.exstingList;
        List n= await l.map((i) => i['ID'].toString()).toList();
        print("FFFFFFFFFFFF ${n.contains(item['ID'].toString())}");
        if(n.contains(item['ID'].toString())){
          CommonWidget.errorDialog(context, "Already Exist!");
        }
        else {
          setState(() {
            // {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
            selectedItemID = item['ID'].toString();
            selectedItemName = item['Name'].toString();
            unit.text = item['Unit']!=null?item['Unit']:null;
            rate.text = item['Rate'] == null? "" : item['Rate'].toString();
            gst.text = item['GST_Rate'] != null ? item['GST_Rate'] : "";
          });
          await calculateRates();
        }
      },
    );*/

  }

  /* widget for item quantity layout */
  Widget getItemQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      txtkey: _quantityKey,
        suffix: Text("${unit.text}"),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: quantity,
        focuscontroller: quantityFocus,
        focusnext: rateFocus,
        title: ApplicationLocalizations.of(context)!.translate("quantity")!,
        callbackOnchage: (value) async {
          setState(() {
            rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
            discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
            discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
            gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
            // quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
            quantity.text = value;
            amountedited=false;
            discountamtedited=false;
          });
          await calculateRates();
          _quantityKey.currentState!.validate();
        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
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

  var discountamtedited=false;

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleLineEditableTextFormField(
        txtkey: _rateKey,
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: rate,
          focuscontroller: rateFocus,
          focusnext: amountFocus,
          title: ApplicationLocalizations.of(context)!.translate("rate")!,
          callbackOnchage: (value) async {

            setState(() {
              // rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
              discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
              discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
              gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
              quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
              rate.text = value;
              previousRate=value;
              amountedited=false;
              discountamtedited=false;
            });
            await calculateRates();
            _rateKey.currentState!.validate();
          },
          textInput: TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
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
              return "";
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: amount,
          focuscontroller: amountFocus,
          focusnext: discountFocus,
          title: ApplicationLocalizations.of(context)!.translate("amount")!,
          callbackOnchage: (value) async {
            print("########### $value");
            setState(() {
              rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
              discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
              discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
              gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
              quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
              amount.text = value;
              amountedited=true;
              discountamtedited=false;
            });
            await calculateRates();
            // await calculateRates();
          },
          textInput: TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
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
              return "";
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: discount,
          focuscontroller: discountFocus,
          focusnext: discountAmtFocus,
          title:
          ApplicationLocalizations.of(context)!.translate("disc_percent")!,
          callbackOnchage: (value) async {
            setState(() {
              rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
              // discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
              discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
              gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
              quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
              discountamtedited=false;
              discount.text = value;
            });
            await calculateRates();
          },
          textInput: TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
        ),
        SingleLineEditableTextFormField(
            parentWidth: (parentWidth),
            validation: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
            readOnly: widget.readOnly,
            controller: discountAmt,
            focuscontroller: discountAmtFocus,
            focusnext: gstFocus,
            title:
            ApplicationLocalizations.of(context)!.translate("disc_amount")!,
            callbackOnchage: (value) async {
              setState(() {
                rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
                discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
                // discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
                gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
                quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
                discountAmt.text = value;
                discountamtedited=true;
              });
              await calculateRates();

            },
            textInput: TextInputType.numberWithOptions(
                decimal: true
            ),
            maxlines: 1,
            format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
        ),
        // GetDisableTextFormField(
        //     parentWidth: (parentWidth),
        //     title:
        //     ApplicationLocalizations.of(context)!.translate("disc_amount")!,
        //     controller: discountAmt),
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
                return "";
              }
              return null;
            },
            readOnly: widget.readOnly,
            controller: gst,
            focuscontroller: gstFocus,
            focusnext: null,
            title:
            ApplicationLocalizations.of(context)!.translate("gst_percent")!,
            callbackOnchage: (value) async {
              setState(() {
                rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
                discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
                discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
                // gst.text=gst.text!=""?double.parse(gst.text).toStringAsFixed(2):"";
                quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
                amountedited=false;
                discountamtedited=false;
                gst.text = value;
              });
              await calculateRates();
            },
            textInput: TextInputType.numberWithOptions(
                decimal: true
            ),
            maxlines: 1,
            format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
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
  Widget getItemNetRateAndNetAmtLayout(double parentHeight, double parentWidth) {
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
            bool v=_itemKey.currentState!.validate();
            _quantityKey.currentState!.validate();
            _rateKey.currentState!.validate();
            print("ASSSSSSSSSSSSS $v");
            print(" ${selectedItemID} = ${rate.text} = ${amount.text} = ${quantity.text}");
            if (selectedItemID != null &&
                amount.text != "" &&
                quantity.text != "" &&
                rate.text != "") {
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
                  "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                  "Unit": unit.text!=""?unit.text:null,
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Disc_Percent": discount.text!=""?double.parse(double.parse(discount.text).toStringAsFixed(2)):null,
                  "Disc_Amount": discountAmt.text!=""?double.parse(double.parse(discountAmt.text).toStringAsFixed(2)):null,
                  "Taxable_Amount": taxableAmt.text!=""?double.parse(double.parse(taxableAmt.text).toStringAsFixed(2)):null,
                  "GST_Rate": gst.text!=""?double.parse(double.parse(gst.text).toStringAsFixed(2)):null,
                  "GST_Amount":gstAmount.text!=""?double.parse(double.parse(gstAmount.text).toStringAsFixed(2)):null,
                  "Net_Rate":netRate.text!=""?double.parse(double.parse(netRate.text).toStringAsFixed(2)):null,
                  "Net_Amount": netAmount.text!=""?double.parse(double.parse(netAmount.text).toStringAsFixed(2)):null,
                };
              } else {
                item = {
                  "Item_ID": selectedItemID,
                  "Item_Name": selectedItemName,
                  "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                  "Unit":unit.text!=""?unit.text:null,
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Disc_Percent": discount.text!=""?double.parse(double.parse(discount.text).toStringAsFixed(2)):null,
                  "Disc_Amount": discountAmt.text!=""?double.parse(double.parse(discountAmt.text).toStringAsFixed(2)):null,
                  "Taxable_Amount": taxableAmt.text!=""?double.parse(double.parse(taxableAmt.text).toStringAsFixed(2)):null,
                  "GST_Rate": gst.text!=""?double.parse(double.parse(gst.text).toStringAsFixed(2)):null,
                  "GST_Amount":gstAmount.text!=""?double.parse(double.parse(gstAmount.text).toStringAsFixed(2)):null,
                  "Net_Rate":netRate.text!=""?double.parse(double.parse(netRate.text).toStringAsFixed(2)):null,
                  "Net_Amount": netAmount.text!=""?double.parse(double.parse(netAmount.text).toStringAsFixed(2)):null,
                  "Seq_No": widget.editproduct != null
                      ? widget.editproduct['Seq_No']
                      : null,
                };
              }

              if (widget.mListener != null) {
                widget.mListener.AddOrEditItemSellDetail(item);
                Navigator.pop(context);
              }
            } else {
              CommonWidget.errorDialog(context,
                  "Please add required fields item,rate,quantity,amount !");
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
    var amt = double.parse(quantity.text) * double.parse(rate.text);
    setState(() {
      amount.text = amt.toStringAsFixed(2);
    });
  }

  calculateDiscountAmt() {
    var amt = amount.text == "" ? null: double.parse(amount.text);
    var dis= discount.text == "" ? null : double.parse(discount.text);
    var disamt= discountAmt.text == "" ? null : double.parse(discountAmt.text);
    if(discountamtedited==false) {
      if(dis==null){
        setState(() {
          discountAmt.clear();
        });
      }
      if (dis != null && amt != null) {
        var disAmt = amt * (dis / 100);
        setState(() {
          discountAmt.text = disAmt.toStringAsFixed(2);
        });
      }
    }
    else {
      if(disamt==null){
        setState(() {
          discount.clear();
        });
      }
      if (disamt != null && amt != null) {
        var d = (disamt / amt) * 100;
        setState(() {
          discount.text = d.toStringAsFixed(2);
        });
      }
    }

  }

  calculateTaxableAmt() {
    double amt = amount.text == "" ? 0.0 : double.parse(amount.text);
    double disAmt = discountAmt.text == "" ? 0.0 : double.parse(discountAmt.text);
    var taxAmt = amt - disAmt;
    setState(() {
      taxableAmt.text = taxAmt.toStringAsFixed(2);
    });
  }

  calculateGstAmt() {
    var taxbleAmunt =
    taxableAmt.text == "" ? null : double.parse(taxableAmt.text);
    var gstText = gst.text == "" ? null : double.parse(gst.text);

    if(taxableAmt!=null && gstText!=null) {
      var gstAmt = taxbleAmunt! * (gstText / 100);
      setState(() {
        gstAmount.text = gstAmt.toStringAsFixed(2);
      });
    }
    if(gstText==null){
      setState(() {
        gstAmount.clear();
      });
    }
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

  var previousRate="";

  calculateRates() async {

    if(amountedited && quantity.text!=""){
      if(amount.text!="" && quantity.text!="") {
        var amt = double.parse(amount.text) / double.parse(quantity.text);

        setState(() {
          rate.text = amt.toStringAsFixed(2);
        });
      }
      if(amount.text==""){
        setState(() {
          rate.text=double.parse(previousRate).toStringAsFixed(2);
        });
      }
    }
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

    if (quantity.text == "" || rate.text == "") {
      setState(() {
        amount.clear();
      });
    }
    if(amount.text==""){
      setState(() {
        rate.text=double.parse(previousRate).toStringAsFixed(2);
      });
    }
    if(quantity.text==""){
      setState(() {
        amount.clear();
      });
    }

  }
}

abstract class AddOrEditItemSellInterface {
  AddOrEditItemSellDetail(dynamic item);
}
