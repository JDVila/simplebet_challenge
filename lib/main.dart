import 'package:flutter/material.dart';
import 'util/custom_material_colors_util.dart';
import 'pages/game_schedule_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          primaryColor: CustomMaterialColorsUtil.primaryBlack,
          backgroundColor: CustomMaterialColorsUtil.primaryBlack),
      home: GameSchedulePage(),
    );
  }
}