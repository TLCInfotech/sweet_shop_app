class PutItemCategoryRequestModel {
  String? name;
  String? parentId;
  String? seqNo;
  String? modifier;
  String? modifierMachine;
  String? companyId;

  PutItemCategoryRequestModel({
     this.name,
     this.parentId,
     this.seqNo,
    required this.companyId,
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
      companyId: json['Company_ID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Parent_ID': parentId,
      'Seq_No': seqNo,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
      // 'Company_ID':companyId
    };
  }
}
