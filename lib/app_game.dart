import 'dart:async';

import 'package:cosmic_chaos/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class AppGame extends FlameGame {

  late Player player;

  @override
  FutureOr<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
    startGame();
    super.onLoad();
  }

  void startGame() {
    _createPlayer();
  }

  void _createPlayer() {
    player = Player()
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y * 0.8);
    add(player);
  }

  @override
  Color backgroundColor() => Colors.black;
}