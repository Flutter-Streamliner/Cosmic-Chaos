import 'dart:async';
import 'dart:math';

import 'package:cosmic_chaos/components/asteroid.dart';
import 'package:cosmic_chaos/components/player.dart';
import 'package:cosmic_chaos/components/shoot_button.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class AppGame extends FlameGame {

  final Random _random = Random();

  late Player player;
  late JoystickComponent joystick;
  late SpawnComponent _asteroidSpawner;
  late ShootButton _shootButton;

  @override
  FutureOr<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
    await startGame();
    super.onLoad();
  }

  Future<void> startGame() async {
    await _createJoystick();
    await _createPlayer();
    _createShootButton();
    _createAsteroidSpawner();
  }

  Future<void> _createPlayer() async {
    player = Player()
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y * 0.8);
    add(player);
  }

  Future<void> _createJoystick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: await loadSprite('joystick_knob.png'),
        size: Vector2.all(50),
      ),
      background: SpriteComponent(
        sprite: await loadSprite('joystick_background.png'),
        size: Vector2.all(100),
      ),
      anchor: Anchor.bottomLeft,
      position: Vector2(20, size.y - 20),
      priority: 10,
    );
    add(joystick);
  }

  void _createShootButton() {
    _shootButton = ShootButton()
        ..anchor = Anchor.bottomRight
        ..position = Vector2(size.x - 20, size.y - 20)
        ..priority = 10;
    add(_shootButton);
  }

  void _createAsteroidSpawner() {
    _asteroidSpawner = SpawnComponent.periodRange(
      factory: (index) => Asteroid(position: _generateSpawnPosition()),
      minPeriod: 0.7,
      maxPeriod: 2,
      selfPositioning: true,
    );
    add(_asteroidSpawner);
  }

  Vector2 _generateSpawnPosition() {
    return Vector2(
      10 + _random.nextDouble() * (size.x - 10 * 2),
      100,
    );
  }

  @override
  Color backgroundColor() => Colors.black;
}