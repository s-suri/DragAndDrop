import 'package:flutter/material.dart';
import 'package:icons_swap/drag_and_drop_between_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DragAndDropBetweenIcons(),
    );
  }
}
