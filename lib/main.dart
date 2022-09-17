import 'dart:io';

import 'package:finding_bread_app/login_page.dart';
import 'package:finding_bread_app/root_page.dart';
import 'package:finding_bread_app/tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    clearToken();
    return buildApp(context);
  }

  StatefulWidget buildApp(BuildContext context) {
    return MaterialApp(
        title: 'Finding Bread',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.brown, brightness: Brightness.light
            ),
            textTheme: GoogleFonts.juaTextTheme(
                Theme.of(context)
                    .textTheme
            )
        ),
        home: Container(
          child: LoginPage(),
        ),
      );
  }

  Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
