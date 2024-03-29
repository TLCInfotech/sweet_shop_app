class postCreditDebitNoterequestModel {
  String? invoiceNo;
  String? companyID;
  String? date;
  String? dateNew;
  String? vendorID;
  String? voucherName;
  String? ledgerID;
  double? totalAmount;
  double? roundOff;
  String? remark;
  String? modifier;
  String? modifierMachine;
  String? creator;
  String? creatorMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  postCreditDebitNoterequestModel(
      {this.invoiceNo,
        this.companyID,
        this.date,
        this.dateNew,
        this.vendorID,
        this.voucherName,
        this.ledgerID,
        this.totalAmount,
        this.roundOff,
        this.remark,
        this.modifier,
        this.modifierMachine,
        this.creator,
        this.creatorMachine,
        this.iNSERT,
        this.dELETE,
        this.uPDATE});

  postCreditDebitNoterequestModel.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['Invoice_No'];
    companyID = json['Company_ID'];
    date = json['Date'];
    dateNew = json['New_Date'];
    vendorID = json['Vendor_ID'];
    voucherName = json['Voucher_Name'];
    ledgerID = json['Ledger_ID'];
    totalAmount = json['Total_Amount'];
    roundOff = json['Round_Off'];
    remark = json['Remark'];
    modifier = json['Modifier'];
    modifierMachine = json['Modifier_Machine'];
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
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
    data['Invoice_No'] = this.invoiceNo;
    data['Company_ID'] = this.companyID;
    data['Date'] = this.date;
    data['New_Date'] = this.dateNew;
    data['Vendor_ID'] = this.vendorID;
    data['Voucher_Name'] = this.voucherName;
    data['Ledger_ID'] = this.ledgerID;
    data['Total_Amount'] = this.totalAmount;
    data['Round_Off'] = this.roundOff;
    data['Remark'] = this.remark;
    data['Modifier'] = this.modifier;
    data['Modifier_Machine'] = this.modifierMachine;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
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
