class PutLedgerGroupRequestModel {
  String name;
  String seqNo;
  String? parentId;
  String groupNature;
  String Modifier;
  String creatorMachine;
  String companuId;

  PutLedgerGroupRequestModel({
    required this.name,
    required this.seqNo,
    this.parentId,
    required this.groupNature,
    required this.Modifier,
    required this.creatorMachine,
    required this.companuId
  });

  factory PutLedgerGroupRequestModel.fromJson(Map<String, dynamic> json) {
    return PutLedgerGroupRequestModel(
      companuId: json['Company_ID'],
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
      'Company_ID':companuId,
      'Name': name,
      'Seq_no': seqNo,
      'Parent_ID': parentId,
      'Group_Nature': groupNature,
      'Modifier': Modifier,
      'Modifier_Machine': creatorMachine,
    };
  }
}
