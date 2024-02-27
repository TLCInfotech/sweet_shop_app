

class TokenRequestModel {
  TokenRequestModel({
    String? token,}){
    _token = token;
  }

  TokenRequestModel.fromJson(dynamic json) {
    _token = json['token'];
  }
  String? _token;

  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    return map;
  }

}
