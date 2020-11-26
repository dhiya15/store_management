import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:regexed_validator/regexed_validator.dart';
import 'package:validators/validators.dart';
import 'strings.dart';

class Tools{

  static String validateString(String txt, int type){
    switch(type){
      case 1:
        return (validator.mediumPassword(txt) == true) ? null : Strings.invalidate_syntax;
        break;
      case 2:
        return (validator.name(txt) == true) ? null : Strings.invalidate_syntax;
        break;
      case 4:
        return (isNumeric(txt) == true) ? null : Strings.invalidate_syntax ;
        break;
      case 5:
        return (txt.isEmpty == true) ? Strings.no_value_for_this_field : null;
        break;
      case 6:
        txt = txt.toString().trim();
        txt = txt.replaceAll(" ", "");
        return (isAlpha(txt) == true) ? null : Strings.invalidate_syntax ;
        break;
      case 7:
        return (isFloat(txt) == true && txt.isEmpty == false) ? null : Strings.price_syntax ;
        break;
      case 8:
        RegExp regExp = RegExp(
          r"((\\d+/\\d+)|(\\d+)|(\\d+\\.\\d+))\\s?(ml|mg|g)",
          caseSensitive: false,
          multiLine: false,
        );
        return (regExp.hasMatch(txt.toString().trim()) == true) ? null : Strings.price_syntax ;
        break;
    }
    return null;
  }

  static Widget getScrollWidget(Widget body) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return body;
          }, childCount: 1),
        ),
      ],
    );
  }

  static Widget getHorizontalScrollWidget(Widget body) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: <Widget>[
        SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return body;
          }, childCount: 1),
        ),
      ],
    );
  }

  static void showAlertDialog(BuildContext context, String title, String message){
    var alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: Text(Strings.ok)),
        ],
    );
    showDialog(context: context, child: alertDialog, barrierDismissible: false);
  }

  static void showWaitDialog(BuildContext context, String title, String message){
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, child: alertDialog, barrierDismissible: false);
  }

  static Future<String> scanQRCode() async{
    String cameraScanResult = await scanner.scan();
    return cameraScanResult;
  }

  static String getStringTime(TimeOfDay time) {
    print("${time.toString()}");
    return time.toString().substring(10, 15) + ":00";
  }

  static String fillDate(DateTime date) {
    return date.toIso8601String().substring(0, 10);
  }

  static String fillDate2(DateTime date) {
    return date.toIso8601String().substring(11, 19);
  }

}