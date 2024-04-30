import 'package:flutter/material.dart';

class CustomWillPopScope extends StatelessWidget {
  final Widget child;

  CustomWillPopScope({required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Menonaktifkan tombol "Back"
      },
      child: child,
    );
  }
}