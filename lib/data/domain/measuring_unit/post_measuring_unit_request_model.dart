class PostMeasuringUnitRequestModel {
  String code;
  String creator;
  String creatorMachine;
  String? Lang;
  String companyId;

  PostMeasuringUnitRequestModel({
    required this.companyId,
    required this.code,
     this.Lang,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId,
      'Code': code,
      'Lang': Lang,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
