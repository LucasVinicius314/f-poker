import 'package:f_poker/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  User? _user;

  // User

  User? get user => this._user;

  set user(User? user) {
    this._user = user;

    notifyListeners();
  }
}
