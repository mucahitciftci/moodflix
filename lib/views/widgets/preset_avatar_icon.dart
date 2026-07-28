import 'package:flutter/material.dart';

import '../../core/constants/preset_avatar_config.dart';

/// A minimal, single-color animal silhouette (no photo/asset involved —
/// pure `CustomPainter` shapes), used for the preset-avatar picker and
/// anywhere a user's chosen preset avatar is shown.
class PresetAvatarIcon extends StatelessWidget {
  const PresetAvatarIcon({
    super.key,
    required this.animal,
    required this.color,
    this.size = 32,
  });

  final PresetAnimal animal;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PresetAnimalPainter(animal: animal, color: color),
    );
  }
}

class _PresetAnimalPainter extends CustomPainter {
  _PresetAnimalPainter({required this.animal, required this.color});

  final PresetAnimal animal;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    switch (animal) {
      case PresetAnimal.cat:
        _paintCat(canvas, size, paint);
      case PresetAnimal.fish:
        _paintFish(canvas, size, paint);
      case PresetAnimal.bird:
        _paintBird(canvas, size, paint);
      case PresetAnimal.owl:
        _paintOwl(canvas, size, paint);
      case PresetAnimal.bear:
        _paintBear(canvas, size, paint);
      case PresetAnimal.rabbit:
        _paintRabbit(canvas, size, paint);
    }
  }

  Offset _p(Size size, double fx, double fy) => Offset(fx * size.width, fy * size.height);

  void _paintCat(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(_p(size, 0.5, 0.58), 0.34 * size.width, paint);
    final leftEar = Path()
      ..moveTo(_p(size, 0.22, 0.42).dx, _p(size, 0.22, 0.42).dy)
      ..lineTo(_p(size, 0.30, 0.08).dx, _p(size, 0.30, 0.08).dy)
      ..lineTo(_p(size, 0.44, 0.36).dx, _p(size, 0.44, 0.36).dy)
      ..close();
    final rightEar = Path()
      ..moveTo(_p(size, 0.78, 0.42).dx, _p(size, 0.78, 0.42).dy)
      ..lineTo(_p(size, 0.70, 0.08).dx, _p(size, 0.70, 0.08).dy)
      ..lineTo(_p(size, 0.56, 0.36).dx, _p(size, 0.56, 0.36).dy)
      ..close();
    canvas.drawPath(leftEar, paint);
    canvas.drawPath(rightEar, paint);
  }

  void _paintFish(Canvas canvas, Size size, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: _p(size, 0.42, 0.5), width: 0.60 * size.width, height: 0.40 * size.height),
      paint,
    );
    final tail = Path()
      ..moveTo(_p(size, 0.64, 0.5).dx, _p(size, 0.64, 0.5).dy)
      ..lineTo(_p(size, 0.94, 0.26).dx, _p(size, 0.94, 0.26).dy)
      ..lineTo(_p(size, 0.94, 0.74).dx, _p(size, 0.94, 0.74).dy)
      ..close();
    canvas.drawPath(tail, paint);
    final topFin = Path()
      ..moveTo(_p(size, 0.38, 0.32).dx, _p(size, 0.38, 0.32).dy)
      ..lineTo(_p(size, 0.46, 0.10).dx, _p(size, 0.46, 0.10).dy)
      ..lineTo(_p(size, 0.54, 0.32).dx, _p(size, 0.54, 0.32).dy)
      ..close();
    canvas.drawPath(topFin, paint);
  }

  void _paintBird(Canvas canvas, Size size, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: _p(size, 0.44, 0.58), width: 0.52 * size.width, height: 0.48 * size.height),
      paint,
    );
    canvas.drawCircle(_p(size, 0.66, 0.36), 0.18 * size.width, paint);
    final beak = Path()
      ..moveTo(_p(size, 0.80, 0.33).dx, _p(size, 0.80, 0.33).dy)
      ..lineTo(_p(size, 0.96, 0.38).dx, _p(size, 0.96, 0.38).dy)
      ..lineTo(_p(size, 0.80, 0.44).dx, _p(size, 0.80, 0.44).dy)
      ..close();
    canvas.drawPath(beak, paint);
    final tail = Path()
      ..moveTo(_p(size, 0.20, 0.48).dx, _p(size, 0.20, 0.48).dy)
      ..lineTo(_p(size, 0.02, 0.34).dx, _p(size, 0.02, 0.34).dy)
      ..lineTo(_p(size, 0.06, 0.60).dx, _p(size, 0.06, 0.60).dy)
      ..close();
    canvas.drawPath(tail, paint);
  }

  void _paintOwl(Canvas canvas, Size size, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: _p(size, 0.5, 0.58), width: 0.62 * size.width, height: 0.72 * size.height),
      paint,
    );
    final leftTuft = Path()
      ..moveTo(_p(size, 0.34, 0.30).dx, _p(size, 0.34, 0.30).dy)
      ..lineTo(_p(size, 0.30, 0.06).dx, _p(size, 0.30, 0.06).dy)
      ..lineTo(_p(size, 0.46, 0.26).dx, _p(size, 0.46, 0.26).dy)
      ..close();
    final rightTuft = Path()
      ..moveTo(_p(size, 0.66, 0.30).dx, _p(size, 0.66, 0.30).dy)
      ..lineTo(_p(size, 0.70, 0.06).dx, _p(size, 0.70, 0.06).dy)
      ..lineTo(_p(size, 0.54, 0.26).dx, _p(size, 0.54, 0.26).dy)
      ..close();
    canvas.drawPath(leftTuft, paint);
    canvas.drawPath(rightTuft, paint);
  }

  void _paintBear(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(_p(size, 0.5, 0.56), 0.34 * size.width, paint);
    canvas.drawCircle(_p(size, 0.25, 0.24), 0.13 * size.width, paint);
    canvas.drawCircle(_p(size, 0.75, 0.24), 0.13 * size.width, paint);
  }

  void _paintRabbit(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(_p(size, 0.5, 0.70), 0.26 * size.width, paint);
    final leftEar = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        _p(size, 0.32, 0.04).dx,
        _p(size, 0.32, 0.04).dy,
        _p(size, 0.46, 0.56).dx,
        _p(size, 0.46, 0.56).dy,
      ),
      Radius.circular(0.07 * size.width),
    );
    final rightEar = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        _p(size, 0.54, 0.04).dx,
        _p(size, 0.54, 0.04).dy,
        _p(size, 0.68, 0.56).dx,
        _p(size, 0.68, 0.56).dy,
      ),
      Radius.circular(0.07 * size.width),
    );
    canvas.drawRRect(leftEar, paint);
    canvas.drawRRect(rightEar, paint);
  }

  @override
  bool shouldRepaint(covariant _PresetAnimalPainter oldDelegate) =>
      oldDelegate.animal != animal || oldDelegate.color != color;
}
