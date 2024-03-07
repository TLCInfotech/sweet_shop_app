class DeleteIUserRequestModel {
  String id;
  String modifier;
  String modifierMachine;

  DeleteIUserRequestModel({
    required this.id,
    required this.modifier,
    required this.modifierMachine,
  });

  factory DeleteIUserRequestModel.fromJson(Map<String, dynamic> json) {
    return DeleteIUserRequestModel(
      id: json['UID'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UID': id,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }

}
