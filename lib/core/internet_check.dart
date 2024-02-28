import 'dart:async';
// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetChecker {
  static late StreamSubscription<InternetConnectionStatus> mListener;

  static  checkInternet() async {
    mListener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          break;
        case InternetConnectionStatus.disconnected:
          break;
      }
    });

    return await InternetConnectionChecker().connectionStatus;
  }
}