import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(289.348, 4.3514);
    path_0.lineTo(2.25296, 269.103);
    path_0.cubicTo(-0.63295, 271.764, -0.775463, 276.275, 1.9367, 279.113);
    path_0.lineTo(212.639, 499.605);
    path_0.cubicTo(213.964, 500.991, 215.797, 501.775, 217.714, 501.775);
    path_0.lineTo(315.532, 501.775);
    path_0.cubicTo(319.409, 501.775, 322.552, 498.632, 322.552, 494.755);
    path_0.lineTo(322.552, 439.209);
    path_0.cubicTo(322.552, 435.557, 325.513, 432.596, 329.165, 432.596);
    path_0.cubicTo(332.817, 432.596, 335.778, 435.557, 335.778, 439.209);
    path_0.lineTo(335.778, 619.035);
    path_0.cubicTo(335.778, 620.742, 336.4, 622.391, 337.528, 623.673);
    path_0.lineTo(414.052, 710.618);
    path_0.cubicTo(415.385, 712.132, 417.304, 713, 419.321, 713);
    path_0.lineTo(467.117, 713);
    path_0.cubicTo(470.994, 713, 474.137, 709.857, 474.137, 705.98);
    path_0.lineTo(474.137, 353.835);
    path_0.cubicTo(474.137, 349.958, 470.994, 346.815, 467.117, 346.815);
    path_0.lineTo(364.067, 346.815);
    path_0.cubicTo(361.656, 346.815, 359.414, 348.052, 358.129, 350.092);
    path_0.lineTo(337.843, 382.278);
    path_0.cubicTo(336.557, 384.318, 334.315, 385.555, 331.904, 385.555);
    path_0.lineTo(329.572, 385.555);
    path_0.cubicTo(325.695, 385.555, 322.552, 382.412, 322.552, 378.535);
    path_0.lineTo(322.552, 303.104);
    path_0.cubicTo(322.552, 299.227, 325.695, 296.084, 329.572, 296.084);
    path_0.lineTo(634.98, 296.084);
    path_0.cubicTo(638.857, 296.084, 642, 292.941, 642, 289.064);
    path_0.lineTo(642, 45.7597);
    path_0.cubicTo(642, 41.8828, 638.857, 38.74, 634.98, 38.74);
    path_0.lineTo(557.56, 38.74);
    path_0.cubicTo(544.081, 38.74, 531.998, 20.3993, 528.241, 7.8075);
    path_0.cubicTo(527.132, 4.09245, 523.897, 0.92238, 520.02, 0.92238);
    path_0.lineTo(454.706, 0.92238);
    path_0.cubicTo(450.829, 0.92238, 447.581, 4.09539, 446.41, 7.7911);
    path_0.cubicTo(442.419, 20.3834, 429.633, 38.74, 416.148, 38.74);
    path_0.lineTo(339.503, 38.74);
    path_0.cubicTo(337.76, 38.74, 336.08, 38.0915, 334.788, 36.9207);
    path_0.lineTo(298.822, 4.31134);
    path_0.cubicTo(296.129, 1.87041, 292.019, 1.88779, 289.348, 4.3514);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffD9D9D9).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
