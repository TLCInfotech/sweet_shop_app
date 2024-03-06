class DeleteMeasuringUnitRequestModel {
  String code;
  String modifier;
  String modifierMachine;

  DeleteMeasuringUnitRequestModel({
    required this.code,
    required this.modifier,
    required this.modifierMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}
