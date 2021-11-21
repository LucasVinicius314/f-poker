import 'package:f_poker/constants/constants.dart';
import 'package:f_poker/core/login_page.dart';
import 'package:f_poker/core/main_page.dart';
import 'package:f_poker/modules/game_page.dart';
import 'package:f_poker/modules/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          ),
        ),
      ),
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        LoginPage.route: (context) => const LoginPage(),
        MainPage.route: (context) => const MainPage(),
        GamePage.route: (context) => const GamePage(),
      },
    );
  }
}
