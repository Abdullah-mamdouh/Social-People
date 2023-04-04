
import 'package:flutter/material.dart';

class Live {
  String username;
  String image;
  int? channelId;
  bool me;


  Live({required this.username, required this.me, required this.image, this.channelId});
}