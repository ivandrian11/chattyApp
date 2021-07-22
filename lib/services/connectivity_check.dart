import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityCheck extends StatelessWidget {
  static bool isDisconnect;
  final Widget child;

  ConnectivityCheck({@required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          isDisconnect = snapshot.data == ConnectivityResult.none;
          if (isDisconnect) {
            return Center(
              child: Text("No Network"),
            );
          } else {
            return child;
          }
        });
  }
}
