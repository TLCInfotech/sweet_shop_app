class DeleteIRequestModel {
  String id;
  String modifier;
  String modifierMachine;
  String companyId;

  DeleteIRequestModel({
    required this.id,
    required this.modifier,
    required this.modifierMachine,
    required this.companyId,
  });

  factory DeleteIRequestModel.fromJson(Map<String, dynamic> json) {
    return DeleteIRequestModel(
      id: json['ID'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
      companyId: json['Company_ID']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
      'Company_ID':companyId
    };
  }
  
}
