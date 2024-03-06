class PutMeasuringUnitRequestModel {
  String code;
  String newCode;
  String modifier;
  String modifierMachine;

  PutMeasuringUnitRequestModel({
    required this.code,
    required this.newCode,
    required this.modifier,
    required this.modifierMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'NewCode': newCode,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}