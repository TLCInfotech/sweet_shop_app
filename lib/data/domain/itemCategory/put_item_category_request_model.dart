class PutItemCategoryRequestModel {
  String name;
  String parentId;
  String seqNo;
  String modifier;
  String modifierMachine;

  PutItemCategoryRequestModel({
    required this.name,
    required this.parentId,
    required this.seqNo,
    required this.modifier,
    required this.modifierMachine,
  });

  factory PutItemCategoryRequestModel.fromJson(Map<String, dynamic> json) {
    return PutItemCategoryRequestModel(
      name: json['Name'],
      parentId: json['Parent_ID'],
      seqNo: json['Seq_No'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Parent_ID': parentId,
      'Seq_No': seqNo,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}
