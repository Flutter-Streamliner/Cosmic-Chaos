import 'dart:async';
import 'dart:ui';

import 'package:cosmic_chaos/app_game.dart';
import 'package:cosmic_chaos/components/asteroid.dart';
import 'package:cosmic_chaos/components/laser.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

class Player extends SpriteAnimationComponent with HasGameReference<AppGame>, KeyboardHandler, CollisionCallbacks {

  bool _isShooting = false;
  final double _fireCooldown = 0.2;
  double _elapseFireTime = 0.0;
  final Vector2 _keyboardMovement = Vector2.zero();
  bool _isDestroyed = false;

  @override
  FutureOr<void> onLoad() async {
    animation = await _loadAnimation();
    size *= 0.3;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt){
    super.update(dt);
    if (_isDestroyed) return;
    final Vector2 movement = game.joystick.relativeDelta + _keyboardMovement;
    position += movement.normalized() * 200 * dt;
    _handleScreenBounds();

    _elapseFireTime += dt;
    if (_isShooting && _elapseFireTime >= _fireCooldown) {
      _fireLaser();
      _elapseFireTime = 0.0;
    }
  }

  Future<SpriteAnimation> _loadAnimation() async {
    return SpriteAnimation.spriteList([
      await game.loadSprite('player_blue_on0.png'),
      await game.loadSprite('player_blue_on1.png'),
    ], stepTime: 0.1,
      loop: true,
    );
  }

  void _handleScreenBounds() {
    final double screenWidth = game.size.x;
    final double screenHeight = game.size.y;

    // prevent the player from going off the top of the bottom edges
    _restrictPlayerMoveOutOfBounds();

    if (position.x >= screenWidth) {
      position.x = 0;
    } else if (position.x <= 0) {
      position.x = screenWidth;
    }
  }

  void _restrictPlayerMoveOutOfBounds() {
    final double screenHeight = game.size.y;
    position.y = clampDouble(position.y, size.y / 2, screenHeight - size.y / 2);
  }

  void startShooting() {
    _isShooting = true;
  }

  void stopShooting() {
    _isShooting = false;
  }

  void _fireLaser() {
    game.add(Laser(position: position.clone() + Vector2(0, -size.y - 2)));
  }

  void _handleDestruction() async {
    _isDestroyed = true;
    animation = SpriteAnimation.spriteList([
      await game.loadSprite('player_blue_off.png'),
    ], stepTime: double.infinity,);
    add(ColorEffect(
      const Color.fromRGBO(255, 255, 255, 1.0),
      EffectController(duration: 0.0),),
    );
    add(OpacityEffect.fadeOut(EffectController(duration: 3.0)));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (_isDestroyed) return;

    if (other is Asteroid) {
      _handleDestruction();
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keyboardMovement.x = 0;
    _keyboardMovement.x += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _keyboardMovement.x += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;

    _keyboardMovement.y = 0;
    _keyboardMovement.y += keysPressed.contains(LogicalKeyboardKey.keyW) ? -1 : 0;
    _keyboardMovement.y += keysPressed.contains(LogicalKeyboardKey.keyS) ? 1 : 0;
    return true;
  }
}