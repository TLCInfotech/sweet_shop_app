class PostUserRequestModel {
  String uid;
  late final List<int>? photo;
  String Company_ID;
  String? ledgerID;
  String? workingDays;
  String? AppType;
  bool? active;
  bool resetPassword;
  String creator;
  String creatorMachine;

  PostUserRequestModel({
    required this.uid,
    required this.Company_ID,
    this.ledgerID,
    this.photo,
    this.workingDays,
    this.AppType,
    this.active,
    required this.resetPassword,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'Company_ID': Company_ID,
      'Ledger_ID': ledgerID,
      'Photo': photo,
      'Working_Days': workingDays,
      'AppType': AppType,
      'Active': active,
      'Reset_Password': resetPassword,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
