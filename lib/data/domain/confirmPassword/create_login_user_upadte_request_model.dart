class LoginUserRequestModel {
  String uid;
  String password;
  String modifier;
  String Lang;
  String modifierMachine;
  String companyId;

  LoginUserRequestModel({
    required this.companyId,
    required this.uid,
    required this.password,
    required this.Lang,
    required this.modifier,
    required this.modifierMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId,
      'UID': uid,
      'Lang': Lang,
      'Password': password,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}