class PostILedgerOpeningRequestModel {
  String? companyID;
  String? date;
  String? lang;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  PostILedgerOpeningRequestModel(
      {this.companyID,
        this.date,
        this.lang,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  PostILedgerOpeningRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    date = json['Date'];
    lang = json['Lang'];
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
    data['Lang'] = this.lang;
    data['Modifier'] = this.modifier;
    data['Modifier_Machine'] = this.modifierMachine;
    if (this.iNSERT != null) {
      data['INSERT'] = this.iNSERT!.map((v) => v).toList();
    }
    if (this.uPDATE != null) {
      data['UPDATE'] = this.uPDATE!.map((v) => v).toList();
    }
    if (this.dELETE != null) {
      data['DELETE'] = this.dELETE!.map((v) => v).toList();
    }
    return data;
  }
}
