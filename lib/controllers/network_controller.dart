import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:provider/provider.dart';

late StreamSubscription<ConnectivityResult> connectivitySubscription;

class NetworkProvider extends ChangeNotifier {
  bool? _isConnected;
  bool get isConnected => _isConnected ?? false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();

  void setConnection(bool status) async {
    _isConnected = status;
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      throw e;
    }
    // // if (!mounted) {
    //   return Future.value(null);
    // // }
    notifyListeners();

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    notifyListeners();
  }
}
