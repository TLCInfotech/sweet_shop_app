class PostLedgerGroupRequestModel {
  String name;
  String seqNo;
  String? parentId;
  String? Lang;
  String groupNature;
  String creator;
  String creatorMachine;
  String companyID;

  PostLedgerGroupRequestModel({
    required this.name,
    required this.seqNo,
    this.parentId,
    this.Lang,
    required this.groupNature,
    required this.creator,
    required this.creatorMachine,
    required this.companyID,
  });

  factory PostLedgerGroupRequestModel.fromJson(Map<String, dynamic> json) {
    return PostLedgerGroupRequestModel(
      companyID: json['Company_ID'],
      name: json['Name'],
      seqNo: json['Seq_no'],
      Lang: json['Lang'],
      parentId: json['Parent_ID'],
      groupNature: json['Group_Nature'],
      creator: json['Creator'],
      creatorMachine: json['Creator_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyID,
      'Name': name,
      'Lang': Lang,
      'Seq_no': seqNo,
      'Parent_ID': parentId,
      'Group_Nature': groupNature,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
