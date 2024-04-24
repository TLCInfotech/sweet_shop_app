class PutUserRequestModel {
  String uid;
  //String? uidNew;
  String? ledgerID;
  String? Company_ID;
  String? workingDays;
  bool? active;
  bool resetPassword;
  String creator;
  String creatorMachine;
  late final List<int>? Photo;

  PutUserRequestModel({
    required this.uid,
  //   this.uidNew,
    required this.Company_ID,
    this.ledgerID,
    this.workingDays,
    this.active,
    required this.resetPassword,
    required this.creator,
    required this.creatorMachine,
   this.Photo
  });

  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      //'NewUID': uidNew,
      'Ledger_ID': ledgerID,
      'Company_ID': Company_ID,
      'Working_Days': workingDays,
      'Active': active,
      'Reset_Password': resetPassword,
      'Modifier': creator,
      'Modifier_Machine': creatorMachine,
      'Photo': this.Photo
    };
  }
}
