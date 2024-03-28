import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/menu/master/company_user/create_user.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/user/delete_user_request_model.dart';
import '../../../common_widget/deleteDialog.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> with UserCreateInterface {
  int page = 1;
  bool isPagination = true;
  List<dynamic> userList = [];
  final ScrollController _scrollController = new ScrollController();
  bool isLoaderShow = false;
  bool isApiCall = false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var editedItem = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetUser(page);
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetUser(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFfffff5),
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: SafeArea(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Colors.transparent,
                // color: Colors.red,
                margin:  EdgeInsets.only(top: 10, left: 10, right: 10),
                child: AppBar(
                  leadingWidth: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Colors.white,
                  title:  Center(
                    child: Text(
                      ApplicationLocalizations.of(context)!.translate("user")!,
                      style: appbar_text_style,
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserCreate(
                              mListener: this,
                            )));
              }),
          body: Container(
            margin: const EdgeInsets.all(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    get_users_list_layout()
                  ],
                ),
                Visibility(
                    visible: userList.isEmpty && isApiCall ? true : false,
                    child: getNoData(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
              ],
            ),
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /*widget for no data*/
  Widget getNoData(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "No data available.",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 4.2,
            fontFamily: 'Inter_Medium_Font',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Expanded get_users_list_layout() {
    return Expanded(
        child: RefreshIndicator(
      color: CommonColor.THEME_COLOR,
      onRefresh: () {
        return refreshList();
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: userList.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -44.0,
              child: FadeInAnimation(
                delay: const Duration(microseconds: 1500),
                child: GestureDetector(
                  onTap: () {
                    editedItem = userList[index];

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserCreate(
                                  editUser: userList[index],
                                  mListener: this,
                                )));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              radius: 35,
                              backgroundColor: (index) % 2 == 0
                                  ? Colors.green
                                  : Colors.blueAccent,
                              child: const FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                            child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 40, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${userList[index]['UID']}",
                                      style: item_heading_textStyle),
                                  const SizedBox(height: 5),
                                  Text(
                                      "Working Days: ${userList[index]['Working_Days']}",
                                      overflow: TextOverflow.clip,
                                      style: item_regular_textStyle)
                                ],
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: DeleteDialogLayout(
                                  callback: (response) async {
                                    if (response == "yes") {
                                      print("##############$response");
                                      await callDeleteUser(
                                          userList[index]['UID'].toString(),
                                          index);
                                    }
                                  },
                                ))
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 5,
          );
        },
      ),
    ));
  }

  callGetUser(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
            TokenRequestModel(token: sessionToken, page: page.toString());
        String apiUrl = "$baseurl${ApiConstants().users}?pageNumber=$page&pageSize=12&&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
          setState(() {
            isLoaderShow = false;
            if (data != null) {
              List<dynamic> _arrList = [];
             // userList.clear();
              _arrList = data;
              if (_arrList.length < 10) {
                if (mounted) {
                  setState(() {
                    isPagination = false;
                  });
                }
              }
              if (page == 1) {
                setDataToList(_arrList);
              } else {
                setMoreDataToList(_arrList);
              }
            } else {
              isApiCall = true;
            }
          });
          print("  LedgerLedger  $data ");
        }, onFailure: (error) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          print("Here2=> $e");
          setState(() {
            isLoaderShow = false;
          });
          var val = CommonWidget.errorDialog(context, e);
          if (val == "yes") {
            print("Retry");
          }
        }, sessionExpire: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setDataToList(List<dynamic> _list) {
    if (userList.isNotEmpty) userList.clear();
    if (mounted) {
      setState(() {
        userList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        userList.addAll(_list);
      });
    }
  }

  callDeleteUser(String removeId, int index) async {
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        DeleteIUserRequestModel model = DeleteIUserRequestModel(
          companyId: companyId,
            id: removeId, modifier: uid, modifierMachine: deviceId);
        String apiUrl = baseurl + ApiConstants().users+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
          setState(() {
            isLoaderShow = false;
            userList.removeAt(index);
          });
          print("  LedgerLedger  $data ");
        }, onFailure: (error) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, e.toString());
        }, sessionExpire: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page = 1;
    });
    isPagination = true;
    await callGetUser(1);
  }

  @override
  createUser() {
    // TODO: implement createUser
    userList.clear();
    callGetUser(1);
    Navigator.pop(context);
  }

  @override
  updateUser() {
    // TODO: implement updateUser
    userList.clear();
    callGetUser(1);
    Navigator.pop(context);
  }
}
