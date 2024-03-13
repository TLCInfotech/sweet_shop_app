class PutMeasuringUnitRequestModel {
  String code;
  String newCode;
  String modifier;
  String modifierMachine;
  String companyId;

  PutMeasuringUnitRequestModel({
    required this.companyId,
    required this.code,
    required this.newCode,
    required this.modifier,
    required this.modifierMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId,
      'Code': code,
      'NewCode': newCode,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}