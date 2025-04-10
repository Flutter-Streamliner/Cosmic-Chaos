import 'dart:async';
import 'dart:math';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

class Asteroid extends SpriteComponent with HasGameReference<AppGame> {

  Asteroid({required super.position, double size = _maxSize})
    : super(size: Vector2.all(size), anchor: Anchor.center, priority: -1) {
    _velocity = _generateVelocity();
    _spinSpeed = _random.nextDouble() * 1.5 - 0.75;
    _health = size / _maxSize * _maxHealth;
    
    add(CircleHitbox());
  }

  static const double _maxSize = 120;

  final Random _random = Random();
  late Vector2 _velocity;
  late double _spinSpeed;
  final double _maxHealth = 3;
  late double _health;

  @override
  FutureOr<void> onLoad() async {
    final int imageNum = _random.nextInt(3) + 1;
    sprite = await game.loadSprite('asteroid$imageNum.png');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += _velocity * dt;
    angle += _spinSpeed * dt;
    _handleScreenBounds();
    super.update(dt);
  }

  Vector2 _generateVelocity() {
    final double forceFactor = _maxSize / size.x;
    return Vector2(
      _random.nextDouble() * 120 - 60,
      100 + _random.nextDouble() * 50,
    ) * forceFactor;
  }

  void _handleScreenBounds() {

    // remove the asteroid from the game if it goes below the bottom
    if (position.y > game.size.y + size.y / 2) {
      removeFromParent();
    }
    final double screenWidth = game.size.x;
    if (position.x < -size.x / 2) {
      position.x = screenWidth + size.x / 2;
    } else if (position.x > screenWidth + size.x / 2) {
      position.x = -size.x / 2;
    }
  }

  void takeDamage() {
    _health--;
    if (_health <= 0) {
      removeFromParent();
    } else {
      _flashWhite();
    }
  }

  void _flashWhite() {
    final ColorEffect flashEffect = ColorEffect(
      const Color.fromRGBO(255, 255, 255, 1.0),
      EffectController(
        duration: 0.1,
        alternate: true,
        curve: Curves.easeInOut,
      ),
    );
    add(flashEffect);
  }
}