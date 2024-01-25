import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/external/keyboard_avoider/keyboard_avoider.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:image_picker/image_picker.dart';

class CreateItem extends StatefulWidget {
  //final CreateItemInterface mListener;

  const CreateItem({super.key/*, required this.mListener*/});


  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> with CategoryDialogInterface,SingleTickerProviderStateMixin,
    ImagePickerDialogPostInterface,ImagePickerListener,ImagePickerDialogInterface{
  double opacityLevel = 1.0;
  final descController = TextEditingController();
  final _descFocus = FocusNode();
  removeErrorOnDescription() {
    if (descController.text.isNotEmpty) {
      if (mounted) {
        setState(() {
          isDescriptionValid = false;
          isDescriptionMsgValid = false;
        });
      }
    }
  }

  bool isDescriptionValid = false;
  bool isDescriptionMsgValid = false;
  List<File> _selectedListForImage = [];
  File videoUrl = File('');
  final postLength = 550;
  File? profileImage;

  Future getImages() async {
    final pickedFile = await ImagePicker().pickMultiImage(
        imageQuality: 100, // To set quality of images
        maxHeight: 1000, // To set maxheight of images that you want in your app
        maxWidth: 1000); // To set maxheight of images that you want in your app
    List<XFile>? xfilePick = pickedFile;
    if (xfilePick!.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        _selectedListForImage.add(File(xfilePick[i].path));
        videoUrl = File('');
      }
      setState(
            () {},
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }
  String categoryId="";
  String categoryName="";
  bool isLoaderShow =false;




  removeErrorOnTitle() {
    if (titleController.text.isNotEmpty) {
      if (mounted) {
        setState(() {
          isTitleValidShow = false;
          isTitleMsgValidShow = false;
        });
      }
    }
  }



  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _Controller);
    imagePicker.setListener(this);
    imagePicker.init(context);
    titleController.addListener(removeErrorOnTitle);
    descController.addListener(removeErrorOnDescription);
  }


