import 'package:flutter/material.dart';

class Util {


  /*Function for validate pan*/
  static bool isPanValid(String pan) {
    Pattern pattern = r'^([A-Z]){5}([0-9]){4}([A-Z]){1}$';
    RegExp regex = RegExp(pattern.toString());
    print(regex.hasMatch(pan));
    if (regex.hasMatch(pan)) {
      return false;
    } else if (pan.isEmpty) {
      return false;
    }
    return true;
  }

  /*Function for validate aadhar*/
  static bool isAadharValid(String aadhar) {
    Pattern pattern = r'^[2-9][0-9]{3} [0-9]{4} [0-9]{4}$';
    RegExp regex = RegExp(pattern.toString());
    StringBuffer result = StringBuffer();

    for (int i = 0; i < aadhar.length; i++) {
      result.write(aadhar[i]);

      if ((i + 1) % 4 == 0 && i != aadhar.length - 1) {
        result.write(' ');
      }
    }
    print(result.toString());
    print(regex.hasMatch("5890 0464 7395"));
    if (regex.hasMatch(result.toString())) {
      return false;
    }
    //  else if (aadhar.isEmpty) {
    //   return false;
    // }
    return true;
  }


  /*Function for validate email*/
  static bool isEmailValid(String email) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (email.length > 200) {
      return false;
    } else if (regex.hasMatch(email)) {
      return false;
    } else if (email.isEmpty) {
      return false;
    }
    return true;
  }

  static bool isSupportEmailValid(String email) {
    Pattern pattern =
        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.com";
    RegExp regex = new RegExp(pattern.toString());
    if (email.length > 200) {
      return false;
    } else if (regex.hasMatch(email)) {
      return false;
    } else if (email.isEmpty) {
      return false;
    }
    return true;
  }

  /*Here, we have validate entered password according to requirement*/
  static bool isPasswordValid(String password) {
    int passLength = password
        .trim()
        .length;
    return passLength < 5 || passLength > 21 ? false : true;
  }


  static bool isPasswordCharacterValid(String password) {
    Pattern pattern =
        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#^&?])[A-Za-z\d@$!%*#^&?]{6,}$";
    RegExp regex = new RegExp(pattern.toString());
    if (password.length < 6) {
      return false;
    } else if (!regex.hasMatch(password)) {
      return false;
    } else if (password.isEmpty) {
      return false;
    }
    return true;
  }


  /*Here, We have set 6 digits validation on OTP .*/
  static bool isOTPValid(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (value.length != 4) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*function for validate Full Name*/
  static bool isFullNameValid(String value) {
    String pattern = r'[a-zA-Z]{2,}';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty || value.length > 100) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*function for validate Last Name*/
  static bool isLastNameValid(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty || value.length > 100) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*Here, We have set 10 digits validation on mobile number.*/
  static bool isMobileValid(String value) {
    // String pattern =r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String pattern =r'^[6-9]\d{9}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    if (value.isEmpty) {
      return false;
    } else if (value.length < 10 || value.length > 13) {
      return false;
    } else
      if (regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*Here, We have set 10 digits validation on mobile number.*/
  static bool isZipCodeValid(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (value.length < 5 || value.length > 13) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*Here, We have set 10 digits validation on mobile number.*/
  static bool isWorkExperience(String value) {
    String pattern = r'(^\d{4}\s*-\s*\d{4}$)';
    RegExp regExp =  RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  // /*function for validate name*/
  // static bool isNameValid(String value) {
  //   String pattern = r'(^[a-zA-Z]*$)';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value.length <= 8 ) {
  //     return false;
  //   } else if (!regExp.hasMatch(value)) {
  //     return false;
  //   }
  //   return true;
  // }

  // static bool isUserNameValid(String value) {
  //   String pattern = r'(^[a-zA-Z0-9-_]+([._]?[a-zA-Z0-9-_.])*$)';
  //   RegExp regExp = new RegExp('[a-zA-Z0-9-_.]');
  //   if (value.length < 8 || value.length > 18) {
  //     return false;
  //   } else if (!regExp.hasMatch(value)) {
  //     return false;
  //   }
  //   return true;
  // }
  static bool isUserNameValid(String value) {
    String pattern = r'(^[a-zA-Z0-9-_]+([._]?[a-zA-Z0-9-_.])*$)';
    RegExp regExp = RegExp('[a-zA-Z0-9-_.]');
    if (value.length <= 8) {
      return false;
    }
    return true;
  }

  static bool isGameTitleValid(String value) {
    //String pattern = r'(^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$)';
    //RegExp regExp = new RegExp(pattern);
    if (value.length < 0) {
      return false;
    }
    return true;
  }

  static bool isSubject(String value) {
    // String pattern = r'(^[A-Za-z][A-Za-z0-9!@#$%^&*]*$)';
    // RegExp regExp =  RegExp(pattern);
    if (value.length < 3) {
      return false;
    }
    /*else if (!regExp.hasMatch(value)) {
      return false;
    }*/
    return true;
  }


  /*Function for validate email*/
  static bool isMultipleEmailValid(String email) {
    Pattern pattern =
        r'^(\s?[^\s,]+@[^\s,]+\.[^\s,]+\s?,)*(\s?[^\s,]+@[^\s,]+\.[^\s,]+)$';
    RegExp regex = new RegExp(pattern.toString());
    if (email.length < 5) {
      return false;
    } else if (!regex.hasMatch(email)) {
      return false;
    } else if (email.isEmpty) {
      return false;
    }
    return true;
  }

  /*Function for validate GST*/
  static bool isGSTValid(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9]*$";
    RegExp regex = RegExp(pattern.toString());
    if (value.length < 15) {
      return false;
    } else if (!regex.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*Function for validate GST*/
  static bool isCINNumberValid(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9]*$";
    RegExp regex = RegExp(pattern.toString());
    if (value.length < 21) {
      return false;
    }
    else if (!regex.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*Function for validate GST*/
  static bool isAboutUs(String value) {
    Pattern pattern =
        r'^(.|\s)*[a-zA-Z]+(.|\s)*$';
    RegExp regex = new RegExp(pattern.toString());
    if (value.length < 1) {
      return false;
    }
    return true;
  }

  /*Here, we have validate entered password acorrding to requiremnt*/
  static bool isAddressValid(String address) {
    String patttern = r'^[\w\s]+,\s\w{2}$';
    // RegExp regExp = new RegExp(patttern);
    if (address.length < 2) {
      return false;
    }
    // else if (!regExp.hasMatch(address)) {
    //   return false;
    // }
    return true;
  }

  /*Here, we have validate entered city to requiremnt*/
  static bool isCityValid(String address) {
    // String patttern = r'^[\w\s]+,\s\w{2}$';
    // RegExp regExp = RegExp(patttern);
    if (address.length < 2 || address.length > 30) {
      return false;
    }
    /*else if (!regExp.hasMatch(address)) {
      return false;
    }*/
    return true;
  }

  /*Here, We have set validation on Comments .*/
  static bool isDescriptionValidComment(String value) {
    bool status = false;
    int postLength = value.length;
    status = postLength >= 3 ? true : false;
    return status;
  }

  /*function for validate name*/
  static bool isVenue(String value) {
    String pattern = r'^(.|\s)*[a-zA-Z]+(.|\s)*$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /*function for validate name*/
  static bool isWeight(String value) {
    String pattern = r'^(0|[1-9]\d*)(,\d+)?$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }


  static bool isTitle(String value) {
    bool status = false;
    int postLength = value.length;
    status = postLength > 2 ? true : false;
    return status;
  }
}
class Utils {
  static launchURL(String url) async {
    try {
      await launchURL(
        url,
//         option: CustomTabsOption(
//           toolbarColor: Colors.blue,
//           enableDefaultShare: true,
//           enableUrlBarHiding: true,
//           showPageTitle: true,
// //          animation:  CustomTabsAnimation.slideIn(),
//           // or user defined animation.
//           animation: CustomTabsAnimation(
//             startEnter: 'slide_up',
//             startExit: 'android:anim/fade_out',
//             endEnter: 'android:anim/fade_in',
//             endExit: 'slide_down',
//           ),
//           extraCustomTabs: <String>[
//             // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
//             'org.mozilla.firefox',
//             // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
//             'com.microsoft.emmx',
//           ],
//         ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }}