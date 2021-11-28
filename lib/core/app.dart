import 'package:f_poker/constants/colors.dart';
import 'package:f_poker/constants/constants.dart';
import 'package:f_poker/core/login_page.dart';
import 'package:f_poker/core/main_page.dart';
import 'package:f_poker/core/register_page.dart';
import 'package:f_poker/modules/game_page.dart';
import 'package:f_poker/modules/splash_page.dart';
import 'package:f_poker/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: Constants.appName,
        color: ExtendedColors.oysterBay,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: ExtendedColors.oysterBay,
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
          RegisterPage.route: (context) => const RegisterPage(),
        },
      ),
    );
  }
}
