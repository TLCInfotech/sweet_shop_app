

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? prefs;

  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }



  /*set getDeviceType value in SharedPreferences*/
  static Future<String> getPushKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pushKey") ?? '0';
  }

/*get setDeviceType value form SharedPreferences*/
  static setPushKey(String pushKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("pushKey   $pushKey");
    prefs.setString("pushKey", pushKey);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getDeviceId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("deviceId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setDeviceId(String deviceId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("deviceId   $deviceId");
    prefs.setString("deviceId", deviceId);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getUId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("uId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setUId(String uId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("uId   $uId");
    prefs.setString("uId", uId);
  }
  /*set deviceId value in SharedPreferences*/
  static Future<String> getCompanyId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("cId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setCompanyId(String cId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $cId");
    prefs.setString("cId", cId);
  }

  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("sessionToken") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setSessionToken(String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sessionToken", sessionToken);
  }

  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getDomainLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("domainLink") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setDomainLink(String domainLink) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("domainLink", domainLink);
  }
  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getDateLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("date") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setDateLayout(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("date", date);
  }






  static clearAppPreference() async {
    prefs = await getInstance();
    prefs!.remove("sessionToken");
  }

  static dateClear()async{
    prefs = await getInstance();
    prefs!.remove("date");
  }
}
