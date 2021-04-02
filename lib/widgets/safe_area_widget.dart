import 'package:flutter/material.dart';

class SafeAreaWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  SafeAreaWidget({@required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        minimum: EdgeInsets.only(top: 8),
        child: child,
      ),
    );
  }
}
