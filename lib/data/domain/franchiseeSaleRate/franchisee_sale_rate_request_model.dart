class FranchiseeSaleRequest {
  String? companyID;
  String? Txn_Type;
  String? lang;
  String? Franchisee_ID;
  String? date;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  FranchiseeSaleRequest(
      {this.companyID,
        this.date,
        this.lang,
        this.Txn_Type,
        this.Franchisee_ID,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  FranchiseeSaleRequest.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    Txn_Type = json['Txn_Type'];
    lang = json['Lang'];
    Franchisee_ID = json['Franchisee_ID'];
    date = json['Date'];
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
    data['Company_ID'] = companyID;
    data['Txn_Type'] = Txn_Type;
    data['Lang'] = lang;
    data['Franchisee_ID'] = Franchisee_ID;
    data['Date'] = date;
    data['Modifier'] = modifier;
    data['Modifier_Machine'] = modifierMachine;
    if (iNSERT != null) {
      data['INSERT'] = iNSERT!.map((v) => v).toList();
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
