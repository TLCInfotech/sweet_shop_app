

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? prefs;


  /*set deviceId value in SharedPreferences*/
  static Future<String> getMasterMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("masterMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setMasterMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("masterMenu", list);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getTransactionMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("transactionMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setTransactionMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("transactionMenu", list);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getReportMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("reportMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setReportMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("reportMenu", list);
  }


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
  static Future<String> getLang() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("en_IN") ?? "en_IN";
  }

  /*get deviceId value form SharedPreferences*/
  static setLang(String en_IN) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("en_IN   $en_IN");
    prefs.setString("en_IN", en_IN);
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


  /*set companyName value in SharedPreferences*/
  static Future<String> getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyName") ?? "";
  }

/*get companyName value form SharedPreferences*/
  static setCompanyName(String companyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("companyName", companyName);
  }

  /*set companyName value in SharedPreferences*/
  static Future<String> getCompanyUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyUrl") ?? "";
  }

/*get companyName value form SharedPreferences*/
  static setCompanyUrl(String companyUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("companyUrl", companyUrl);
  }


  static Future<void> setWorkingDays(int workd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("workd: $workd");
    await prefs.setInt("workd", workd);
  }

  /* Get deviceId value from SharedPreferences */
  static Future<int> getWorkingDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("workd") ?? -1;  // Return 0 if the value is not found
  }
  static clearAppPreference() async {
    prefs = await getInstance();
    prefs!.remove("sessionToken");
    prefs!.remove("workd");
  }

  static dateClear()async{
    prefs = await getInstance();
    prefs!.remove("date");
    prefs!.remove("workd");
  }

}
