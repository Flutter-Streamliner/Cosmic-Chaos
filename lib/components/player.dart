import 'dart:async';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameReference<AppGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('player_blue_on0.png');
    size *= 0.3;
    return super.onLoad();
  }

  @override
  void update(double dt){
    super.update(dt);
    position += game.joystick.relativeDelta.normalized() * 200 * dt;
  }
}