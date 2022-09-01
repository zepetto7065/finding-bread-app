import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    clearToken();
    return Scaffold(
        body: IndexPage()
    );
  }

  Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
