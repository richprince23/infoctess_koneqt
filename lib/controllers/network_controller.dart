import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkProvider extends ChangeNotifier {
  bool? _isConnected;
  bool get isConnected => _isConnected ?? false;

  void setConnection(bool status) async {
    _isConnected = status;
    notifyListeners();
  }
}
