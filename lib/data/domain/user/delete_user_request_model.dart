class DeleteIUserRequestModel {
  String id;
  String modifier;
  String modifierMachine;
  String companyId;

  DeleteIUserRequestModel({
    required this.id,
    required this.modifier,
    required this.modifierMachine,
    required this.companyId
  });

  factory DeleteIUserRequestModel.fromJson(Map<String, dynamic> json) {
    return DeleteIUserRequestModel(
      companyId: json['Company_ID'],
      id: json['UID'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId,
      'UID': id,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }

}
