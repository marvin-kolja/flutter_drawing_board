import 'dart:math';

import 'package:flutter/painting.dart';
import '../paint_extension/ex_offset.dart';
import '../paint_extension/ex_paint.dart';

import 'paint_content.dart';

/// Arrow
class StraightArrow extends PaintContent {
  StraightArrow();

  StraightArrow.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
    this.arrowTipLength = 10,
    this.arrowTipRadian = pi / 4,
  }) : super.paint(paint);

  factory StraightArrow.fromJson(Map<String, dynamic> data) {
    return StraightArrow.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      endPoint: jsonToOffset(data['endPoint'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
      arrowTipLength: data['arrowTipLength'] as double,
      arrowTipRadian: data['arrowTipRadian'] as double,
    );
  }

  /// Length of the arrow tip lines.
  /// The default value is 10.
  double arrowTipLength = 10;

  /// The angle of the arrow tip lines as radians in the range of [0, pi].
  /// The default value is pi / 4.
  double arrowTipRadian = pi / 4;

  late Offset startPoint;
  late Offset endPoint;

  List<Offset> tipOffsets() {
    return <Offset>[
      _calculateTipOffset(arrowTipRadian, -arrowTipLength),
      _calculateTipOffset(-arrowTipRadian, -arrowTipLength),
    ];
  }

  Offset _calculateTipOffset(double radian, double length) {
    final double x = length * cos(radian);
    final double y = length * sin(radian);
    return Offset(x, y);
  }

  Offset _rotateOffset(Offset offset, double radian) {
    final double x = offset.dx * cos(radian) - offset.dy * sin(radian);
    final double y = offset.dx * sin(radian) + offset.dy * cos(radian);
    return Offset(x, y);
  }

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    canvas.drawLine(startPoint, endPoint, paint);

    final Offset direction = endPoint - startPoint;

    for (final Offset tipOffset in tipOffsets()) {
      final Offset tipOffsetRotated =
          _rotateOffset(tipOffset, direction.direction);
      canvas.drawLine(endPoint, endPoint + tipOffsetRotated, paint);
    }
  }

  @override
  StraightArrow copy() => StraightArrow();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'endPoint': endPoint.toJson(),
      'paint': paint.toJson(),
      'arrowTipLength': arrowTipLength,
      'arrowTipRadian': arrowTipRadian,
    };
  }
}
