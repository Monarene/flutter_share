import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false,
    String titleText = "FlutterShare",
    bool removebackbutton = false}) {
  return AppBar(
    automaticallyImplyLeading: removebackbutton ? false : true,
    title: Text(
      isAppTitle ? "FlutterShare" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : titleText,
        fontSize: isAppTitle ? 50.0 : 22,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
