import 'dart:async';
import 'dart:math';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/components.dart';

class Asteroid extends SpriteComponent with HasGameReference<AppGame> {

  Asteroid({required super.position})
    : super(size: Vector2.all(120), anchor: Anchor.center);

  final Random _random = Random();

  @override
  FutureOr<void> onLoad() async {
    final int imageNum = _random.nextInt(3) + 1;
    sprite = await game.loadSprite('asteroid$imageNum.png');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += 150 * dt;

    // remove the asteroid from the game if it goes below the bottom
    if (position.y > game.size.y + size.y / 2) {
      removeFromParent();
    }
    super.update(dt);
  }
}