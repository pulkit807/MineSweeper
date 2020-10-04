import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum action{flag,bomb}
enum tileState{covered,revealed,open,flagged,blown,sneak,wrFlg,}
String smile='images/smile.PNG';
String upset='images/upset.PNG';
String brust='images/brust.PNG';
String flag='images/flag.PNG';
var cellColor= Color(0xFFC0C0C0);
// list of colours
var numberColor=[
  Colors.blue,
  Color(0xFF008001),
  Colors.red.shade500,
  Color(0xFF010080),
  Colors.brown,
  Colors.cyan,
  Colors.black,
  Colors.grey,
];
final dur=const Duration(seconds:1);
