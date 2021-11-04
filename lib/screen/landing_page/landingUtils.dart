

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/landing_page/landingService.dart';
import 'package:sm/service/firebaseOperation.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  final picker = ImagePicker();

  File ? userAvatar;
  File get getUserAvatar => userAvatar!;
  String  userAvatarUrl='';
  String get getUserAvatarUrl => userAvatarUrl;


  Future pickerUserAvatar(BuildContext context, ImageSource source) async{
    final pickedUserAvatar  =await picker.getImage(source: source);
    pickedUserAvatar == null ? print('select Image') : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar!.path);

    userAvatar != null ? Provider.of<LandingService>(context,listen: false).showUserAvatar(context)
        : print('Image upload error');
    notifyListeners();
  }

  Future selectAvatarOperation(BuildContext context) async{
    return showModalBottomSheet(
        context: context, builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(

              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                    color: constantColors.whiteColor,
                ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: (){
                        pickerUserAvatar(context, ImageSource.gallery);
                      },
                      child: Text('Gallery',style: TextStyle(
                        color: constantColors.whiteColor,fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                    ),

                    MaterialButton(
                      onPressed: (){
                        pickerUserAvatar(context, ImageSource.camera).whenComplete((){
                          Navigator.pop(context);
                          Provider.of<LandingService>(context,listen: false).showUserAvatar(context);
                        });
                      },
                      child: Text('Camera',style: TextStyle(
                        color: constantColors.whiteColor,fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                    ),
                  ],
                ),
              ],
            ),

          );
    });
  }

}

