import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

abstract class XppStroke extends XppContent {
  XppStroke(
      {this.tool = XppStrokeTool.PEN,
      this.points,
      this.color,
      this.editingTool,
      this.capStyle,
      this.fill,
      this.style,
      this.audioTs,
      this.audioFn});

  XppStrokeTool tool;
  List<XppStrokePoint>? points;
  Color? color;
  EditingTool? editingTool;

  /// Desktop stroke attributes preserved for round-trip.
  String? capStyle;
  String? fill;
  String? style;
  String? audioTs;
  String? audioFn;

  @override
  Offset getOffset() {
    if (points!.isEmpty) return Offset(0, 0);
    double x = points![0].x!;
    double y = points![0].y!;
    points!.forEach((point) {
      if (point.x! < x) x = point.x!;
      if (point.y! < y) y = point.y!;
    });
    return Offset(x, y);
  }

  Offset get bottomRight {
    if (points!.isEmpty) return Offset(0, 0);
    double x = points![0].x!;
    double y = points![0].y!;
    points!.forEach((point) {
      if (point.x! > x) x = point.x!;
      if (point.y! > y) y = point.y!;
    });
    return Offset(x, y);
  }

  @override
  Rect getBounds() {
    final topLeft = getOffset();
    final br = bottomRight;
    return Rect.fromLTRB(topLeft.dx, topLeft.dy, br.dx, br.dy);
  }

  @override
  XppPageContentWidget render() {
    if (points!.isEmpty) {
      return XppPageContentWidget(child: (Container()));
    }
    Color? colorToUse = color;
    if (tool == XppStrokeTool.ERASER) colorToUse = Colors.white;
    if (tool == XppStrokeTool.HIGHLIGHTER) {
      colorToUse = color!.withOpacity(.5);
    }
    return XppPageContentWidget(
      child: CustomPaint(
        size: Size(
            bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),
        foregroundPainter: XppStrokePainter(
            points: points,
            color: colorToUse,
            topLeft: getOffset(),
            smoothPressure: tool == XppStrokeTool.PEN),
      ),
      tool: EditingTool.STYLUS,
    );
  }

  @override
  XmlElement toXmlElement() {
    late String toolString;
    switch (tool) {
      case XppStrokeTool.PEN:
        toolString = 'pen';
        break;
      case XppStrokeTool.HIGHLIGHTER:
        toolString = 'highlighter';
        break;
      case XppStrokeTool.ERASER:
        toolString = 'eraser';
        break;
    }
    final attributes = <XmlAttribute>[
      XmlAttribute(XmlName('tool'), toolString),
      XmlAttribute(XmlName('color'), color!.toHexTriplet()),
      XmlAttribute(
          XmlName('width'), points!.map((e) => e.width.toString()).join(' ')),
    ];
    if (capStyle != null && capStyle!.isNotEmpty) {
      attributes.add(XmlAttribute(XmlName('capStyle'), capStyle!));
    }
    if (fill != null && fill!.isNotEmpty) {
      attributes.add(XmlAttribute(XmlName('fill'), fill!));
    }
    if (style != null && style!.isNotEmpty) {
      attributes.add(XmlAttribute(XmlName('style'), style!));
    }
    if (audioTs != null && audioTs!.isNotEmpty) {
      attributes.add(XmlAttribute(XmlName('ts'), audioTs!));
      if (audioFn != null && audioFn!.isNotEmpty) {
        attributes.add(XmlAttribute(XmlName('fn'), audioFn!));
      }
    }
    XmlElement node = XmlElement(XmlName('stroke'), attributes, [
      XmlText(
          points!.map((e) => e.x.toString() + ' ' + e.y.toString()).join(' '))
    ]);
    return node;
  }

  bool _shouldErase({Offset? coordinates, double? radius}) {
    bool erase = false;
    points!.forEach((element) {
      if (_shouldRemovePoint(element, coordinates!, radius!)) erase = true;
    });
    return (erase);
  }

