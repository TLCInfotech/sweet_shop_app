

class TokenRequestModel {
  TokenRequestModel({
    String? token,String? page,}){
    _token = token;
    _page = page;
  }

  TokenRequestModel.fromJson(dynamic json) {
    _token = json['token'];
    _page = json['pageNumber'];
  }
  String? _token;
  String? _page;

  String? get token => _token;
  String? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['pageNumber'] = _page;
    return map;
  }

}
