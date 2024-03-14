class PostFranchiseeItemOpeningRequestModel {
  String? companyID;
  String? franchiseeID;
  String? date;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  PostFranchiseeItemOpeningRequestModel(
      {this.companyID,
        this.franchiseeID,
        this.date,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  PostFranchiseeItemOpeningRequestModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    franchiseeID = json['Franchisee_ID'];
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
    data['Company_ID'] = this.companyID;
    data['Franchisee_ID'] = this.franchiseeID;
    data['Date'] = this.date;
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
