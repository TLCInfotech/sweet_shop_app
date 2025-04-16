import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_diable_textformfield.dart';
import 'package:sweet_shop_app/presentation/common_widget/signleLine_TexformField.dart';
import 'package:sweet_shop_app/presentation/common_widget/singleLine_TextformField_without_double.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/searchable_dropdown_with_object.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/serchable_drop_down_for_existing_list.dart';
import '../../../../../core/app_preferance.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/common_style.dart';
import '../../../../../core/localss/application_localizations.dart';
import '../../../../../core/size_config.dart';


class AddOrEditInvoiceAddition extends StatefulWidget {
  final AddOrEditInvoiceAdditionInterface mListener;
  final dynamic editproduct;
  final date;
  final id;
  final readOnly;
  final dateFinal;
  final exstingList;
  final igstApplicable;
  final cAndsgstApplicable;
  final String setText;
  final String unitP;
  final String rateP;
  final gstavailable;
  const AddOrEditInvoiceAddition(
      {super.key,
        required this.mListener,
        required this.editproduct,
        required this.date,
        this.readOnly,
        this.id,
        this.dateFinal,
        this.gstavailable,
        this.exstingList, this.igstApplicable, this.cAndsgstApplicable, required this.setText, required this.unitP, required this.rateP, });

  @override
  State<AddOrEditInvoiceAddition> createState() => _AddOrEditInvoiceAdditionState();
}

class _AddOrEditInvoiceAdditionState extends State<AddOrEditInvoiceAddition> {
  bool isLoaderShow = false;
  final _formkey = GlobalKey<FormState>();

  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode();
  final _itemKey = GlobalKey<FormFieldState>();

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode();
  final _quantityKey = GlobalKey<FormFieldState>();

  TextEditingController pack_quantity = TextEditingController();
  FocusNode pack_quantityFocus = FocusNode();
  final _packquantityKey = GlobalKey<FormFieldState>();

  var unit2base=null;
  String selectStoreName = "";
  dynamic selectStoreId = "";
  TextEditingController batchId = TextEditingController();
  FocusNode batchIdFocus = FocusNode();
  FocusNode storeFocus = FocusNode();
  var unit2factor=null;
  TextEditingController unit2 = TextEditingController();


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

  TextEditingController igst = TextEditingController();
  FocusNode igstFocus = FocusNode();

  TextEditingController igstAmount = TextEditingController();

  TextEditingController cgst = TextEditingController();
  FocusNode cgstFocus = FocusNode();

  TextEditingController cgstAmount = TextEditingController();

  TextEditingController sgst = TextEditingController();
  FocusNode sgstFocus = FocusNode();

