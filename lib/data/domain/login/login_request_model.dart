
class LoginRequestModel {
  LoginRequestModel({
    String? Password,
    String? UID,
    String? Machine_Name,}){
    _Password = Password;
    _UID = UID;
    _Machine_Name = Machine_Name;
  }

  LoginRequestModel.fromJson(dynamic json) {
    _Password = json['Password'];
    _UID = json['UID'];
    _Machine_Name = json['Machine_Name'];
  }
  String? _Password;
  String? _UID;
  String? _Machine_Name;

  String? get Password => _Password;
  String? get UID => _UID;
  String? get Machine_Name => _Machine_Name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Password'] = _Password;
    map['UID'] = _UID;
    map['Machine_Name'] = _Machine_Name;
    return map;
  }

}