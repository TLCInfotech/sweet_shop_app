import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../core/app_preferance.dart';
import '../../core/common.dart';
import '../../core/localss/application_localizations.dart';
import '../../data/api/constant.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/commonRequest/get_toakn_request.dart';
import '../menu/master/item_opening_balance/add_or_edit_item_opening_bal.dart';

class ItemDialog extends StatefulWidget {
  final ItemDialogInterface mListener;

  const ItemDialog({super.key, required this.mListener});

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode() ;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var itemsList = [];

  fetchShows (searchstring) async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    String sessionToken = await AppPreferences.getSessionToken();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + ApiConstants().item_list+"?Company_ID=$companyId&${StringEn.lang}=$lang&name=${searchstring}";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            if(data!=null) {
              var topShowsJson = (data) as List;
              setState(() {
                itemsList=  topShowsJson.map((show) => (show)).toList();
              });
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);
            return [];
            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);
            return [];

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            return [];
            // widget.mListener.loaderShow(false);
          });

    });
  }

  Future<List> fetchSimpleData(searchstring) async {
    await Future.delayed(Duration(milliseconds: 0));
    await fetchShows(searchstring) ;

    List _list = <dynamic>[];
    print(itemsList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in itemsList) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}"}));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight*.08,
                    child: Center(
                      child: Text(
                          ApplicationLocalizations.of(context)!.translate("select_category")!,                        style: TextStyle(
                          fontFamily: "Montserrat_Bold",
                          fontSize: SizeConfig.blockSizeHorizontal * 5.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  SizedBox(
                      height: SizeConfig.screenHeight*.32,
                      child: getList(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                ],
              ),
            ),
          ),
          getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
        ],
      ),
    );
  }


  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Padding(
      padding:  EdgeInsets.only(bottom: parentHeight*.015,left: parentWidth*.04,right: parentWidth*.04),
      child: Container(
        height: parentHeight*.05,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          color: CommonColor.GRAY_COLOR.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(050)),
        ),
        child:  Padding(
          padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(searchFocus);
                },
                child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(right: parentWidth * .015),
                      child:Image(
                        image:  const AssetImage("assets/images/search.png"),
                        height: parentHeight * .025,
                        fit: BoxFit.contain,
                        color: CommonColor.SEARCH_TEXT_COLOR,
                      ),
                    )),
              ),
              Expanded(
                child: TextFieldSearch(
                    label: 'Item',
                    controller: _textController,
                    decoration: textfield_decoration.copyWith(
                      hintText: ApplicationLocalizations.of(context)!.translate("item_name")!,
                      prefixIcon: Container(
                          width: 50,
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
                    ),
                    textStyle: item_regular_textStyle,
                    getSelectedValue: (v) {
                      if(widget.mListener!=null){
                        widget.mListener.selectedItem(v['ID'],v['Name']);
                      }
                      Navigator.pop(context);
                      setState(() {
                        itemsList = [];
                      });
                    },
                    future: () {
                      if (_textController.text != "")
                        return fetchSimpleData(
                            _textController.text.trim());
                    }),
              ),
              Visibility(
                visible: _textController.text.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    _textController.clear();
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.cancel,
                        color: CommonColor.SEARCH_TEXT_COLOR,
                        size: SizeConfig.screenHeight * .03,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget getList(double parentHeight,double parentWidth){
    return Padding(
      padding:EdgeInsets.only(top: parentHeight*.01),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: itemsList.length,
          itemBuilder:(BuildContext context, int index){
            return Padding(
              padding:EdgeInsets.only(left: parentWidth*.1,right: parentWidth*.1),
              child: GestureDetector(
                onTap: (){
                  if(widget.mListener!=null){
                    widget.mListener.selectedItem(index.toString(),itemsList.elementAt(index));
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: parentHeight*.06,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: CommonColor.PROFILE_BORDER,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemsList[index]['Name'],
                        style: text_field_textStyle,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget getCloseButton(double parentHeight, double parentWidth){
    return  Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          // Scaffold.of(context).openDrawer();
        },
        child: Container(
          height: parentHeight*.065,
          decoration: const BoxDecoration(
            color: CommonColor.THEME_COLOR,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
          ),
          child: Center(
            child: Text(
              ApplicationLocalizations.of(context)!.translate("close"),
              textAlign: TextAlign.center,
              style: text_field_textStyle,
            ),
          ),
        ),
      ),
    );
  }




}


abstract class ItemDialogInterface{
  selectedItem(String id,String name);
}