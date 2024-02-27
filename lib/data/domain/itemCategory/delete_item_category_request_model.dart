class DeleteItemCategoryRequestModel {
  String id;
  String modifier;
  String modifierMachine;

  DeleteItemCategoryRequestModel({
    required this.id,
    required this.modifier,
    required this.modifierMachine,
  });

  factory DeleteItemCategoryRequestModel.fromJson(Map<String, dynamic> json) {
    return DeleteItemCategoryRequestModel(
      id: json['ID'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
  
}
