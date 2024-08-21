class postSaleInvoiceRequestModel {
  String? companyID;
  String? date;
  String? dateNew;
  String? vendorID;
  String? Order_No;
  String? voucherName;
  String? saleLedger;
  String? purchaseLedger;
  double? totalAmount;
  double? roundOff;
  String? remark;
  String? Lang;
  String? creator;
  String? creatorMachine;
  String? modifier;
  String? modifierMachine;
  String? invoiceNo;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  postSaleInvoiceRequestModel(
      {this.companyID,
        this.date,
        this.dateNew,
        this.Lang,
        this.vendorID,
        this.voucherName,
        this.Order_No,
        this.saleLedger,
        this.purchaseLedger,
        this.totalAmount,
        this.roundOff,
        this.remark,
        this.creator,
        this.creatorMachine,
        this.modifier,
        this.modifierMachine,
        this.invoiceNo,
        this.iNSERT,
        this.uPDATE,
        this.dELETE,  });

  postSaleInvoiceRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    date = json['Date'];
    Lang = json['Lang'];
    Order_No = json['Order_No'];
    dateNew = json['New_Date'];
    vendorID = json['Vendor_ID'];
    voucherName = json['Voucher_Name'];
    saleLedger = json['Sale_Ledger'];
    purchaseLedger=json['Purchase_Ledger'];
    totalAmount = json['Total_Amount'];
    roundOff = json['Round_Off'];
    remark = json['Remark'];
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
    modifier = json['Modifier'];
    modifierMachine = json['Modifier_Machine'];
    invoiceNo = json['Invoice_No'];
    if (json['INSERT'] != null) {
      iNSERT = <dynamic>[];
      json['INSERT'].forEach((v) {
        iNSERT!.add( v.fromJson(v));
      });
    }
    if (json['UPDATE'] != null) {
      uPDATE = <dynamic>[];
      json['UPDATE'].forEach((v) {
        uPDATE!.add(v.fromJson(v));
      });
    }
    if (json['DELETE'] != null) {
      dELETE = <Null>[];
      json['DELETE'].forEach((v) {
        dELETE!.add( v.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Company_ID'] = this.companyID;
    data['Date'] = this.date;
    data['New_Date'] = this.dateNew;
    data['Lang'] = this.Lang;
    data['Vendor_ID'] = this.vendorID;
    data['Order_No'] = this.Order_No;
    data['Voucher_Name'] = this.voucherName;
    data['Sale_Ledger'] = this.saleLedger;
    data['Purchase_Ledger']=this.purchaseLedger;
    data['Total_Amount'] = this.totalAmount;
    data['Round_Off'] = this.roundOff;
    data['Remark'] = this.remark;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
    data['Modifier'] = this.modifier;
    data['Modifier_Machine'] = this.modifierMachine;
    data['Invoice_No'] = this.invoiceNo;
    if (this.iNSERT != null) {
      data['INSERT'] = this.iNSERT!.map((v) => v).toList();
    }
    if (uPDATE != null) {
      data['UPDATE'] = uPDATE!.map((v) => v).toList();
    }
    if (dELETE != null) {
      data['DELETE'] = dELETE!.map((v) => v).toList();
    }
    return data;
  }
}
