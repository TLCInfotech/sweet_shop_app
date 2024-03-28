
class PostJournalRequestModel {
  String? companyID;
  String? date;
  String? dateNew;

  String? voucherNo;
  int? seqNo;
  String? voucherName;
  double? totalAmount;
  String? remark;
  String? creator;
  String? creatorMachine;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  PostJournalRequestModel(
      {this.companyID,
        this.date,
        this.dateNew,
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

  PostJournalRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    date = json['Date'];
    dateNew = json['New_Date'];

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
    data['New_Date'] = this.dateNew;
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


