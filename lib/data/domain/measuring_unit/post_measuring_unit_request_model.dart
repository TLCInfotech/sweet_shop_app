class PostMeasuringUnitRequestModel {
  String code;
  String creator;
  String creatorMachine;
  String companyId;

  PostMeasuringUnitRequestModel({
    required this.companyId,
    required this.code,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId,
      'Code': code,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
