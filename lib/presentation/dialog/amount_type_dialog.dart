import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../core/app_preferance.dart';
import '../../core/common.dart';
import '../../core/internet_check.dart';
import '../../data/api/constant.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/commonRequest/get_toakn_request.dart';

class AmountTypeDialog extends StatefulWidget {
  final AmountTypeDialogInterface mListener;
  final selectedType;
  final width;
  final readOnly;
  final mandatory;
  const AmountTypeDialog({super.key, required this.mListener, required this.selectedType,required this.width, this.readOnly, this.mandatory});

  @override
  State<AmountTypeDialog> createState() => _LedegerGroupDialogState();
}

class _LedegerGroupDialogState extends State<AmountTypeDialog>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall = false;
  late InternetConnectionStatus internetStatus;

  var editedItem=null;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.selectedType!=null) {
      selctedAmtType = widget.selectedType;
    }
    _scrollController.addListener(_scrollListener);
    callGetAmountType(page);
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetAmountType(page);
      }
    }
  }
  List<dynamic> amount_type = [];
  var selctedAmtType=null;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
     widget.readOnly==false?   SearchableLedgerDropdown(
       apiUrl: ApiConstants().amount_type+"?" ,
       titleIndicator: false,
       ledgerName: selctedAmtType,
       readOnly: widget.readOnly,
       franchiseeName:selctedAmtType,
       title: ApplicationLocalizations.of(context)!.translate("ledger_name")!,
       callback: (name,id){
       },):  Container(
            height: 45,
            width: double.parse(widget.width.toString()),
            margin: widget.width.toString()=="130"? EdgeInsets.only(left: 5,top:30): EdgeInsets.only(left: 5,top:10),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              border: Border.all(color:widget.mandatory?Colors.redAccent:Colors.transparent)
            ),
            child: DropdownButton<dynamic>(
              menuMaxHeight: 200,
              hint: Text(
                ApplicationLocalizations.of(context)!.translate("amount_type")!,
              ),
              value: selctedAmtType,
              icon:  Icon(
                Icons.arrow_drop_down,
              ),
              iconSize: 20,
              isExpanded: true,
              underline:Container(),
              onChanged: (dynamic? newValue) {
                setState(() {
                  selctedAmtType = newValue!;
                });
                if(widget.mListener!=null){
                  widget.mListener.selectedAmountType(newValue);
                }
              },
              items: amount_type.map<
                  DropdownMenuItem<dynamic>>(
                      (dynamic value) {
                    return DropdownMenuItem<dynamic>(
                      value: value,
                      child: Text(
                        value.toString(),
                      ),
                    );
                  }).toList(),
            )),

    Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }
  /*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
           ApplicationLocalizations.of(context).translate("no_data"),
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
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  // autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  controller: _textController,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: searchFocus,
                  style: text_field_textStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    border: InputBorder.none,
                    hintText:ApplicationLocalizations.of(context)!.translate("search")!,
                    hintStyle: TextStyle(
                        color: CommonColor.SEARCH_TEXT_COLOR,
                        fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                        fontFamily: 'Inter_Medium_Font',
                        fontWeight: FontWeight.w400),
                  ),
                  onChanged: fetchSimpleData,
                ),
              ),
              Visibility(
                visible: _textController.text.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    _textController.clear();
                    callGetAmountType(1);
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
          itemCount:amount_type.length,
          itemBuilder:(BuildContext context, int index){
            return Padding(
              padding:EdgeInsets.only(left: parentWidth*.1,right: parentWidth*.1),
              child: GestureDetector(
                onTap: (){//_arrListNew[index]['Name']
                  if(widget.mListener!=null){
                    widget.mListener.selectedAmountType(amount_type[index]);
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
                      amount_type[index]!=null? Text(
                        amount_type[index],
                        style: text_field_textStyle,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ):Container(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child:GestureDetector(
        onTap:(){
          Navigator.pop(context);
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
          child:Center(
            child: Text(
              ApplicationLocalizations.of(context)!.translate("close")!,
              // StringEn.CLOSE,
              textAlign: TextAlign.center,
              style: text_field_textStyle,
            ),
          ),
        ),
      ),
    );
  }

  var filteredStates = [];
  Future<List> fetchSimpleData(searchstring) async {
    print(searchstring);
    List<dynamic> _list = [];
    List<dynamic> results = [];
    if (searchstring.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = filteredStates;
    } else {

      results = amount_type
          .where((state) => state.toLowerCase().contains(searchstring.toLowerCase()))
          .toList();
      print("hjdhhdhfd  $filteredStates");
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      amount_type = results;
    });
    return _list;
  }

  callGetAmountType(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().amount_type}?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  print("responseeee   $data");
                  List<dynamic> _arrList = [];
                  amount_type=data;
                  filteredStates=amount_type;
                  // if (_arrList.length < 50) {    }
                  // if (page == 1) {
                  //   setDataToList(_arrList);
                  // } else {
                  //   setMoreDataToList(_arrList);
                  // }
                }else{
                  isApiCall=true;
                }
              });
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }

  setDataToList(List<dynamic> _list) {
    if (amount_type.isNotEmpty) amount_type.clear();
    if (mounted) {
      setState(() {
        amount_type.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        amount_type.addAll(_list);
      });
    }
  }
}


abstract class AmountTypeDialogInterface{
  selectedAmountType(String name);
}
