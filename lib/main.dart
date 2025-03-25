import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final AppGame appGame = AppGame();
  runApp(GameWidget(game: appGame));
}
