// Role: Paints the comparison chart (current month + previous month) similar to the SVG in HTML.
import 'dart:ui';
import 'package:flutter/material.dart';

// TODO: Replace with your actual DS import path.
import 'package:paylance/core/design_system/design_system.dart';

class SpendingComparisonChart extends StatelessWidget {
  const SpendingComparisonChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;
    final bg = theme.colorScheme.surface; // background-main

    return Stack(
      children: [
        // Grid + paths
        CustomPaint(
          painter: _ComparisonChartPainter(
            primary: primary,
            muted: muted,
            background: bg,
          ),
          size: Size.infinite,
        ),
        // Tooltip bubble (static like HTML)
        Align(
          alignment: const Alignment(0.40, -0.35), // approx: left 70% / top 20%
          child: _TooltipBubble(text: '2.150.000 đ'),
        ),
      ],
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = theme.colorScheme.surfaceContainerHighest;
    final border = Colors.white.withOpacity(0.10);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.35),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              text,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
            Positioned(
              bottom: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: 0.785398, // 45deg
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: card,
                      border: Border(
                        right: BorderSide(color: border),
                        bottom: BorderSide(color: border),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonChartPainter extends CustomPainter {
  _ComparisonChartPainter({
    required this.primary,
    required this.muted,
    required this.background,
  });

  final Color primary;
  final Color muted;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Reserve padding similar to SVG: pt-4 pb-6
    final topPad = 16.0;
    final bottomPad = 24.0;
    final leftPad = 0.0;
    final rightPad = 0.0;

    final chartRect = Rect.fromLTWH(
      leftPad,
      topPad,
      w - leftPad - rightPad,
      h - topPad - bottomPad,
    );

    // Horizontal dashed grid lines + labels (5tr, 2.5tr, 1tr, 0)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dashed = _DashedPathEffect(dashLength: 4, gapLength: 4);

    final labels = ['5tr', '2.5tr', '1tr', '0'];
    for (int i = 0; i < 4; i++) {
      final y = chartRect.top + (chartRect.height / 3) * i;
      final p = Path()
        ..moveTo(chartRect.left, y)
        ..lineTo(chartRect.right, y);
      canvas.drawPath(dashed.applyTo(p), gridPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: muted.withOpacity(0.5),
            fontSize: 10,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(chartRect.left, y - tp.height - 2));
    }

    // Build paths based on the SVG coordinates (normalized to 400x180-ish)
    // SVG:
    // prev: M0 120 C 50 120, 100 80, 150 90 C 200 100, 250 60, 300 70 S 350 40, 400 50
    // cur : M0 130 C 50 130, 100 100, 150 110 C 200 120, 250 50, 300 60 S 350 20, 400 30
    Path prev = _pathFromSvgLikePoints(chartRect, [
      const _CubicSeg(0, 120, 50, 120, 100, 80, 150, 90),
      const _CubicSeg(150, 90, 200, 100, 250, 60, 300, 70),
      const _CubicSeg(300, 70, 350, 40, 350, 40, 400, 50), // S -> approx cubic
    ]);

    Path cur = _pathFromSvgLikePoints(chartRect, [
      const _CubicSeg(0, 130, 50, 130, 100, 100, 150, 110),
      const _CubicSeg(150, 110, 200, 120, 250, 50, 300, 60),
      const _CubicSeg(300, 60, 350, 20, 350, 20, 400, 30),
    ]);

    // Previous month dashed line
    final prevPaint = Paint()
      ..color = muted.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(dashed.applyTo(prev), prevPaint);

    // Current month line
    final curPaint = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Area gradient under current path
    final area = Path.from(cur)
      ..lineTo(chartRect.right, chartRect.bottom + 8)
      ..lineTo(chartRect.left, chartRect.bottom + 8)
      ..close();

    final shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primary.withOpacity(0.20), primary.withOpacity(0.0)],
    ).createShader(chartRect);

    final areaPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    canvas.drawPath(area, areaPaint);
    canvas.drawPath(cur, curPaint);

    // Points (150,110) and (300,60) with background fill
    _drawPoint(canvas, chartRect, 150, 110);
    _drawPoint(canvas, chartRect, 300, 60);
  }

  void _drawPoint(Canvas canvas, Rect chartRect, double xSvg, double ySvg) {
    final p = _mapSvgToChart(chartRect, xSvg, ySvg);
    final r = 4.0;

    final fill = Paint()..color = background;
    final stroke = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(p, r, fill);
    canvas.drawCircle(p, r, stroke);
  }

  // Map SVG-like coordinates (0..400 in X, 0..180 in Y) into chartRect.
  static Offset _mapSvgToChart(Rect chartRect, double x, double y) {
    const svgW = 400.0;
    const svgH = 180.0;

    final dx = chartRect.left + (x / svgW) * chartRect.width;
    final dy = chartRect.top + (y / svgH) * chartRect.height;
    return Offset(dx, dy);
  }

  static Path _pathFromSvgLikePoints(Rect chartRect, List<_CubicSeg> segs) {
    final p0 = _mapSvgToChart(chartRect, segs.first.x0, segs.first.y0);
    final path = Path()..moveTo(p0.dx, p0.dy);

    for (final s in segs) {
      final c1 = _mapSvgToChart(chartRect, s.x1, s.y1);
      final c2 = _mapSvgToChart(chartRect, s.x2, s.y2);
      final p = _mapSvgToChart(chartRect, s.x3, s.y3);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p.dx, p.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _ComparisonChartPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.muted != muted ||
        oldDelegate.background != background;
  }
}

class _CubicSeg {
  const _CubicSeg(
    this.x0,
    this.y0,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.x3,
    this.y3,
  );
  final double x0, y0, x1, y1, x2, y2, x3, y3;
}

class _DashedPathEffect {
  _DashedPathEffect({required this.dashLength, required this.gapLength});

  final double dashLength;
  final double gapLength;

  Path applyTo(Path source) {
    final out = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = (distance + dashLength).clamp(0, metric.length).toDouble();
        out.addPath(metric.extractPath(distance, len), Offset.zero);
        distance += dashLength + gapLength;
      }
    }
    return out;
  }
}
