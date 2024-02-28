class PutLedgerGroupRequestModel {
  String name;
  String seqNo;
  String? parentId;
  String groupNature;
  String Modifier;
  String creatorMachine;

  PutLedgerGroupRequestModel({
    required this.name,
    required this.seqNo,
    this.parentId,
    required this.groupNature,
    required this.Modifier,
    required this.creatorMachine,
  });

  factory PutLedgerGroupRequestModel.fromJson(Map<String, dynamic> json) {
    return PutLedgerGroupRequestModel(
      name: json['Name'],
      seqNo: json['Seq_no'],
      parentId: json['Parent_ID'],
      groupNature: json['Group_Nature'],
      Modifier: json['Modifier'],
      creatorMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Seq_no': seqNo,
      'Parent_ID': parentId,
      'Group_Nature': groupNature,
      'Modifier': Modifier,
      'Modifier_Machine': creatorMachine,
    };
  }
}
