import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sweet_shop_app/data/api/response_for_fetch.dart';
import 'package:sweet_shop_app/data/api/response_for_string_dynamic.dart';
import 'package:sweet_shop_app/presentation/dialog/ErrorOccuredDialog.dart';
import '../../core/app_preferance.dart';
import 'dynamic_respose.dart';

class ApiRequestHelper {
  ApiRequestHelper._internal();

  static final ApiRequestHelper apiRequestHelper = ApiRequestHelper._internal();
  ApiRequestHelper() {}
/*
  ApiRequestHelper() {}
  Map<String, String> headers = {
    'ClientId': 'd21e2b1ca62530cc0c861e1d5b8c1336c4937924',
    'ClientKey': 'cd4df2878c9302a5efaa8f59e291e1b98331fd55',
    'ApiKey': '2633439C4CAD4293B4E4D62838DB1',
  };
*/


  void callAPIsForPostLoginAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(String token, String uid) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    //  try {
  //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    Response response = await http.post(
      Uri.parse(apiUrl),
      body: requestBody,
    );
    print("response    ${response.body}");
    print("response    ${response.statusCode}");

    switch (response.statusCode) {
    /*response of api status id zero when something is wrong*/
      case 400:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        apiResponse = ApiResponseForFetch.fromJson(json.decode(response.body));
        onFailure(apiResponse.msg!);
        print("response.data  0 400 ${apiResponse.msg}");
        // CommonWidget.showInformationDialog(context, msg);
        break;
    /*response of api status id one when get api data Successfully */
      case 200:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        print("rfhjrjrfrjrfj   ${apiResponse.token}");
        apiResponse = ApiResponseForFetch.fromJson(json.decode(response.body));
        if(apiResponse.token!.isNotEmpty){
          AppPreferences.setSessionToken(apiResponse.token!);

        }
        // print('apiResponse.session_token_key!    ${apiResponse.session_token_key!}');
        AppPreferences.setDeviceId(apiResponse.Machine_Name!);
        AppPreferences.setUId(apiResponse.UID!);

        onSuccess(apiResponse.token!,apiResponse.UID!);

        break;
    /*response of api status id Two when session has expired */
      case 500:
      //  AppPreferences.clearAppPreference();
      // sessionExpire("errere");
      //  CommonWidget.gotoLoginPage(buildContext);
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        apiResponse =
            ApiResponseForFetch.fromJson(json.decode(response.body));
        onException(apiResponse.msg);
        break;
      case 400:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        apiResponse =
            ApiResponseForFetch.fromJson(json.decode(response.body));
        // AppPreferences.clearAppPreference();
        // sessionExpire("errere");
        onFailure(apiResponse.msg);
        //  CommonWidget.gotoLoginPage(buildContext);
        break;
    /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
      case 403:
        AppPreferences.clearAppPreference();
        sessionExpire("jhhh");
        break;
    //    }
    }
    /*  } catch (e) {
      print("e callAPIsForPostFetchAPI   $e");
      onException(e);
    }*/
  }




  void callAPIsForPostAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    Response response = await http.post(
      Uri.parse(apiUrl),
      body: requestBody,
    );

    switch (response.statusCode) {
    /*response of api status id zero when something is wrong*/
      case 400:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();

        apiResponse = ApiResponseForFetch.fromJson(json.decode(response.body));

        onFailure(apiResponse.msg!);
        print("response.data  0 400 ${apiResponse.msg}");

        // CommonWidget.showInformationDialog(context, msg);
        break;
    /*response of api status id one when get api data Successfully */
      case 200:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        print("rfhjrjrfrjrfj   ${apiResponse.token}");
        apiResponse = ApiResponseForFetch.fromJson(json.decode(response.body));
        if(apiResponse.token!.isNotEmpty){
          AppPreferences.setSessionToken(apiResponse.token!);

        }
        // print('apiResponse.session_token_key!    ${apiResponse.session_token_key!}');
        AppPreferences.setDeviceId(apiResponse.Machine_Name!);

        onSuccess(apiResponse.data!);

        break;
    /*response of api status id Two when session has expired */
      case 500:
      //  AppPreferences.clearAppPreference();
      // sessionExpire("errere");
      //  CommonWidget.gotoLoginPage(buildContext);
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        apiResponse =
            ApiResponseForFetch.fromJson(json.decode(response.body));
        onException(apiResponse.msg);
        break;
      case 400:
        ApiResponseForFetch apiResponse = ApiResponseForFetch();
        apiResponse =
            ApiResponseForFetch.fromJson(json.decode(response.body));
        // AppPreferences.clearAppPreference();
        // sessionExpire("errere");
        onFailure(apiResponse.msg);
        //  CommonWidget.gotoLoginPage(buildContext);
        break;
    /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
      case 403:
        AppPreferences.clearAppPreference();
        sessionExpire("jhhh");
        break;
    //    }
    }
    /*  } catch (e) {
      print("e callAPIsForPostFetchAPI   $e");
      onException(e);
    }*/
  }




  void callAPIsForPostMsgAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    Response response = await http.post(
      Uri.parse(apiUrl),
      body: requestBody,
    );
    switch (response.statusCode) {
    /*response of api status id zero when something is wrong*/
      case 400:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();

        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));

        onFailure(apiResponse.msg!);
        print("response.data  0 400 ${apiResponse.msg}");

        // CommonWidget.showInformationDialog(context, msg);
        break;
    /*response of api status id one when get api data Successfully */
      case 200:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onSuccess(apiResponse.msg!);

        break;
    /*response of api status id Two when session has expired */
      case 500:
      //  AppPreferences.clearAppPreference();
      // sessionExpire("errere");
      //  CommonWidget.gotoLoginPage(buildContext);
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse =
            ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onException(apiResponse.msg);
        break;
      case 400:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse =
            ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        // AppPreferences.clearAppPreference();
        // sessionExpire("errere");
        onFailure(apiResponse.msg);
        //  CommonWidget.gotoLoginPage(buildContext);
        break;
    /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
      case 403:
        AppPreferences.clearAppPreference();
        sessionExpire("jhhh");
        break;
    //    }
    }
    /*  } catch (e) {
      print("e callAPIsForPostFetchAPI   $e");
      onException(e);
    }*/
  }

  void callAPIsForGetAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
   // try {
      Response response = await http.get(
        Uri.parse(apiUrl),
      );
      print("   jnkjfwbhjfwbhjw   ${response.statusCode}");
      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onSuccess(apiResponse.data);
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          break;
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    /*}
    catch(e){
      print("ERROR $e");
      var err=e.toString();
      print(err.toString().contains("Connection failed"));
      if(e.toString().contains("Connection failed")==true) {
        print("INSIDE");
        onException("Check Internet Connection!");
      }
      else{
        onException(e.toString().substring(0,e.toString().indexOf(":")));
      }

    }*/

  }
  void callAPIsForGetStringDynamicAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
   // try {
      Response response = await http.get(
        Uri.parse(apiUrl),
      );
      print("   jnkjfwbhjfwbhjw   ${response.statusCode}");
      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
          apiResponse =
              ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
          apiResponse =
              ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
          onSuccess(apiResponse.data);
          break;
        case 500:
          ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
          apiResponse =
              ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          break;
        case 400:
          ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
          apiResponse =
              ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }

  }

  void callAPIsForDeleteAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    Response response = await http.delete(
        Uri.parse(apiUrl),
        body: requestBody
    );

    switch (response.statusCode) {
    /*response of api status id zero when something is wrong*/
      case 400:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onFailure(apiResponse.msg!);
        print("response.data  0 400 ${apiResponse.msg}");
        break;
      case 200:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onSuccess(apiResponse.msg!);
        print("responeseee  ");
        break;
      case 500:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse =
            ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onException(apiResponse.msg!);
        break;
      case 400:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse =
            ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onFailure(apiResponse.msg);
        break;
      case 403:
        AppPreferences.clearAppPreference();
        sessionExpire("jhhh");
        break;
    }

  }


  void callAPIsForPutAPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {


    Map<String, dynamic> cleanedData = {};

    requestBody.forEach((key, value) {
      if (value != null && value!="" && value.toString()!="[]") {
        cleanedData[key] = jsonDecode(jsonEncode(value));
      }
    });

    String jsonString = json.encode(cleanedData);

    print(apiUrl);

    Response response = await http.put(
        Uri.parse(apiUrl),
        body: jsonString,
        headers: {
          'Content-Type': 'application/json',
        }
    );

    print(response.statusCode);
    switch (response.statusCode) {
    /*response of api status id zero when something is wrong*/
      case 400:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();

        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));

        onFailure(apiResponse.msg!);
        print("response.data  0 400 ${apiResponse.msg}");

        // CommonWidget.showInformationDialog(context, msg);
        break;
    /*response of api status id one when get api data Successfully */
      case 200:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();

        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));


        onSuccess(apiResponse.data!);

        break;
    /*response of api status id Two when session has expired */
      case 500:
      //  AppPreferences.clearAppPreference();
      // sessionExpire("errere");
      //  CommonWidget.gotoLoginPage(buildContext);
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        onException(apiResponse.msg);
        break;
      case 404:
        ApiResponseForFetchStringDynamic apiResponse = ApiResponseForFetchStringDynamic();
        apiResponse = ApiResponseForFetchStringDynamic.fromJson(json.decode(response.body));
        // AppPreferences.clearAppPreference();
        // sessionExpire("errere");
        onFailure(apiResponse.msg);
        //  CommonWidget.gotoLoginPage(buildContext);
        break;
    /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
      case 403:
        AppPreferences.clearAppPreference();
        sessionExpire("jhhh");
        break;
        //    }
    }
    /*  } catch (e) {
      print("e callAPIsForPostFetchAPI   $e");
      onException(e);
    }*/
  }




  void callAPIsForDynamicPI(
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    String jsonString="";
    try {
      Map<String, dynamic> cleanedData = {};

      try {
        requestBody.forEach((key, value) {
          // print(value);
          if (value != null && value != "" && value.toString() != "[]") {
            cleanedData[key] = jsonDecode(jsonEncode(value));
          }
        });
        print("#########s#33ew");

        jsonString= json.encode(cleanedData);
        JsonEncoder encoder = new JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(json.decode(json.encode(cleanedData)));
        debugPrint(prettyprint);
      }

      catch(e){
        print("fasfasf");
        print(e);
      }
      Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );


      print("###################\n${response.statusCode}");

      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();

          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));

          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");

          // CommonWidget.showInformationDialog(context, msg);
          break;
      /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
         if(apiResponse.data!=null){
           onSuccess(apiResponse.data!);
         }else{
           onSuccess(apiResponse.msg!);
         }


          break;
      /*response of api status id Two when session has expired */
        case 500:
        //  AppPreferences.clearAppPreference();
        // sessionExpire("errere");
        //  CommonWidget.gotoLoginPage(buildContext);
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          print("@@@@@@@@@@@@@@@ ${apiResponse.data}");
          onException(apiResponse.msg);
          break;
        case 400:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          // AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          onFailure(apiResponse.msg);
          //  CommonWidget.gotoLoginPage(buildContext);
          break;
          case 404:
            ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));

          onFailure(apiResponse.msg);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      //    }
      }
      /*  } catch (e) {
      print("e callAPIsForPostFetchAPI   $e");
      onException(e);
    }*/
    }
    catch(e){
      print("ERROR: ######################");
      print("e callAPIsForPostFetchAPI   $e");
    }
  }
}
