class PostMeasuringUnitRequestModel {
  String code;
  String creator;
  String creatorMachine;

  PostMeasuringUnitRequestModel({
    required this.code,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
