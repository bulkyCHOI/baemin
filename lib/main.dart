import 'package:baemin/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    _APP(),
  );
}

class _APP extends StatelessWidget {
  const _APP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
    );
  }
}