  @override
  XppContentEraseData eraseWhere({Offset? coordinates, double? radius}) {
    if (!_shouldErase(coordinates: coordinates, radius: radius))
      return XppContentEraseData();
    List<XppStroke> newStrokes = [];
    bool lastPointRemoved = true;
    for (int i = 0; i < points!.length; i++) {
      if (_shouldRemovePoint(points![i], coordinates!, radius!)) {
        lastPointRemoved = true;
      } else {
        if (lastPointRemoved) {
          newStrokes.add(newStroke(color: color, points: [points![i]]));
        } else {
          newStrokes.last.points!.add(points![i]);
        }
        lastPointRemoved = false;
      }
    }
    return XppContentEraseData(
        affected: true, delete: newStrokes.isEmpty, newContent: newStrokes);
  }

  @override
  bool inRegion({Offset? topLeft, Offset? bottomRight}) {
    final bounds = getBounds();
    final region = Rect.fromLTRB(
        topLeft!.dx, topLeft.dy, bottomRight!.dx, bottomRight.dy);
    return region.contains(bounds.topLeft) && region.contains(bounds.bottomRight);
  }

  @override
  bool shouldSelectAt({Offset? coordinates, EditingTool? tool}) {
    const tapThreshold = 12.0;
    if (points!.length == 1) {
      return (points![0].offset - coordinates!).distance < tapThreshold;
    }
    for (int i = 1; i < points!.length; i++) {
      if (_distanceToSegment(
              coordinates!, points![i - 1].offset, points![i].offset) <
          tapThreshold) return true;
    }
    return false;
  }

  static double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final ap = p - a;
    final ab2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (ab2 == 0) return ap.distance;
    final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / ab2).clamp(0.0, 1.0);
    final projection = a + ab * t;
    return (p - projection).distance;
  }

  @override
  void translate(Offset delta) {
    points!.forEach((point) {
      point.x = point.x! + delta.dx;
      point.y = point.y! + delta.dy;
    });
  }

  @override
  void applyScaleDelta(double scaleDelta, {Offset? anchor}) {
    final a = anchor ?? getOffset();
    points!.forEach((point) {
      point.x = a.dx + (point.x! - a.dx) * scaleDelta;
      point.y = a.dy + (point.y! - a.dy) * scaleDelta;
    });
  }

  @override
  void applyRotationDelta(double radians, {Offset? center}) {
    final c = center ?? getBounds().center;
    final cos = math.cos(radians);
    final sin = math.sin(radians);
    points!.forEach((point) {
      final dx = point.x! - c.dx;
      final dy = point.y! - c.dy;
      point.x = c.dx + dx * cos - dy * sin;
      point.y = c.dy + dx * sin + dy * cos;
    });
  }

  @override
  XppStroke clone();

  XppStroke newStroke({Color? color, List<XppStrokePoint>? points});

  bool _shouldRemovePoint(
      XppStrokePoint element, Offset coordinates, double radius) {
    return ((element.x! - coordinates.dx).abs() <
            (element.width! + radius) / 2 &&
        (element.y! - coordinates.dy).abs() < (element.width! + radius) / 2);
  }

  static XppStroke byTool(
      {required XppStrokeTool tool,
      List<XppStrokePoint>? points,
      Color? color,
      String? capStyle,
      String? fill,
      String? style,
      String? audioTs,
      String? audioFn}) {
    XppStroke? stroke;
    switch (tool) {
      case XppStrokeTool.PEN:
        stroke = XppStrokePen(
            color: color,
            points: points,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);
        break;
      case XppStrokeTool.HIGHLIGHTER:
        stroke = XppStrokeHighlight(
            color: color,
            points: points,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);
        break;
      case XppStrokeTool.ERASER:
        stroke = XppStrokeWhiteout(
            color: color,
            points: points,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);
        break;
    }
    return stroke;
  }
}

