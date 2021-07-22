import 'package:chatty_app/common/size_config.dart';
import 'package:flutter/material.dart';

Color blueColor = Color(0xff1F8DF5);
Color scaffoldBgColor = Color(0xffF8FAFC);
Color blackColor = Colors.black54;

InputDecoration textFieldDecoration({
  @required String hintText,
  @required Color color,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: (SizeConfig.safeBlockHorizontal * 4.4).roundToDouble(),
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: (SizeConfig.safeBlockVertical * 2.4).roundToDouble(),
      horizontal: (SizeConfig.safeBlockHorizontal * 5.56).roundToDouble(),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
  );
}
