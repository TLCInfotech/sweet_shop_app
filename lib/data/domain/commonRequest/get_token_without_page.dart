

class TokenRequestWithoutPageModel {
  TokenRequestWithoutPageModel({
    String? token,String? page,}){
    _token = token;
  }

  TokenRequestWithoutPageModel.fromJson(dynamic json) {
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
