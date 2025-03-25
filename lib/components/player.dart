import 'dart:async';

import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameReference {
  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('player_blue_on0.png');
    size *= 0.3;
    return super.onLoad();
  }
}