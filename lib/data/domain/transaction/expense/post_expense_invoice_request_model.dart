class PostExpenseInvoiceRequestModel {
  String? companyID;
  String? Ledger_ID;
  String? voucher_No;
  String? Voucher_Name;
  double? Total_Amount;
  double? Round_Off;
  String? date;
  String? creater;
  String? createrMachine;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  PostExpenseInvoiceRequestModel(
      {this.companyID,
        this.Ledger_ID,
        this.voucher_No,
        this.Voucher_Name,
        this.Total_Amount,
        this.Round_Off,
        this.date,
        this.creater,
        this.createrMachine,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  PostExpenseInvoiceRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    Ledger_ID = json['Ledger_ID'];
    voucher_No = json['Voucher_No'];
    Voucher_Name = json['Voucher_Name'];
Total_Amount = json['Total_Amount'];
Round_Off = json['Round_Off'];
    date = json['Date'];
    creater = json['Creator'];
    createrMachine = json['Creator_Machine'];
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
    data['Ledger_ID'] = this.Ledger_ID;
    data['Voucher_No']=this.voucher_No;
    data['Voucher_Name'] = this.Voucher_Name;
    data['Total_Amount'] = this.Total_Amount;
    data['Round_Off'] = this.Round_Off;
    data['Date'] = this.date;
    data['Creator'] = this.creater;
    data['Creator_Machine'] = this.createrMachine;
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
