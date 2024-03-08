class LoginUserRequestModel {
  String uid;
  String password;
  String modifier;
  String modifierMachine;

  LoginUserRequestModel({
    required this.uid,
    required this.password,
    required this.modifier,
    required this.modifierMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'Password': password,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
}