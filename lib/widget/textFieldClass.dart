
import 'package:flutter/material.dart';
import 'package:sm/constant/Constantcolors.dart';
class TextFieldClass extends StatelessWidget {
  TextFieldClass({Key? key,@required this.controller,@required this.hintText}) : super(key: key);
  final TextEditingController ? controller;
  String ? hintText ;
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter $hintText...',
          hintStyle: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: TextStyle(
          color: constantColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
