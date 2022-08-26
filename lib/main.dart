import 'dart:io';

import 'package:finding_bread_app/root_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          child: RootPage(),
          color: Colors.white,
        ),
      );
  }
}
