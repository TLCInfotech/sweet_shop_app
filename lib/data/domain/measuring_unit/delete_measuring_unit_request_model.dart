class DeleteMeasuringUnitRequestModel {
  String code;
  String modifier;
  String modifierMachine;
  String companyId;

  DeleteMeasuringUnitRequestModel({
    required this.code,
    required this.modifier,
    required this.modifierMachine,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
      'Company_ID':companyId,
    };
  }
}
