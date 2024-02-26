/// status : "success"
/// data : {"current_page":1,"data":[{"id":1,"game_name":"game nine","type_of_player":1,"release_date":"2022-01-20","cover_picture":"https://s3.amazonaws.com/regenapps.com/gamergrid/cover/61e7bf86255068.93624389","video_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/video/61e7bf9b4ceaa0.36999418","development_studio":2,"game_id":0,"main_genre_id":2,"genre_id":2,"sub_genre_id":1,"game_banner_id":1,"status":1,"created_at":"-0001-11-30 00:00:00","updated_at":"-0001-11-30 00:00:00","selectedGame":"0","gameConsoles":[{"console_id":1,"console_name":"console-1","console_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/console/61dd6b6dae0a70.61742250","selectedConsole":"0"},{"console_id":5,"console_name":"console-5","console_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/console/61dd6ca2d126f7.47253176","selectedConsole":"0"}]}],"first_page_url":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data?page=1","from":1,"last_page":1,"last_page_url":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data?page=1","next_page_url":null,"path":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data","per_page":"10","prev_page_url":null,"to":1,"total":1}
/// message : "games list data Fetched successfully"
/// code : 200

class ApiResponseForFetch {
  ApiResponseForFetch({
    bool? status,
    var data,
    String? message,
    String? token,
    String? Machine_Name,
    int? code,
    String? validation_error,
  }) {
    _status = status;
    _data = data;
    _message = message;
    _token = token;
    _Machine_Name = Machine_Name;
    _code = code;
    _validation_error = validation_error;
    _s3_url = s3_url;
  }

  ApiResponseForFetch.fromJson(dynamic json) {
    _status = json['status'];
    _data = json['data'];
    _message = json['message'];
    _token = json['token'];
    _Machine_Name = json['Machine_Name'];
    _code = json['code'];
    _validation_error = json['validation_error'];
    _s3_url = json['s3_url'];
  }

  bool? _status;
  var _data;
  String? _message;
  String? _token;
  String? _Machine_Name;
  int? _code;
  String? _validation_error;
  String? _s3_url;

  bool? get status => _status;
  String? get validation_error => _validation_error;
  String? get token => _token;
  String? get Machine_Name => _Machine_Name;

  get data => _data;

  String? get message => _message;
  String? get s3_url => _s3_url;

  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data;
    }
    map['message'] = _message;
    map['token'] = _token;
    map['Machine_Name'] = _Machine_Name;
    map['code'] = _code;
    map['validation_error'] = _validation_error;
    map['s3_url'] = _s3_url;
    return map;
  }
}
