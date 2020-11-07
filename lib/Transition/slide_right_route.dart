import 'package:flutter/material.dart';
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  final double dx,dy;
  SlideRightRoute({this.page,this.dx,this.dy})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) => page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) => SlideTransition(
          position: Tween<Offset>(
            begin:  Offset(dx, dy),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );


}