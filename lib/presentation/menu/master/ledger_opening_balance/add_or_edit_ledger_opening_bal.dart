
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_amt_type.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/common.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/ledger_opening_bal/item_opening_bal_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dialog/amount_type_dialog.dart';
class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}
class AddOrEditLedgerOpeningBal extends StatefulWidget {
  final AddOrEditItemOpeningBalInterface mListener;
  final dynamic editproduct;
  final String dateNew;
  final  dateApi;
  const AddOrEditLedgerOpeningBal({super.key, required this.mListener, required this.editproduct, required this.dateNew, this.dateApi});
  @override
  State<AddOrEditLedgerOpeningBal> createState() => _AddOrEditItemOpeningBalState();
}

class _AddOrEditItemOpeningBalState extends State<AddOrEditLedgerOpeningBal>with AmountTypeDialogInterface {
  List<String> AmountType = ["Cr","Dr"];

  String ?selectedType = null;

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode() ;

  TextEditingController amount = TextEditingController();
var amountType=null;
String amountTypeId="";

  FocusNode searchFocus = FocusNode() ;
  //
  // _onChangeHandler(value ) {
  //   const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
  //   if (searchOnStoppedTyping != null) {
  //     setState(() => searchOnStoppedTyping.cancel()); // clear timer
  //   }
  //   setState(() => searchOnStoppedTyping =  Timer(duration, () => search(value)));
  // }
  //
  // search(value) {
  //   searchFocus.unfocus();
  //   isApiCall = false;
  //   page = 0;
  //   isPagination = true;
  //   callGetNoticeListingApi(page,value,true);
  //   print('hello world from search . the value is $value');
  // }


  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  var itemsList = [];
  var selectedItemID =null;

  final _formkey=GlobalKey<FormState>();

  var filteredItemsList = [];


  fetchItems () async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    await AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = "${baseurl}${ApiConstants().salePartyItem}?Company_ID=$companyId&PartyID=null&Date=${widget.dateApi}";
      apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            if(data!=null) {
              var topShowsJson = (data) as List;
              setState(() {
                itemsList=  topShowsJson.map((show) => (show)).toList();
                filteredItemsList=topShowsJson.map((show) => (show)).toList();
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
    print(searchstring);
    List<dynamic> _list = [];
    List<dynamic> results = [];
    if (searchstring.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = filteredItemsList;
    } else {

      results = filteredItemsList
          .where((user) =>
          user["Name"]
              .toLowerCase()
              .contains(searchstring.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      itemsList = results;
    });

    print(itemsList);
    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in filteredItemsList) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['Name']}", 'value': "${ele['ID']}","unit":ele['Unit'],"rate":ele['Rate'],'gst':ele['GST_Rate']}));
    }
    return _list;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];
  setVal()async{
    print("Assssssssss ${widget.dateApi}");
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['Ledger_Name'];
        selectedItemID=widget.editproduct['Ledger_ID'];
        amount.text=widget.editproduct['Amount'].toString();
        amountType=widget.editproduct['Amount_Type'];
      });
    }
    await fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*0.55,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight*.08,
                      child:  Center(
                        child: Text(
                            ApplicationLocalizations.of(context)!.translate("ledger_opening_balance")!,
                            style: page_heading_textStyle
                        ),
                      ),
                    ),
                    getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("ledger")!),
                    getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getAmount(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    getAmtType(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ),        ],
      ),
    );
  }

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Container(
        height: parentHeight * .055,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CommonColor.WHITE_COLOR,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: TextFieldSearch(
          minStringLength: 0,
            label: 'Item',
            controller: _textController,
            decoration: textfield_decoration.copyWith(
              hintText: ApplicationLocalizations.of(context)!.translate("ledger_name")!,
              prefixIcon: Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
            ),
            textStyle: item_regular_textStyle,
            getSelectedValue: (v) {
              setState(() {
                selectedItemID = v.value;
                itemsList = [];
              });
            },
            future: () {
              if (_textController.text != "")
                return fetchSimpleData(
                    _textController.text.trim());
            })

    );
  }

