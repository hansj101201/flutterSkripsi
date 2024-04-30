import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWillPopScopeWidget extends StatelessWidget {
  final Widget child;

  const CustomWillPopScopeWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Use SystemNavigator.pop instead of Navigator.of(context).pop
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => {
                  SystemNavigator.pop(animated: true), // Use SystemNavigator.pop instead of Navigator.of(context).pop
                  Navigator.of(context).pop(true),
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