  final titleController = TextEditingController();
  final _titleFocus = FocusNode();
  bool isCategoryValidShow = false;
  bool isCategoryMsgValidShow = false;
  bool isTitleValidShow = false;
  bool isTitleMsgValidShow = false;
  final titleLength = 100;
  bool isButtonShow = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              // color: Colors.red,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
                title: const Text(
                  "Create Item",
                  style: appbar_text_style,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: KeyboardAvoider(
                autoScroll: true,
                child: Container(
                  height: SizeConfig.screenHeight * .88,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          getAddCategoryLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                          getAddTitleLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                          getAddDescriptionLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                          getAddMediaLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                          profileImage!=null?getAddGallerySelectedImagesLayout(
                              SizeConfig.screenHeight,
                              SizeConfig.screenWidth):Container(),
                        ],
                      ),
                      Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool buttonVisible=true;
  /* Widget for TopBar Layout */
  Widget getAddTopBarLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .05,
          left: parentWidth * 0.0,
          right: parentWidth * 0.05),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              onDoubleTap: () {},
              child: Container(
                color: Colors.transparent,
                width: parentWidth * .25,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: parentWidth * .05),
                        child: Image(
                          image: AssetImage("assets/images/back.png"),
                          height: parentHeight * .035,
                          width: parentHeight * .035,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              "Create Item",
              style: page_heading_textStyle,
            ),
            buttonVisible==true?
            GestureDetector(
              onTap:(){
                FocusScope.of(context).requestFocus( FocusNode());
              },
              onDoubleTap: (){},
              child: Container(
                width: parentWidth * .2,
                decoration: BoxDecoration(
                  color:  CommonColor.THEME_COLOR,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: parentHeight * .01, bottom: parentHeight * .01),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringEn.POST,
                        style: page_heading_textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ):
            Container(
              width: parentWidth * .2,
              decoration: BoxDecoration(
                color:  CommonColor.GRAY_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: parentHeight * .01, bottom: parentHeight * .01),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringEn.POST,
                      style:page_heading_textStyle,
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }


  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015,
        left: parentWidth * .03,
        right: parentWidth * .03,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: page_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: CategoryDialog(
                            mListener: this,
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation2, animation1) {
                      throw Exception('No widget to return in pageBuilder');
                    });
              }
            },
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: parentHeight * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: parentHeight * .058,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categoryName==""?"Select category":categoryName,
                              style:categoryName == ""? hint_textfield_Style:
                              text_field_textStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              // textScaleFactor: 1.02,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: parentHeight * .03,
                              color: /*pollName == ""
                                  ? CommonColor.HINT_TEXT
                                  :*/ CommonColor.BLACK_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .0,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      StringEn.ADD_CATEGORY,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for Title Layout */
  Widget getAddTitleLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_titleFocus);
      },
      onDoubleTap: () {},
      child: Padding(
        padding: EdgeInsets.only(top: parentHeight * .015,left: parentWidth*.03,right: parentWidth*.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Row(
              children: [
                Text(
                  StringEn.ITEM_NAME,
                  style: page_heading_textStyle,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .01),
              child: Container(
                alignment: Alignment.topLeft,
                height: parentHeight * .1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: parentWidth * .025,),
                      child: TextFormField(
                        focusNode: _titleFocus,
                        // autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        maxLength: titleLength,
                        onEditingComplete: () {
                          _titleFocus.unfocus();
                        },
                        controller: titleController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: parentHeight*.01,bottom: parentHeight*.01),
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter item name",
                          hintStyle: hint_textfield_Style,
                        ),
                        style:text_field_textStyle,
                      ),
                    ),
                    Visibility(
                      visible: isTitleValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .04,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isTitleMsgValidShow = !isTitleMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isTitleMsgValidShow,
                      titleController.text.length <= 3 ?
                      StringEn.ENTER_VALID_ITEM_NAME :
                      StringEn.ENTER_ITEM_NAME,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: parentHeight * .01,
                  right: parentWidth * .02),
              child: Text(
                "${titleController.text.length}/$titleLength",
                style:item_regular_textStyle,
              ),
            ),

          ],
        ),
      ),
    );
  }


  /* Widget for Description Layout */
  Widget getAddDescriptionLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_descFocus);
      },
      onDoubleTap: () {},
      child:  Padding(
        padding: EdgeInsets.only(top: parentHeight * .015,left: parentWidth*.03,right: parentWidth*.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Row(
              children: [
                Text(
                 StringEn.ITEM_DESCRIPTION,
                  style: page_heading_textStyle,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .01),
              child: Container(
                alignment: Alignment.topLeft,
                height: parentHeight * .2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: parentWidth * .025),
                      child: TextFormField(
                        focusNode: _descFocus,
                        // autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        maxLength: postLength,
                        onEditingComplete: () {
                          _descFocus.unfocus();
                        },
                        controller: descController,
                        scrollPadding: EdgeInsets.only(bottom: parentHeight*.2),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: parentHeight*.01,bottom: parentHeight*.01),
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter a description..",
                          hintStyle:hint_textfield_Style,
                        ),
                        style: text_field_textStyle,
                      ),
                    ),
                    Visibility(
                      visible: isDescriptionValid,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: parentHeight * .015, right: parentWidth * .01),
                        child: Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    isDescriptionMsgValid = !isDescriptionMsgValid;
                                  });
                                }
                              },
                              child: const Icon(Icons.error, color: Colors.red)),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                        parentHeight * .047,
                        parentWidth * .01,
                        SizeConfig.blockSizeHorizontal * 2.5,
                        isDescriptionMsgValid,
                        descController.text.trim().length  <= 3
                            ? StringEn.ENTER_VALID_DESCRIPTION
                            : StringEn.ENTER_DESCRIPTION),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: parentHeight * .01,
                  right: parentWidth * .02),
              child: Text(
                "${descController.text.length}/$postLength",
                style: item_regular_textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget for Add Media Layout */
  Widget getAddMediaLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight*.01),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1,color: Colors.black.withOpacity(0.1)),
          ),
        ),
        child: Padding(
          padding:
          EdgeInsets.only(top: parentHeight*.01),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AnimatedOpacity(
                        opacity: opacityLevel,
                        duration: const Duration(seconds: 2),
                        child: ImagePickerDialogPost(
                          imagePicker,
                          _Controller,
                          context,
                          this, isOpenFrom: '',
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: parentWidth * .04),
                  child: Container(
                    height: parentHeight * .05,
                    width: parentHeight * .05,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CommonColor.HINT_TEXT_LEAVES.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.image,
                      size: parentHeight * .03,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget for Gallery Selected Images */
  Widget getAddGallerySelectedImagesLayout(double parentHeight, double parentWidth) {
    return  Padding(
      padding: EdgeInsets.only(top: parentHeight * .015,left: parentWidth*.03,right: parentWidth*.03,bottom: parentHeight*.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: parentHeight * .25,
                width: parentHeight * .25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: DecorationImage(
                      image: FileImage(profileImage!),
                      fit: BoxFit.cover,
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {

                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.clear,
                      color: Colors.transparent,
                      size: parentWidth * .05,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }





  @override
  bothVideoAndImage(File video) {
    // TODO: implement bothVideoAndImage

  }

  @override
  sendImageToPostScreen(File image) {
    // TODO: implement sendImageToPostScreen
    if (mounted) {
      setState(() {

        _selectedListForImage.add(image);

        print("selelelel    ${_selectedListForImage.length}   ${image.path}");
      });
    }
  }


  @override
  selectCategory(String id, String name) {
    // TODO: implement selectCategory
    if(mounted){
      setState(() {
        categoryId=id;
        categoryName=name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }

  @override
  userImage(File _image, String comeFrom) {
    // TODO: implement userImage
    if (_image != null)
      // ignore: curly_braces_in_flow_control_structures
      if (mounted) {
        setState(() {
          profileImage = _image;
        });
      }
  }



}
// abstract class CreateItemInterface{
//   uploadPostToHome(String screenName, File video, String postId, File selectList);
// }