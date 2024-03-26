class postJournalRequestModel {
  String? companyID;
  String? date;
  String? voucherName;
  String? voucherNo;
  String? creator;
  String? creatorMachine;
  String? modifierMachine;
  String? modifier;
  List<dynamic>? iNSERT;
  List<dynamic>? dELETE;
  List<dynamic>? uPDATE;

  postJournalRequestModel(
      {this.companyID,
        this.date,
        this.voucherName,
        this.voucherNo,
        this.creator,
        this.creatorMachine,
        this.modifierMachine,
        this.modifier,
        this.iNSERT,
        this.dELETE,
        this.uPDATE});

  postJournalRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    date = json['Date'];
    voucherName = json['Voucher_Name'];
    voucherNo = json['Voucher_No'];
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
    modifierMachine = json['Modifier_Machine'];
    modifier = json['Modifier'];
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
    data['Voucher_Name'] = this.voucherName;
    data['Voucher_No'] = this.voucherNo;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
    data['Modifier_Machine'] = this.modifierMachine;
    data['Modifier'] = this.modifier;
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
