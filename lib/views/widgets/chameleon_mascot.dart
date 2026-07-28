import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Which idle animation [ChameleonMascot] plays.
enum MascotEffect {
  /// Whole-image rotation pivoted near the head, so the tail (further from
  /// the pivot) sweeps a visibly larger arc than the head — the closest
  /// approximation of an independent tail-wag without the source art being
  /// split into separate body/tail layers.
  wag,

  /// Slowly cycles the tint through the app's mood accent colors — a real
  /// chameleon's signature trait, and a nod to the app's mood-based
  /// browsing. Better suited to calmer spots (e.g. the login screen) where
  /// a physical wag would be too busy.
  colorShift,
}

/// The app's chameleon mark, reusable anywhere in the UI (not just the
/// launcher icon) — tintable via [color] since the source asset is a
/// transparent-background white glyph recolored at runtime with
/// [ColorFilter].
class ChameleonMascot extends StatefulWidget {
  const ChameleonMascot({
    super.key,
    this.size = 96,
    this.color,
    this.animate = true,
    this.bare = false,
    this.effect = MascotEffect.wag,
  });

  final double size;
  final Color? color;
  final bool animate;

  /// Uses the frame-less crop (just the chameleon, no decorative badge
  /// shape) instead of the default asset. For spots where the mascot sits
  /// right next to other icons and the badge shape would visually compete
  /// with them (e.g. perched on the browse screen's search bar).
  final bool bare;

  final MascotEffect effect;

  @override
  State<ChameleonMascot> createState() => _ChameleonMascotState();
}

class _ChameleonMascotState extends State<ChameleonMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const double _maxWagAngle = 0.16;

  static const List<Color> _moodCycleColors = [
    AppColors.primary,
    AppColors.moodMindBender,
    AppColors.moodNostalgia,
    AppColors.moodThriller,
    AppColors.primary,
  ];

  @override
  void initState() {
    super.initState();
    final isColorShift = widget.effect == MascotEffect.colorShift;
    _controller = AnimationController(
      vsync: this,
      duration: isColorShift
          ? const Duration(milliseconds: 9000)
          : const Duration(milliseconds: 1400),
    );
    if (widget.animate) {
      isColorShift ? _controller.repeat() : _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = widget.bare
        ? 'assets/images/chameleon_mascot_bare.png'
        : 'assets/images/chameleon_mascot.png';

    if (!widget.animate) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          widget.color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        child: Image.asset(assetPath, width: widget.size, fit: BoxFit.contain),
      );
    }

    final image = Image.asset(assetPath, width: widget.size, fit: BoxFit.contain);

    if (widget.effect == MascotEffect.colorShift) {
      return AnimatedBuilder(
        animation: _controller,
        child: image,
        builder: (context, child) {
          final tint = _sampleColorCycle(_controller.value);
          return ColorFiltered(
            colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
            child: child,
          );
        },
      );
    }

    final wag = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(widget.color ?? AppColors.primary, BlendMode.srcIn),
      child: AnimatedBuilder(
        animation: wag,
        child: image,
        builder: (context, child) {
          final angle = (wag.value - 0.5) * 2 * _maxWagAngle;
          return Transform.rotate(
            angle: angle,
            alignment: const Alignment(0.55, -0.35),
            child: child,
          );
        },
      ),
    );
  }

  Color _sampleColorCycle(double t) {
    final segments = _moodCycleColors.length - 1;
    final scaled = t * segments;
    final index = scaled.floor().clamp(0, segments - 1);
    final localT = scaled - index;
    return Color.lerp(
      _moodCycleColors[index],
      _moodCycleColors[index + 1],
      localT,
    )!;
  }
}
