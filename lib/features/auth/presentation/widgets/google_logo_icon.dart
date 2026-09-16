import 'package:flutter/material.dart';

class GoogleLogoIcon extends StatelessWidget {
  final double size;
  final Color color;

  const GoogleLogoIcon({
    super.key,
    this.size = 26,
    this.color = const Color(0xFF121312),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleGPainter(color: color),
      ),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  final Color color;

  _GoogleGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(cx, cy), r, paint);

    final innerClear = Paint()
      ..color = const Color(0xFFFFBB3B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r * 0.58, innerClear);

    final barPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(cx - r * 0.05, cy - r * 0.22, w - r * 0.15, cy + r * 0.22),
      barPaint,
    );

    final gapPath = Path()
      ..moveTo(cx, cy)
      ..lineTo(w, cy)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r + 2),
        0,
        -1.3,
        false,
      )
      ..close();
    canvas.drawPath(gapPath, innerClear);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
