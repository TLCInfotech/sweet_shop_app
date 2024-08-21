
class UserRightsModel {
  String? companyID;
  String? UID;
  String? Lang;
  String? creater;
  String? createrMachine;
  String? modifier;
  String? modifierMachine;
  List<dynamic>? iNSERT;
  List<dynamic>? uPDATE;
  List<dynamic>? dELETE;

  UserRightsModel(
      {this.companyID,
        this.UID,
        this.creater,
        this.Lang,
        this.createrMachine,
        this.modifier,
        this.modifierMachine,
        this.iNSERT,
        this.uPDATE,
        this.dELETE});

  UserRightsModel.fromJson(Map<String, dynamic> json) {
    companyID = json['Company_ID'];
    UID = json['UID'];
    Lang = json['Lang'];
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
    data['UID'] = this.UID;
    data['Lang'] = this.Lang;
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