class XppStrokePen extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.PEN;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokePen(
      {this.points,
      this.color,
      String? capStyle,
      String? fill,
      String? style,
      String? audioTs,
      String? audioFn})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.PEN,
            editingTool: EditingTool.STYLUS,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokePen(points: points, color: color);
  }

  @override
  XppStroke clone() {
    return XppStrokePen(
      color: color,
      points: points!.map((p) => p.clone()).toList(),
      capStyle: capStyle,
      fill: fill,
      style: style,
      audioTs: audioTs,
      audioFn: audioFn,
    );
  }
}

class XppStrokeWhiteout extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.ERASER;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokeWhiteout(
      {this.points,
      this.color,
      String? capStyle,
      String? fill,
      String? style,
      String? audioTs,
      String? audioFn})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.ERASER,
            editingTool: EditingTool.WHITEOUT,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokeWhiteout(points: points, color: color);
  }

  @override
  XppStroke clone() {
    return XppStrokeWhiteout(
      color: color,
      points: points!.map((p) => p.clone()).toList(),
      capStyle: capStyle,
      fill: fill,
      style: style,
      audioTs: audioTs,
      audioFn: audioFn,
    );
  }
}

class XppStrokeHighlight extends XppStroke {
  XppStrokeTool tool = XppStrokeTool.HIGHLIGHTER;
  List<XppStrokePoint>? points;
  Color? color;

  EditingTool? editingTool;
  XppStrokeHighlight(
      {this.points,
      this.color,
      String? capStyle,
      String? fill,
      String? style,
      String? audioTs,
      String? audioFn})
      : super(
            points: points,
            color: color,
            tool: XppStrokeTool.HIGHLIGHTER,
            editingTool: EditingTool.HIGHLIGHT,
            capStyle: capStyle,
            fill: fill,
            style: style,
            audioTs: audioTs,
            audioFn: audioFn);

  @override
  XppStroke newStroke({Color? color, List<XppStrokePoint>? points}) {
    return XppStrokeHighlight(points: points, color: color);
  }

  @override
  XppStroke clone() {
    return XppStrokeHighlight(
      color: color,
      points: points!.map((p) => p.clone()).toList(),
      capStyle: capStyle,
      fill: fill,
      style: style,
      audioTs: audioTs,
      audioFn: audioFn,
    );
  }
}

class XppStrokePainter extends CustomPainter {
  @required
  final List<XppStrokePoint>? points;
  @required
  final Color? color;
  @required
  final Offset? topLeft;
  @required
  final bool? smoothPressure;

  XppStrokePainter({
    this.points,
    this.color,
    this.topLeft,
    this.smoothPressure,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points!.isEmpty) return;
    if (points!.length == 1) {
      var paint = Paint()
        ..color = color!
        ..strokeWidth = points![0].width ?? 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var path = Path();
      Offset offset = points![0].offset;
      path.moveTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
      path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
      canvas.drawPath(path, paint);
    }
    if (smoothPressure!) {
      for (int i = 1; i < points!.length; i++) {
        var paint = Paint()
          ..color = color!
          ..strokeWidth = points![i].width ?? 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        var path = Path();
        path.moveTo(points![i - 1].offset.dx - topLeft!.dx,
            points![i - 1].offset.dy - topLeft!.dy);
        Offset offset = points![i].offset;
        path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
        canvas.drawPath(path, paint);
      }
    } else {
      double width = 0;

      var path = Path();
      path.moveTo(points![0].offset.dx - topLeft!.dx,
          points![0].offset.dy - topLeft!.dy);
      for (int i = 1; i < points!.length; i++) {
        Offset offset = points![i].offset;
        path.lineTo(offset.dx - topLeft!.dx, offset.dy - topLeft!.dy);
        width += points![i].width!;
      }
      width /= points!.length;
      var paint = Paint()
        ..color = color!
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; //!((oldDelegate is XppStrokePainter) && oldDelegate.points == points);
  }
}

enum XppStrokeTool {
  PEN,
  HIGHLIGHTER,
  ERASER,
}

class XppStrokePoint {
  double? x;
  double? y;
  double? width;

  XppStrokePoint({this.x, this.y, this.width});

  Offset get offset => Offset(x!, y!);

  XppStrokePoint clone() => XppStrokePoint(x: x, y: y, width: width);
}
