class PostLedgerGroupRequestModel {
  String name;
  String seqNo;
  String? parentId;
  String groupNature;
  String creator;
  String creatorMachine;

  PostLedgerGroupRequestModel({
    required this.name,
    required this.seqNo,
    this.parentId,
    required this.groupNature,
    required this.creator,
    required this.creatorMachine,
  });

  factory PostLedgerGroupRequestModel.fromJson(Map<String, dynamic> json) {
    return PostLedgerGroupRequestModel(
      name: json['Name'],
      seqNo: json['Seq_no'],
      parentId: json['Parent_ID'],
      groupNature: json['Group_Nature'],
      creator: json['Creator'],
      creatorMachine: json['Creator_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Seq_no': seqNo,
      'Parent_ID': parentId,
      'Group_Nature': groupNature,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}