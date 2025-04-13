import 'dart:async' show FutureOr;
import 'dart:math';
import 'dart:ui';

import 'package:cosmic_chaos/app_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

enum ExplosionType {
  dust, smoke, fire,
}

class Explosion extends PositionComponent with HasGameReference<AppGame> {
  final ExplosionType type;
  final double area;
  final Random _random = Random();

  Explosion({required super.position, required this.type, required this.area});

  void _createFlash() {
    final CircleComponent flash = CircleComponent(
      radius: area * 0.6,
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 1.0),
      anchor: Anchor.center
    );

    final OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(
      EffectController(duration: 0.3),
    );
    flash.add(fadeOutEffect);
    add(flash);
  }

  @override
  FutureOr<void> onLoad() {
    _createFlash();
    add(RemoveEffect(delay: 1.0));
    return super.onLoad();
  }
}