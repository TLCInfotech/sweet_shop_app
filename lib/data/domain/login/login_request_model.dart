
class LoginRequestModel {
  LoginRequestModel({
    String? Password,
    String? UID,
    String? PushKey,
    String? Machine_Name,}){
    _Password = Password;
    _UID = UID;
    _PushKey = PushKey;
    _Machine_Name = Machine_Name;
  }

  LoginRequestModel.fromJson(dynamic json) {
    _Password = json['Password'];
    _UID = json['UID'];
    _PushKey = json['PushKey'];
    _Machine_Name = json['Modifier_Machine'];
  }
  String? _Password;
  String? _UID;
  String? _PushKey;
  String? _Machine_Name;

  String? get Password => _Password;
  String? get UID => _UID;
  String? get PushKey => _PushKey;
  String? get Machine_Name => _Machine_Name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Password'] = _Password;
    map['UID'] = _UID;
    map['PushKey'] = _PushKey;
    map['Modifier_Machine'] = _Machine_Name;
    return map;
  }

}