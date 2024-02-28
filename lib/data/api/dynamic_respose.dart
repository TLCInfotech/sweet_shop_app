class ApiResponseForFetchDynamic {
  ApiResponseForFetchDynamic({
    bool? status,
    dynamic data,
    String? msg,
    String? token,
    String? Machine_Name,
    int? code,
    String? UID,
  }) {
    _status = status;
    _data = data;
    _msg = msg;
    _token = token;
    _Machine_Name = Machine_Name;
    _code = code;
    _UID = UID;
    _s3_url = s3_url;
  }

  ApiResponseForFetchDynamic.fromJson(dynamic json) {
    _status = json['status'];
    _data = json['data'];
    _msg = json['msg'];
    _token = json['token'];
    _Machine_Name = json['Machine_Name'];
    _code = json['code'];
    _UID = json['UID'];
    _s3_url = json['s3_url'];
  }

  bool? _status;
  dynamic _data;
  String? _msg;
  String? _token;
  String? _Machine_Name;
  int? _code;
  String? _UID;
  String? _s3_url;

  bool? get status => _status;
  String? get UID => _UID;
  String? get token => _token;
  String? get Machine_Name => _Machine_Name;

  dynamic get data => _data;

  String? get msg => _msg;
  String? get s3_url => _s3_url;

  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data;
    }
    map['msg'] = _msg;
    map['token'] = _token;
    map['Machine_Name'] = _Machine_Name;
    map['code'] = _code;
    map['UID'] = _UID;
    map['s3_url'] = _s3_url;
    return map;
  }
}
