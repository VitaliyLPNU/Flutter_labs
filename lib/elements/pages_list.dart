import 'package:flutter/material.dart';

import 'package:lab2/config/responsive_config.dart';

List<Widget> pagesList(BuildContext context) {
  final contentFontSize = ResponsiveConfig.contentFontSize(context);
  return [
    Center(
      child: Text('Home', style: TextStyle(fontSize: contentFontSize)),
    ),
    Center(
      child: Text('Exercises', style: TextStyle(fontSize: contentFontSize)),
    ),
  ];
}
