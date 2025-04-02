import 'dart:async';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/components.dart';

class Laser extends SpriteComponent with HasGameReference<AppGame> {
  Laser({required super.position})
    : super(
      anchor: Anchor.center,
      priority: -1,
  );

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite("laser.png");
    size *= 0.25;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y -= 500 * dt;

    // remove the laser from the game if it goes about the top
    if (position.y < - size.y / 2) {
      removeFromParent();
    }
  }
}