/*

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return Container(
      height: parentHeight * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        // autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.text,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText: ApplicationLocalizations.of(context)!.translate("ledger")!,
          prefixIcon: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
        ),
        // onChanged: _onChangeHandler,
      ),
    );
  }
*/


  Widget getAmount(double parentHeight, double parentWidth){
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("amount")!;
        }
        return null;
      },
      controller: amount,
      focuscontroller: null,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("amount")!,
      callbackOnchage: (value) {
        setState(() {
          amount.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

  }

  Widget getAmtType(double parentHeight, double parentWidth){
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("amount_type")!,
            style: item_heading_textStyle,
          ),
          AmountTypeDialog(mListener: this,selectedType:amountType,width: parentWidth,),
        ],
      ),
    );

    //   Padding(
    //   padding:  EdgeInsets.only(top: parentHeight*.02),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         ApplicationLocalizations.of(context)!.translate("amount_type")!,
    //         style: item_heading_textStyle,
    //       ),
    //       GestureDetector(
    //         onTap: () {
    //           FocusScope.of(context).requestFocus(FocusNode());
    //           if (context != null) {
    //             showGeneralDialog(
    //                 barrierColor: Colors.black.withOpacity(0.5),
    //                 transitionBuilder: (context, a1, a2, widget) {
    //                   final curvedValue =
    //                       Curves.easeInOutBack.transform(a1.value) -
    //                           1.0;
    //                   return Transform(
    //                     transform: Matrix4.translationValues(
    //                         0.0, curvedValue * 200, 0.0),
    //                     child: Opacity(
    //                       opacity: a1.value,
    //                       child: AmountTypeDialog(
    //                         mListener: this,
    //                       ),
    //                     ),
    //                   );
    //                 },
    //                 transitionDuration: Duration(milliseconds: 200),
    //                 barrierDismissible: true,
    //                 barrierLabel: '',
    //                 context: context,
    //                 pageBuilder: (context, animation2, animation1) {
    //                   throw Exception(
    //                       'No widget to return in pageBuilder');
    //                 });
    //           }
    //         },
    //         child: Container(
    //             height: parentHeight * .055,
    //             margin: EdgeInsets.only(top: 5),
    //             padding: EdgeInsets.only(left: 10, right: 10),
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: CommonColor.WHITE_COLOR,
    //               borderRadius: BorderRadius.circular(4),
    //               boxShadow: [
    //                 BoxShadow(
    //                   offset: Offset(0, 1),
    //                   blurRadius: 5,
    //                   color: Colors.black.withOpacity(0.1),
    //                 ),
    //               ],
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   amountType == "" ? ApplicationLocalizations.of(context)!.translate("amount_type")!
    //                       : amountType,
    //                   style: amountType == "" ? item_regular_textStyle : text_field_textStyle,
    //                 ),
    //                 FaIcon(
    //                   FontAwesomeIcons.caretDown,
    //                   color: Colors.black87.withOpacity(0.8),
    //                   size: 16,
    //                 )
    //               ],
    //             )),
    //       ),
    //     ],
    //   ),
    // );

  }


  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }

  List<dynamic> Item_list=[];
  /* Widget for Buttons Layout0 */
  Widget getAddForButtonsLayout(double parentHeight,double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height:parentHeight*.05,
            width: parentWidth*.45,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("close")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print("jhgtghh  ${_textController.text}");

         /*   Item_list[index]['Seq_No']=item['seq_No'];
            Item_list[index]['Ledger_ID']=item['Ledger_ID'];
            Item_list[index]['Amount']=item['Amount'];
            Item_list[index]['Amnt_Type']=item['Amnt_Type'];
            Item_list[index]['New_Ledger_ID']=item['New_Ledger_ID'];*/

            var item={
              // "Ledger_ID":widget.editproduct!=null?widget.editproduct['Ledger_ID']:"",
              "Ledger_Name":_textController.text,
              "Ledger_ID":selectedItemID,
              "Amount":double.parse(amount.text),
              "Amount_Type":amountType
            };
            if(widget.editproduct!=null){
              print("#############3");
              Updated_list.add(item);
              setState(() {
                Updated_list = Updated_list;
              });
            }else{
              Inserted_list.add(item);
              setState(() {
                Inserted_list = Inserted_list;
              });
              print("erererre  ${Inserted_list}");
            }
            callLedgerOpeningBal(Inserted_list,Updated_list);

          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth*.45,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  callLedgerOpeningBal(item,editItem) async {

    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
   // DateTime date = DateTime.parse(widget.dateNew);
 //   print("hfhefhhfhef  $date   ");
    print('newlistttt...  ${Inserted_list.toList()}');
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostILedgerOpeningRequestModel model = PostILedgerOpeningRequestModel(
          companyID: companyId,
          date:widget.dateApi,
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: item.toList(),
          uPDATE: editItem.toList(),
          dELETE: Deleted_list.toList()
      );
      print("PostILedgerOpeningRequestModel    ${model.toJson()}");
      String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger_opening_bal;
      print("urlll  $apiUrl");
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            if(widget.mListener!=null){

              widget.mListener.AddOrEditItemOpeningBalDetail(item);
              Navigator.pop(context);
            }
           // Navigator.pop(context);

          }, onFailure: (error) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, error.toString());
          },
          onException: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });

    });
  }

  @override
  selectedAmountType(String name) {
    // TODO: implement selectedAmountType
   setState(() {
     amountType=name;
   });
  }
}

abstract class AddOrEditItemOpeningBalInterface{
  AddOrEditItemOpeningBalDetail(dynamic item);
}