class postPaymentRecieptRequestModel {
  int? companyID;
  String? date;
  int? ledgerID;
  int? voucherNo;
  int? seqNo;
  String? voucherName;
  int? totalAmount;
  String? remark;
  String? creator;
  String? creatorMachine;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  postPaymentRecieptRequestModel(
      {this.companyID,
        this.date,
        this.ledgerID,
        this.voucherNo,
        this.seqNo,
        this.voucherName,
        this.totalAmount,
        this.remark,
        this.creator,
        this.creatorMachine,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  postPaymentRecieptRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    date = json['Date'];
    ledgerID = json['Ledger_ID'];
    voucherNo = json['Voucher_No'];
    seqNo = json['Seq_No'];
    voucherName = json['Voucher_Name'];
    totalAmount = json['Total_Amount'];
    remark = json['Remark'];
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
    modifier = json['Modifier'];
    modifierMachine = json['Modifier_Machine'];
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
    data['Ledger_ID'] = this.ledgerID;
    data['Voucher_No'] = this.voucherNo;
    data['Seq_No'] = this.seqNo;
    data['Voucher_Name'] = this.voucherName;
    data['Total_Amount'] = this.totalAmount;
    data['Remark'] = this.remark;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
    data['Modifier'] = this.modifier;
    data['Modifier_Machine'] = this.modifierMachine;
    if (this.iNSERT != null) {
      data['INSERT'] = this.iNSERT!.map((v) => v.toJson()).toList();
    }
    if (this.uPDATE != null) {
      data['UPDATE'] = this.uPDATE!.map((v) => v.toJson()).toList();
    }
    if (this.dELETE != null) {
      data['DELETE'] = this.dELETE!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}