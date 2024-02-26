import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/create_purchase_activity.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../common_widget/get_date_layout.dart';



class PurchaseActivity extends StatefulWidget {
  final String? comeFor;
  const PurchaseActivity({super.key, required mListener, this.comeFor});

  @override
  State<PurchaseActivity> createState() => _PurchaseActivityState();
}

class _PurchaseActivityState extends State<PurchaseActivity>with CreatePurchaseInvoiceInterface {


  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffff5),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: SafeArea(
          child:  Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            color: Colors.transparent,
            // color: Colors.red,
            margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),

              backgroundColor: Colors.white,
              title:  Center(
                child: Text(
                  ApplicationLocalizations.of(context)!.translate("purchase_invoice")!,
                  style: appbar_text_style,),
              ),
              automaticallyImplyLeading:widget.comeFor=="dash"? false:true,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                CreatePurchaseInvoice(
                  dateNew:CommonWidget.getDateLayout(newDate),
                  mListener:this,// DateFormat('dd-MM-yyyy').format(newDate),
            )));
          }),
      body: Container(
        margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getPurchaseDateLayout(),
            const SizedBox(
              height: 10,
            ),
            getTotalCountAndAmount(),
            const SizedBox(
              height: .5,
            ),
            get_purchase_list_layout()
          ],
        ),
      ),
    );
  }

  /* Widget to get add purchase date Layout */
  Widget getPurchaseDateLayout(){
    return  GetDateLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            newDate=date!;
          });
        },
        applicablefrom: newDate
    );
  }

  /* Widget to get total count and amount Layout */
  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          // width: SizeConfig.halfscreenWidth,
          width: SizeConfig.screenWidth*0.9,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("10 Invoices  ", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(200000), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }

  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }

  /* Widget to get purchase list Layout */
  Expanded get_purchase_list_layout() {
    return Expanded(
        child: ListView.separated(
          itemCount: [1, 2, 3, 4, 5, 6].length,
          itemBuilder: (BuildContext context, int index) {
            return  AnimationConfiguration.staggeredList(
              position: index,
              duration:
              const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: -44.0,
                child: FadeInAnimation(
                  delay: const Duration(microseconds: 1500),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: (index)%2==0?Colors.green:Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child:  const FaIcon(
                                FontAwesomeIcons.moneyCheck,
                                color: Colors.white,
                              )
                            // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
                          ),
                        ),
                        Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Mr. Franchisee Name ",style: item_heading_textStyle,),
                                      const SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                          const SizedBox(width: 10,),
                                          const Expanded(child: Text("Invoice No. - 1234",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                          const SizedBox(width: 10,),
                                          Expanded(child: Text(CommonWidget.getCurrencyFormat(1000),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child:IconButton(
                                      icon:  const FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: (){},
                                    ) )
                              ],
                            )

                        )
                      ],
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
        ));
  }
}
