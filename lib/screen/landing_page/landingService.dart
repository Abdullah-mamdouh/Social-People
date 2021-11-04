import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/landing_page/landingUtils.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:sm/widget/textFieldClass.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
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
                CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context, listen: false)
                        .userAvatar!,
                  ),
                  radius: 60,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickerUserAvatar(context, ImageSource.gallery);
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
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .uploadUserAvatar(context);
                          signInSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  passwordLessSigIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ListTile(
                    trailing: Container(
                      //color: constantColors.redColor,
                      width: 120, height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .logIntoAccount(
                                      document['user_email'], document['user_password'])
                                  .whenComplete(() {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: HomePage(),
                                        type: PageTransitionType.leftToRight));
                              });
                            },
                            icon: Icon(FontAwesomeIcons.check),
                            color: constantColors.blueColor,
                          ),
                          IconButton(
                            onPressed: () {
                              Provider.of<FirebaseOperation>(context,
                                      listen: false)
                                  .deleteUserData(
                                      document['user_uid'], 'users');
                            },
                            icon: Icon(FontAwesomeIcons.trashAlt),
                            color: constantColors.redColor,
                          ),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.darkColor,
                      backgroundImage: NetworkImage(document['user_image']),
                    ),
                    subtitle: Text(
                      document['user_email'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 12,
                      ),
                    ),
                    title: Text(
                      document['user_name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  TextFieldClass(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  TextFieldClass(
                      controller: _passwordController, hintText: 'Password'),
                  FloatingActionButton(
                      backgroundColor: constantColors.blueColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (_emailController.text.isNotEmpty ||
                            _passwordController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(_emailController.text,
                                  _passwordController.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          waringText(context, 'Fill all the data');
                        }
                      }),
                ],
              ),
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
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
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.redColor,
                    radius: 60,
                  ),
                  TextFieldClass(
                    controller: _nameController,
                    hintText: 'Name',
                  ),
                  TextFieldClass(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  TextFieldClass(
                    controller: _passwordController,
                    hintText: 'Password',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (_emailController.text.isNotEmpty ||
                            _passwordController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAccount(_emailController.text,
                                  _passwordController.text)
                              .whenComplete(() {
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .createUserCollectin(context, {
                              'user_password': _passwordController.text,
                              'user_uid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'user_email': _emailController.text,
                              'user_name': _nameController.text,
                              'user_image': Provider.of<LandingUtils>(context,
                                      listen: false)
                                  .getUserAvatarUrl,
                            });
                          })
                              .whenComplete(() {
                            print('ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          waringText(context, 'Fill all the data');
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }

  waringText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
