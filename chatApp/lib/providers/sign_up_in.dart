
import 'package:flutter/foundation.dart';

class SignMode with ChangeNotifier {
  String? _mode ='login';

  String? get mode {
    return _mode;
  } 

  void swithchMode(String mode) {
    _mode = mode;
    notifyListeners();
  }
}