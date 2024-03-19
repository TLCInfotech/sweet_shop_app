class PostExpenseInvoiceRequestModel {
  String? companyID;
  String? Ledger_ID;
  String? Voucher_Name;
  double? Total_Amount;
  double? Round_Off;
  String? date;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;

  PostExpenseInvoiceRequestModel(
      {this.companyID,
        this.Ledger_ID,
        this.Voucher_Name,
        this.Total_Amount,
        this.Round_Off,
        this.date,
        this.modifier,
        this.modifierMachine,
        this.iNSERT});

  PostExpenseInvoiceRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    Ledger_ID = json['Ledger_ID'];
    Voucher_Name = json['Voucher_Name'];
Total_Amount = json['Total_Amount'];
Round_Off = json['Round_Off'];
    date = json['Date'];
    modifier = json['Creator'];
    modifierMachine = json['Creator_Machine'];
    if (json['INSERT'] != null) {
      iNSERT = <dynamic>[];
      json['INSERT'].forEach((v) {
        iNSERT!.add( v.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Company_ID'] = this.companyID;
    data['Ledger_ID'] = this.Ledger_ID;
    data['Voucher_Name'] = this.Voucher_Name;
    data['Total_Amount'] = this.Total_Amount;
    data['Round_Off'] = this.Round_Off;
    data['Date'] = this.date;
    data['Creator'] = this.modifier;
    data['Creator_Machine'] = this.modifierMachine;
    if (this.iNSERT != null) {
      data['INSERT'] = this.iNSERT!.map((v) => v).toList();
    }

    return data;
  }
}
