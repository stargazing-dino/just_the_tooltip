import 'package:flutter/material.dart';

class JustTheController extends ChangeNotifier {
  Future<void> showTooltip({bool immediately = false}) async {}

  Future<void> hideTooltip({bool immediately = false}) async {}

  bool _isShowing = false;
  bool get isShowing => _isShowing;
  set isShowing(bool isShowing) {
    _isShowing = isShowing;
    notifyListeners();
  }

  // TODO: Add current axis, override axis, stuff like that
}