  TextEditingController sgstAmount = TextEditingController();

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
    });
    print("CompanyID=> $companyId");
  }

  var companyId = "0";
  var selectedItemName = "";
  var api = "";
  var orderno=null;

  var gstavl=true;

  var showButton=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }
  List insertedList=[];

  setVal() async {
    print(widget.igstApplicable);

    setState(() {
      if(widget.gstavailable==null || widget.gstavailable=="null"){
        gstavl=false;
      }
    });
    print("************ $gstavl ${widget.gstavailable}");

    print(widget.editproduct);
    if (widget.editproduct != null) {
      setState(() {
        print("jfjhfhjfhjf   ${ widget.editproduct['Rate']}");
        selectedItemID = widget.editproduct['Item_Code'] != null
            ? widget.editproduct['Item_Code']
            : null;
        selectedItemName = widget.editproduct['Item_Name'] != null
            ? widget.editproduct['Item_Name']
            : null;
        unit.text = widget.editproduct['Unit']=="null"|| widget.editproduct['Unit']==null?"": widget.editproduct['Unit'].toString();
        print("nfnnnbnb   ${widget.editproduct['Batch_ID']}    ${widget.editproduct['Batch_ID']}");
        selectStoreId =widget.editproduct['Store_ID']!="" &&widget.editproduct['Store_ID']!=null?widget.editproduct['Store_ID']:"";
        selectStoreName=widget.editproduct['Store_Name']!="" &&widget.editproduct['Store_Name']!=null?widget.editproduct['Store_Name']:"";
        batchId.text =widget.editproduct['Batch_ID']!="" &&widget.editproduct['Batch_ID']!=null?widget.editproduct['Batch_ID']:"";
        quantity.text =widget.editproduct['Quantity']!="" &&widget.editproduct['Quantity']!=null?double.parse(widget.editproduct['Quantity'].toString()).toStringAsFixed(2):"";
        rate.text  =widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        previousRate=widget.editproduct['Rate']!=0 && widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse( widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
        amount.text =widget.editproduct['Amount']!=0 && widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse( widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
        discount.text = widget.editproduct['Disc_Percent']!=0 && widget.editproduct['Disc_Percent']!="" &&widget.editproduct['Disc_Percent']!=null?double.parse( widget.editproduct['Disc_Percent'].toString()).toStringAsFixed(2):"";
        discountAmt.text = widget.editproduct['Disc_Amount']!=0 &&widget.editproduct['Disc_Amount']!="" &&widget.editproduct['Disc_Amount']!=null?double.parse( widget.editproduct['Disc_Amount'].toString()).toStringAsFixed(2):"";
        taxableAmt.text =widget.editproduct['Taxable_Amount']!=0 &&widget.editproduct['Taxable_Amount']!="" &&widget.editproduct['Taxable_Amount']!=null?double.parse( widget.editproduct['Taxable_Amount'].toString()).toStringAsFixed(2):"";

        if(widget.igstApplicable==true) {
          igst.text = widget.editproduct['IGST_Rate'] != 0 &&
              widget.editproduct['IGST_Rate'] != "" &&
              widget.editproduct['IGST_Rate'] != null
              ? double.parse(widget.editproduct['IGST_Rate'].toString())
              .toStringAsFixed(2)
              : "";

          igstAmount.text = widget.editproduct['IGST_Amount'] != 0 &&
              widget.editproduct['IGST_Amount'] != "" &&
              widget.editproduct['IGST_Amount'] != null
              ? double.parse(widget.editproduct['IGST_Amount'].toString())
              .toStringAsFixed(2)
              : "";
        }
        else{
          cgst.text = widget.editproduct['CGST_Rate'] != 0 &&
              widget.editproduct['CGST_Rate'] != "" &&
              widget.editproduct['CGST_Rate'] != null
              ? double.parse(widget.editproduct['CGST_Rate'].toString())
              .toStringAsFixed(2)
              : "";

          cgstAmount.text = widget.editproduct['CGST_Amount'] != 0 &&
              widget.editproduct['CGST_Amount'] != "" &&
              widget.editproduct['CGST_Amount'] != null
              ? double.parse(widget.editproduct['CGST_Amount'].toString())
              .toStringAsFixed(2)
              : "";

          sgst.text = widget.editproduct['SGST_Rate'] != 0 &&
              widget.editproduct['SGST_Rate'] != "" &&
              widget.editproduct['SGST_Rate'] != null
              ? double.parse(widget.editproduct['SGST_Rate'].toString())
              .toStringAsFixed(2)
              : "";

          sgstAmount.text = widget.editproduct['SGST_Amount'] != 0 &&
              widget.editproduct['SGST_Amount'] != "" &&
              widget.editproduct['SGST_Amount'] != null
              ? double.parse(widget.editproduct['SGST_Amount'].toString())
              .toStringAsFixed(2)
              : "";
        }
        netRate.text =widget.editproduct['Net_Rate']!=0 &&widget.editproduct['Net_Rate']!="" &&widget.editproduct['Net_Rate']!=null?double.parse( widget.editproduct['Net_Rate'].toString()).toStringAsFixed(2):"";

        netAmount.text =widget.editproduct['Net_Amount']!=0 &&widget.editproduct['Net_Amount']!="" &&widget.editproduct['Net_Amount']!=null?double.parse( widget.editproduct['Net_Amount'].toString()).toStringAsFixed(2):"";
       orderno=widget.editproduct['order_No']!=0 &&widget.editproduct['order_No']!="" &&widget.editproduct['order_No']!=null? widget.editproduct['order_No'].toString():null;
        unit2.text = widget.editproduct['Packing_Unit']=="null"||widget.editproduct['Packing_Unit']==null?"":widget.editproduct['Packing_Unit'].toString();
        pack_quantity.text =widget.editproduct['Packing_Quantity']!="" &&widget.editproduct['Packing_Quantity']!=null?double.parse(widget.editproduct['Packing_Quantity'].toString()).toStringAsFixed(2):"";

      });
      await callGetLedger();
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

  var amountedited=false;

  var discountamtedited=false;


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
              height: SizeConfig.screenHeight * 0.4,
              decoration: const BoxDecoration(
                color:CommonColor.BACKGROUND_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.only(bottom:10,left: 10,right: 10,top:10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight * .08,
                        child: Center(
                          child: Text(
                              "Party Detail",
                              style: page_heading_textStyle),
                        ),
                      ),
                      getAddSearchLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    //  getItemQuantityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getRateAndAmount(SizeConfig.screenHeight, SizeConfig.screenWidth),

                      //      getStoreLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                 //      getBatchIdLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                  //     getPackingQuantityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                 //      getRateAndAmount(SizeConfig.screenHeight, SizeConfig.screenWidth),
                 //      getItemDiscountandAmtLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                 // getItemNetRateAndNetAmtLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                      const SizedBox(
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

  List<dynamic> ledger_list = [];
  FocusNode ledgerFocus = FocusNode() ;
  var selectedLedgerName="";
  final _ledgerKey = GlobalKey<FormFieldState>();
  //franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    print("sadas ${selectedItemName}");
    return  SearchableDropdownWithObject(
      mandatory: true,
      txtkey: _ledgerKey,
      focusnext: amountFocus,
      focuscontroller: ledgerFocus,
      name: selectedLedgerName,
      status:  "edit",
      apiUrl:"${ApiConstants().ledger_list}?",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (item)async{
        print("FFFFFFFFFFFF ${widget.exstingList}");

        // List l=widget.exstingList;
        // List n= await l.map((i) => i['Expense_ID'].toString()).toList();
        // print("FFFFFFFFFFFF ${n.contains(item['ID'].toString())}");
        // if(n.contains(item['ID'].toString())){
        //   CommonWidget.errorDialog(context, "Already Exist!");
        // }
        // else {
        setState(() {
          selectedItemID = item['ID'].toString();
          selectedLedgerName = item['Name'].toString();
        });
        // }
        setState(() {
          amount.text = amount.text!=""?double.parse(amount.text).toStringAsFixed(2):"";
        });
        _ledgerKey.currentState!.validate();

      },

    );
  }

  Widget getStoreLayout(double parentHeight, double parentWidth) {
    return  Container() /*CommonDropdown(
      apiUrl: ApiConstants().store+"?",
      nameField:"Name",
      idField:"ID",
      titleIndicator: true,
      ledgerName: selectStoreName,
      focuscontroller: storeFocus,
      focusnext:batchIdFocus ,
      franchiseeName:  selectStoreName,
      franchisee: selectStoreName!=""?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context).translate("store"),
      callback: (item)async {
        setState(() {
          selectStoreName = item['Name']!;
          selectStoreId = item['ID'].toString();

        });
        setState(() {
          showButton=true;
        });
        //  await getRoutebyPartId();
      },
    )*/;


  }
  /* widget for batch Id layout */
  Widget getBatchIdLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: false,
      // txtkey: _packquantityKey,
      // suffix: unit2.text!=null?Text("${unit2.text}"):Text(""),
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: batchId,
      focuscontroller: batchIdFocus,
      focusnext: pack_quantityFocus,
      title: ApplicationLocalizations.of(context).translate("batch_id"),
      callbackOnchage: (value) async {
        setState(() {
          batchId.text = value;
          print("bachhhhhhhh  ${batchId.text}");
        });
        setState(() {
          showButton=true;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'.*')),
    );

  }
  /* widget for item quantity layout */
  Widget getItemQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: true,
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
            igst.text=igst.text!=""?double.parse(igst.text).toStringAsFixed(2):"";
            // quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
            quantity.text = value;
            amountedited=false;
            discountamtedited=false;
          });
          await calculateRates();
          setState(() {
            showButton=true;
          });
          // _quantityKey.currentState!.validate();
        },
        textInput: const TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );
  }


  /* widget for item packing quantity layout */
  Widget getPackingQuantityLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
        mandatory: false,
        txtkey: _packquantityKey,
        suffix: unit2.text!=null||unit2.text!="null"?Text("${unit2.text}"):const Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: pack_quantity,
        focuscontroller: pack_quantityFocus,
        focusnext: quantityFocus,
        title: ApplicationLocalizations.of(context)!.translate("packing_quantity")!,
        callbackOnchage: (value) async {
          setState(() {
            pack_quantity.text = value;
            amountedited=false;
            discountamtedited=false;
          });
          print("sdfsdf");
          print(unit2base );
          print(unit2factor);
          if(unit2base!=null && unit2factor!=null){
            var pckqty= double.parse(value);
            quantity.text= (pckqty * unit2base/ unit2factor).toStringAsFixed(2);
            // Math.Round(pack_quantity.text) * [unit2base] / [unit2factor], 2);
          }

          await calculateRates();
          setState(() {
            showButton=true;
          });
        },
        textInput: const TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );

  }

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
     /* SingleLineEditableTextFormField(
          mandatory: true,
          txtkey: _rateKey,
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
          readOnly:  widget.setText==StringEn.saleOrder?false:widget.readOnly,
          controller: rate,
          focuscontroller: rateFocus,
          focusnext: amountFocus,
          title: ApplicationLocalizations.of(context)!.translate("rate")!,
          callbackOnchage: (value) async {

            setState(() {
              // rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
              discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
              discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
              igst.text=igst.text!=""?double.parse(igst.text).toStringAsFixed(2):"";
              quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
              rate.text = value;
              previousRate=value;
              amountedited=false;
              discountamtedited=false;
            });
            await calculateRates();
            setState(() {
              showButton=true;
            });
            // _rateKey.currentState!.validate();
          },
          textInput: const TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),
*/
      SingleLineEditableTextFormField(
         // parentWidth: parentWidth,
          validation: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
          readOnly:  widget.setText==StringEn.saleOrder?false:widget.readOnly,
          controller: amount,
          focuscontroller: amountFocus,
          focusnext: discountFocus,
          title: ApplicationLocalizations.of(context)!.translate("rate")!,
        //  title: ApplicationLocalizations.of(context)!.translate("amount")!,
          callbackOnchage: (value) async {
            print("########### $value");
            setState(() {
              // rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
              // discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
              // discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
              // igst.text=igst.text!=""?double.parse(igst.text).toStringAsFixed(2):"";
              // quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
               amount.text = value;
               rate.text = value;
              amountedited=true;
              discountamtedited=false;
            });
         //   await calculateRates();
            setState(() {
              showButton=true;
            });
            // await calculateRates();
          },
          textInput: const TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),
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
          readOnly: widget.setText==StringEn.saleOrder?false:widget.readOnly,
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
              igst.text=igst.text!=""?double.parse(igst.text).toStringAsFixed(2):"";
              quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
              discountamtedited=false;
              discount.text = value;
            });
            await calculateDiscountAmt();

            await calculateRates();
            setState(() {
              showButton=true;
            });
          },
          textInput: const TextInputType.numberWithOptions(
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
            readOnly:widget.setText==StringEn.saleOrder?false: widget.readOnly,
            controller: discountAmt,
            focuscontroller: discountAmtFocus,
            focusnext: igstFocus,
            title:
            ApplicationLocalizations.of(context)!.translate("discount_amount")!,
            callbackOnchage: (value) async {
              setState(() {
                rate.text=rate.text!=""?double.parse(rate.text).toStringAsFixed(2):"";
                discount.text=discount.text!=""?double.parse(discount.text).toStringAsFixed(2):"";
                // discountAmt.text=discountAmt.text!=""?double.parse(discountAmt.text).toStringAsFixed(2):"";
                igst.text=igst.text!=""?double.parse(igst.text).toStringAsFixed(2):"";
                quantity.text=quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):"";
                discountAmt.text = value;
                discountamtedited=true;
              });
              await calculateRates();
              setState(() {
                showButton=true;
              });
            },
            textInput: const TextInputType.numberWithOptions(
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



  /* widget for product igst layout */
  Widget getItemNetRateAndNetAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetDisableTextFormField(
            parentWidth: (parentWidth),
            title: ApplicationLocalizations.of(context)!.translate("net_rate")!,
            controller: netRate),
        SingleLineEditableTextFormField(
            mandatory: false,
            txtkey: null,
            parentWidth: (parentWidth),
            validation: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
            readOnly: quantity.text!=""?true:false,
            controller: netAmount,
            focuscontroller: null,
            focusnext: null,
            title: ApplicationLocalizations.of(context)!.translate("net_amount")!,
            callbackOnchage: (value) async {

              setState(() {
                netAmount.text = value;
              });
              await calculateReverseRate();
              setState(() {
                showButton=true;
              });
            },
            textInput: TextInputType.numberWithOptions(
                decimal: true
            ),
            maxlines: 1,
            format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
        ),
      ],
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
        //  bottom: 10,
      ),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }

  /* Widget for Buttons Layout */
  Widget getAddForButtonsLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: GestureDetector(
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
        ),
       showButton==true? GestureDetector(
          onTap: () {
            // bool v=_itemKey.currentState!.validate();
            // bool q=_quantityKey.currentState!.validate();
            // bool r=_rateKey.currentState!.validate();
            if ( selectedItemID!=null/*&& v && q && r*/) {
              var item = {};
              if (widget.editproduct != null) {
                item = {
                  "Ledger_ID": selectedItemID,
                  "Ledger_Name": selectedLedgerName,
               //   "Unit": widget.unitP!=""? widget.unitP:null,
                  "Rate": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Quantity":"1",

                  /*     // "New_Item_Code": selectedItemID,
                  // "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                  "Item_Code": selectedItemID,
                  "Item_Name": selectedItemName,
                  "Batch_ID":batchId.text!=""?batchId.text:null,
                  "Store_ID":selectStoreId!=""?selectStoreId:null,
                  "Store_Name":selectStoreName!=""?selectStoreName:null,
                  "Quantity": quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                  "Unit": unit.text!=""?unit.text:null,
                  "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Disc_Percent": discount.text!=""?double.parse(double.parse(discount.text).toStringAsFixed(2)):null,
                  "Disc_Amount": discountAmt.text!=""?double.parse(double.parse(discountAmt.text).toStringAsFixed(2)):null,
                  "Taxable_Amount": taxableAmt.text!=""?double.parse(double.parse(taxableAmt.text).toStringAsFixed(2)):null,
                  "IGST_Rate": igst.text!=""?double.parse(double.parse(igst.text).toStringAsFixed(2)):null,
                  "IGST_Amount":igstAmount.text!=""?double.parse(double.parse(igstAmount.text).toStringAsFixed(2)):null,
                  "CGST_Rate": cgst.text!=""?double.parse(double.parse(cgst.text).toStringAsFixed(2)):null,
                  "CGST_Amount":cgstAmount.text!=""?double.parse(double.parse(cgstAmount.text).toStringAsFixed(2)):null,
                  "SGST_Rate": sgst.text!=""?double.parse(double.parse(sgst.text).toStringAsFixed(2)):null,
                  "SGST_Amount":sgstAmount.text!=""?double.parse(double.parse(sgstAmount.text).toStringAsFixed(2)):null,
                  "Net_Rate":netRate.text!=""?double.parse(double.parse(netRate.text).toStringAsFixed(2)):null,
                  "Net_Amount": netAmount.text!=""?double.parse(double.parse(netAmount.text).toStringAsFixed(2)):null,
                  "Item_Type":"O",
                  "Dispatch_Type": "O",
                  "Order_No": orderno,
                  "Packing_Quantity":  pack_quantity.text!=""?double.parse(pack_quantity.text.toString()).toStringAsFixed(2):null,
                  "Packing_Unit": unit2.text!=""?unit2.text:null,
              */  };
              } else {
                item = {
                  "Ledger_ID": selectedItemID,
                  "Ledger_Name": selectedLedgerName,
                 // "Unit": widget.unitP!=""? widget.unitP:null,
                  "Rate": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  "Quantity":"1",
                  // "Batch_ID":batchId.text!=""?batchId.text:null,
                  // "Store_ID":selectStoreId!=""?selectStoreId:null,
                  // "Store_Name":selectStoreName!=""?selectStoreName:null,

                  // "Quantity":quantity.text!=""?double.parse(quantity.text).toStringAsFixed(2):null,
                  // "Unit": unit.text!=""?unit.text:null,
                  // "Rate":rate.text!=""?double.parse(double.parse(rate.text).toStringAsFixed(2)):null,
                  // "Amount": amount.text!=""?double.parse(double.parse(amount.text).toStringAsFixed(2)):null,
                  // "Disc_Percent": discount.text!=""?double.parse(double.parse(discount.text).toStringAsFixed(2)):null,
                  // "Disc_Amount": discountAmt.text!=""?double.parse(double.parse(discountAmt.text).toStringAsFixed(2)):null,
                  // "Taxable_Amount": taxableAmt.text!=""?double.parse(double.parse(taxableAmt.text).toStringAsFixed(2)):null,
                  // "IGST_Rate": igst.text!=""?double.parse(double.parse(igst.text).toStringAsFixed(2)):null,
                  // "IGST_Amount":igstAmount.text!=""?double.parse(double.parse(igstAmount.text).toStringAsFixed(2)):null,
                  // "CGST_Rate": cgst.text!=""?double.parse(double.parse(cgst.text).toStringAsFixed(2)):null,
                  // "CGST_Amount":cgstAmount.text!=""?double.parse(double.parse(cgstAmount.text).toStringAsFixed(2)):null,
                  // "SGST_Rate": sgst.text!=""?double.parse(double.parse(sgst.text).toStringAsFixed(2)):null,
                  // "SGST_Amount":sgstAmount.text!=""?double.parse(double.parse(sgstAmount.text).toStringAsFixed(2)):null,
                  // "Net_Rate":netRate.text!=""?double.parse(double.parse(netRate.text).toStringAsFixed(2)):null,
                  // "Net_Amount": netAmount.text!=""?double.parse(double.parse(netAmount.text).toStringAsFixed(2)):null ,
                  // "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                  // "Item_Type":"O",
                  // "Dispatch_Type": "O",
                  // "Order_No": null,
                  // "Packing_Quantity": pack_quantity.text!=""?double.parse(pack_quantity.text).toStringAsFixed(2):null,
                  // "Packing_Unit": unit2.text!=""?unit2.text:null,
                };
              }

              print(item);
              if (widget.mListener != null) {
                widget.mListener.AddOrEditInvoiceAdditionDetail(item);
                Navigator.pop(context);
              }
            }
            else {
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
                  style: text_field_textStyle.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ):Container(),
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
    print("#########Tax Amount => ${taxableAmt.text}");
    var taxbleAmunt = taxableAmt.text == "" ? null : double.parse(taxableAmt.text);
    var igstText = igst.text == "" ? null : double.parse(igst.text);
    var cgstText = cgst.text == "" ? null : double.parse(cgst.text);
    var sgstText = sgst.text == "" ? null : double.parse(sgst.text);
    print("#########TAX => ${taxbleAmunt}");

    if(taxableAmt!=null && igstText!=null) {

      var igstAmt = taxbleAmunt! * (igstText / 100);
      setState(() {
        igstAmount.text = igstAmt.toStringAsFixed(2);
      });
    }
     if(taxableAmt!=null && cgstText!=null){
       print("#########CGST => ${taxableAmt.text}");
      var cgstAmt = taxbleAmunt! * (cgstText! / 100);
      setState(() {
        cgstAmount.text = cgstAmt.toStringAsFixed(2);
      });

    }
     if(taxableAmt!=null && sgstText!=null){
       print("#########SGST => ${taxableAmt.text}");
      var sgstAmt = taxbleAmunt! * (sgstText! / 100);
      setState(() {
        sgstAmount.text = sgstAmt.toStringAsFixed(2);
      });

    }
    if(igstText==null){
      setState(() {
        igstAmount.clear();
      });
    }
    if(cgstText==null){
      setState(() {
        cgstAmount.clear();
      });
    }
    if(sgstText==null){
      setState(() {
        sgstAmount.clear();
      });
    }
  }

  calculateNetAmt() {
    double taxbleAmunt =
    taxableAmt.text == "" ? 0.0 : double.parse(taxableAmt.text);
    double igstAmt = igstAmount.text == "" ? 0.0 : double.parse(igstAmount.text);
    double cgstAmt = cgstAmount.text == "" ? 0.0 : double.parse(cgstAmount.text);
    double sgstAmt = sgstAmount.text == "" ? 0.0 : double.parse(sgstAmount.text);

    if(igstAmount.text!="") {
      var netamt = taxbleAmunt + igstAmt;
      setState(() {
        netAmount.text = netamt.toStringAsFixed(2);
      });
    }
    else {
      var netamt = taxbleAmunt + cgstAmt + sgstAmt;
      setState(() {
        netAmount.text = netamt.toStringAsFixed(2);
      });
    }
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

    print("EEEEEEEEEEE ${previousRate}");
    if(amountedited && quantity.text!=""){
      print("DDDDDDD ${amount.text}");
      if(amount.text!=""  && quantity.text!="") {
        var amt = double.parse(amount.text) / double.parse(quantity.text);
        print("RRRRRr ${amt}");
        setState(() {
          rate.text = amt.toStringAsFixed(2);
        });
      }
      if(amount.text==""){
        setState(() {
          rate.clear();
           taxableAmt.clear();
          discountAmt.clear();
          igstAmount.clear();
          cgstAmount.clear();
          sgstAmount.clear();
          netRate.clear();
          netAmount.clear();

        });
      }
    }
    if (quantity.text != "" && rate.text != "") {
      if(amountedited==false) {
        await calculateAmt();
      }


      await calculateDiscountAmt();
      await calculateTaxableAmt();
      await calculateGstAmt();
      await calculateNetAmt();
      await calculateNetRate();
    }
    if (quantity.text == "" || rate.text == "") {
      setState(() {
        amount.clear();
      });
    }
    if(rate.text==""){
      setState(() {
        taxableAmt.clear();
        netRate.clear();
        netAmount.clear();
      });
    }
    // if(amount.text==""){
    //   setState(() {
    //     rate.text=double.parse(previousRate).toStringAsFixed(2);
    //   });
    // }
    if(quantity.text==""){
      setState(() {
        amount.clear();
      });
    }
  }

  calculateReverseRate()async{
    var dis= discount.text == "" ? null : double.parse(discount.text);
    var igstText = igst.text == "" ? null : double.parse(igst.text);
    var cgstText = cgst.text == "" ? null : double.parse(cgst.text);
    var sgstText = sgst.text == "" ? null : double.parse(sgst.text);
    double quantityAmt = quantity.text == "" ? 0.0 : double.parse(quantity.text);
    print("############ $quantityAmt ${netAmount.text}");
    if(quantityAmt!=0.0 && netAmount.text!="") {
      var netAmt = double.parse(netAmount.text);
      var newnetrate = netAmt / quantityAmt;
      var newtaxable = 0.0;
      if (igstText != null) {
        newtaxable = netAmt / (1 + igstText / 100);
        print("NEW TAXABLE : $taxableAmt");
      }
      else if (cgstText != null && sgstText != null) {
        newtaxable = netAmt / (1 + (cgstText + sgstText) / 100);
        print("NEW TAXABLE : $taxableAmt");
      }
      else {
        newtaxable = netAmt;
      }
      var newamt = 0.0;
      if (dis != null) {
        newamt = newtaxable / (1 - dis / 100);
      }
      else {
        newamt = newtaxable;
      }
      var newrate = 0.0;
      if ((newamt != 0.0 || newamt != null) && quantityAmt != null) {
        newrate = newamt / quantityAmt;
      }

      setState(() {
        netRate.text = newnetrate.toStringAsFixed(2);
        taxableAmt.text = newtaxable.toStringAsFixed(2);
        amount.text = newamt.toStringAsFixed(2);
        rate.text = newrate.toStringAsFixed(2);

      });
      if(taxableAmt!=null && igstText!=null) {

        var igstAmt = newtaxable! * (igstText / 100);
        setState(() {
          igstAmount.text = igstAmt.toStringAsFixed(2);
        });
      }
      if(taxableAmt!=null && cgstText!=null){
        print("#########CGST => ${taxableAmt.text}");
        var cgstAmt = newtaxable! * (cgstText! / 100);
        setState(() {
          cgstAmount.text = cgstAmt.toStringAsFixed(2);
        });

      }
      if(taxableAmt!=null && sgstText!=null){
        print("#########SGST => ${taxableAmt.text}");
        var sgstAmt = newtaxable! * (sgstText! / 100);
        setState(() {
          sgstAmount.text = sgstAmt.toStringAsFixed(2);
        });

      }

    }
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
      String apiUrl = baseurl + ApiConstants().item + "?Party_ID=${widget.id}&Date=${widget.date}&Category=null&"+"Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            isLoaderShow=false;
            ledger_list=[];
            if(data!=null){
              setState(() {
                ledger_list = data;

              });

              var index = null;

              print(ledger_list.length);
              for (var i in ledger_list) {
                print("INDEXI ${selectedItemName}  ${i['Name']} ");
                if (i['Name'] == selectedItemName) {
                  index = ledger_list.indexOf(i);
                  break;
                }
              }
              setState(() {
                unit2factor= ledger_list[index]['Unit2_Factor'] != null ? ledger_list[index]['Unit2_Factor'] :null;
                unit2base= ledger_list[index]['Unit2_Base'] != null ? ledger_list[index]['Unit2_Base'] :null;
              });

              // }

              print(" FFFFFFFFFFFFFF ${ledger_list.length} }");

            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);


          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

            
          });

    });
  }
}

abstract class AddOrEditInvoiceAdditionInterface {
  AddOrEditInvoiceAdditionDetail(dynamic item);
}
