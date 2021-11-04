import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/landing_page/landingService.dart';
import 'package:sm/screen/landing_page/landingUtils.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController captionController = new TextEditingController();
  File? uploadPostImage;
  File get getuploadPostImage => uploadPostImage!;
  String? uploadPostImageUrl;
  String get getuploadPostImageUrl => uploadPostImageUrl!;
  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);
    uploadPostImage = File(uploadPostImageVal!.path);
    // uploadPostImage == null
    //     ? uploadPostImage = File(uploadPostImageVal!.path)
    //     : print('select Image');
    print(uploadPostImageVal.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image upload error');
    notifyListeners();
  }

  Future uploadPostToFirebase() async {
    Reference imageReferenc = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReferenc.putFile(uploadPostImage!);
    await imagePostUploadTask.whenComplete(() {
      print('Post Image upload to srorage');
    });
    imageReferenc.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
      notifyListeners();
    });
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //Navigator.pop(context);
                      pickUploadPostImage(context, ImageSource.gallery);
                    },
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      pickUploadPostImage(context, ImageSource.camera);
                    },
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.435,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                height: 200,
                width: 400,
                child: Image.file(
                  uploadPostImage!,
                  fit: BoxFit.contain,
                ),
              ),
              // CircleAvatar(
              //   backgroundColor: constantColors.transperant,
              //   radius: 60,
              //   backgroundImage: FileImage(uploadPostImage!),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        selectPostImageType(context);
                      },
                      child: Text(
                        'Reselect',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text('Confirme Image',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () {
                        //Navigator.pop(context);
                        uploadPostToFirebase().whenComplete(() {
                          editPostSheet(context);
                          print('Upload Image');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.image_aspect_ratio),
                              color: constantColors.greenColor,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.fit_screen),
                              color: constantColors.yellowColor,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        child: Image.file(
                          uploadPostImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('asstes/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110,
                        width: 5,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          height: 120,
                          width: 310,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforced: true,
                            maxLength: 100,
                            controller: captionController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add A Caption',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'post_image': getuploadPostImageUrl,
                      'caption': captionController.text,
                      'user_name':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserName,
                      'user_image':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserImage,
                      'user_uid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'user_email':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserEmail,
                    }).whenComplete(() {
                      return FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'post_image': getuploadPostImageUrl,
                        'caption': captionController.text,
                        'user_name': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserName,
                        'user_image': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserImage,
                        'user_uid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'user_email': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserEmail,
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'share',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: constantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
