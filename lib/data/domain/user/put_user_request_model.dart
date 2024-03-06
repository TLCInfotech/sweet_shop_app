class PutUserRequestModel {
  String uid;
  String? ledgerID;
  String? workingDays;
  bool? active;
  bool resetPassword;
  String creator;
  String creatorMachine;

  PutUserRequestModel({
    required this.uid,
    this.ledgerID,
    this.workingDays,
    this.active,
    required this.resetPassword,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'Ledger_ID': ledgerID,
      'Working_Days': workingDays,
      'Active': active,
      'Reset_Password': resetPassword,
      'Modifier': creator,
      'Modifier_Machine': creatorMachine,
    };
  }
}
