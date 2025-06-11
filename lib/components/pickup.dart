import 'dart:async';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum PickupType {
  bomb, laser, shield,
}

class Pickup extends SpriteComponent with HasGameReference<AppGame> {
  final PickupType type;

  Pickup({required super.position, required this.type}) : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('${type.name}_pickup.png');
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 300 * dt;

    // remove pickup from the game if it goes below the bottom
    if (position.y > game.size.y + size.y / 2) {
      removeFromParent();
    }
  }

}