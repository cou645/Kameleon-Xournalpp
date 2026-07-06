import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/layer_contents/XppImage.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/layer_contents/XppTexImage.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class PointerListener extends StatefulWidget {
  @required
  final Function(XppContent?)? onNewContent;
  @required
  final Function({int? device, PointerDeviceKind? kind})? onDeviceChange;
  @required
  final Widget? child;
  @required
  final Map<PointerDeviceKind?, EditingTool> toolData;
  @required
  final Matrix4? translationMatrix;
  @required
  final double? strokeWidth;
  @required
  final Color? color;
  @required
  final Function({Offset? coordinates, double? radius})? filterEraser;
  @required
  final Function()? removeLastContent;
  final Function(Offset coordinates)? onSelectContent;

  const PointerListener(
      {Key? key,
      this.onNewContent,
      this.child,
      this.toolData = const {},
      this.translationMatrix,
      this.onDeviceChange,
      this.strokeWidth,
      this.color,
      this.filterEraser,
      this.removeLastContent,
      this.onSelectContent})
      : super(key: key);

  @override
  PointerListenerState createState() => PointerListenerState();
}

class PointerListenerState extends State<PointerListener> {
  late bool drawingEnabled;

  List<XppStrokePoint> points = [];

  late XppStrokeTool tool;

  Offset? _shapeStart;

  Map<int, DateTime> pointerTimestamps = Map();

  bool poppedContentForCurrentPointer = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        widget.onDeviceChange!(device: event.device, kind: event.kind);
      },
      opaque: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: (data) {
          if (_detectTwoFingerGesture(data)) return;
          widget.onDeviceChange!(device: data.device, kind: data.kind);
          if (!drawingEnabled) return;
          if (isPen(data) || isHighlighter(data)) {
            double? width = (data.pressure == 0
                ? widget.strokeWidth
                : data.pressure * widget.strokeWidth!);

            //A highlighter should not change its width
            if (isHighlighter(data)) width = widget.strokeWidth;
            points.add(XppStrokePoint(
                x: data.localPosition.dx,
                y: data.localPosition.dy,
                width: width));
            setState(() {});
          }

          if (isEraser(data))
            widget.filterEraser!(
                coordinates:
                    Offset(data.localPosition.dx, data.localPosition.dy),
                radius: widget.strokeWidth);

          if (isWhiteout(data)) {
            // Real whiteout: erase underlying strokes instead of drawing white ink.
            widget.filterEraser!(
                coordinates:
                    Offset(data.localPosition.dx, data.localPosition.dy),
                radius: (widget.strokeWidth ?? 5) * 3);
          }

          if (isShape(data) && _shapeStart != null) {
            points = _buildShapePoints(
              start: _shapeStart!,
              end: data.localPosition,
              tool: widget.toolData[data.kind]!,
            );
            setState(() {});
          }
        },
        onPointerDown: (data) {
          if (_detectTwoFingerGesture(data, shouldPop: true)) return;

          setState(() {
            tool = getToolFromPointer(data);
          });
          widget.onDeviceChange!(device: data.device, kind: data.kind);
          if (isLaTeX(data)) {
            XppTexImage.edit(
                    context: context,
                    topLeft: data.localPosition,
                    color: widget.color)
                .then((value) {
              widget.onNewContent!(value);
            });
          }
          if (isText(data)) {
            XppText.edit(
              context: context,
              topLeft: data.localPosition,
              color: widget.color,
              size: widget.strokeWidth! * 3,
            ).then((value) {
              if (value != null) widget.onNewContent!(value);
            });
          }
          if (isImage(data)) {
            XppImage.open(topLeft: data.localPosition)
                .then((value) => widget.onNewContent!(value))
                .catchError((_) {});
          }
          if (isSelect(data)) {
            widget.onSelectContent?.call(data.localPosition);
            return;
          }
          if (isShape(data)) {
            _shapeStart = data.localPosition;
          }
        },
        onPointerUp: (data) {
          if (isSelect(data)) {
            setState(() {
              points.clear();
            });
            return;
          }
          if (!poppedContentForCurrentPointer) saveStroke(tool);
          poppedContentForCurrentPointer = false;
          setState(() {
            points.clear();
            _shapeStart = null;
          });
        },
        onPointerCancel: (data) {
          setState(() {
            points.clear();
            poppedContentForCurrentPointer = false;
          });
        },
        onPointerSignal: (data) {
          setState(() {
            tool = getToolFromPointer(data);
          });
          widget.onDeviceChange!(device: data.device, kind: data.kind);
        },
        child: Stack(
          children: [
            widget.child!,
            if (points.length > 0)
              CustomPaint(
                /*size: Size(
        bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),*/
                foregroundPainter: XppStrokePainter(
                    points: points,
                    color: widget.color,
                    topLeft: Offset(0, 0),
                    smoothPressure: tool == XppStrokeTool.PEN),
              ),
          ],
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();

  void clearPoints() {
    setState(() {
      points.clear();
    });
  }

  void saveStroke(XppStrokeTool tool) {
    if (points.isNotEmpty) {
      XppStroke stroke = XppStroke.byTool(
          tool: tool, points: List.from(points), color: widget.color);
      widget.onNewContent!(stroke);
    }
  }

  bool isPen(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
            widget.toolData[data.kind] == EditingTool.STYLUS) ||
        (!widget.toolData.keys.contains(data.kind) &&
            data.kind == PointerDeviceKind.stylus);
  }

  bool isHighlighter(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.HIGHLIGHT);
  }

  bool isEraser(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
            widget.toolData[data.kind] == EditingTool.ERASER) ||
        (!widget.toolData.keys.contains(data.kind) &&
            data.kind == PointerDeviceKind.invertedStylus);
  }

  bool isText(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.TEXT);
  }

  bool isLaTeX(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.LATEX);
  }

  bool isImage(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.IMAGE);
  }

  bool isWhiteout(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.WHITEOUT);
  }

  bool isSelect(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.SELECT);
  }

  bool isLine(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.LINE);
  }

  bool isRectangle(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.RECTANGLE);
  }

  bool isEllipse(PointerEvent data) {
    return (widget.toolData.keys.contains(data.kind) &&
        widget.toolData[data.kind] == EditingTool.ELLIPSE);
  }

  bool isShape(PointerEvent data) {
    return isLine(data) || isRectangle(data) || isEllipse(data);
  }

  List<XppStrokePoint> _buildShapePoints(
      {required Offset start, required Offset end, required EditingTool tool}) {
    final width = widget.strokeWidth ?? 2.5;
    switch (tool) {
      case EditingTool.LINE:
        return [
          XppStrokePoint(x: start.dx, y: start.dy, width: width),
          XppStrokePoint(x: end.dx, y: end.dy, width: width),
        ];
      case EditingTool.RECTANGLE:
        return [
          XppStrokePoint(x: start.dx, y: start.dy, width: width),
          XppStrokePoint(x: end.dx, y: start.dy, width: width),
          XppStrokePoint(x: end.dx, y: end.dy, width: width),
          XppStrokePoint(x: start.dx, y: end.dy, width: width),
          XppStrokePoint(x: start.dx, y: start.dy, width: width),
        ];
      case EditingTool.ELLIPSE:
        final points = <XppStrokePoint>[];
        final center = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
        final rx = (end.dx - start.dx).abs() / 2;
        final ry = (end.dy - start.dy).abs() / 2;
        const steps = 36;
        for (int i = 0; i <= steps; i++) {
          final theta = 2 * math.pi * i / steps;
          points.add(XppStrokePoint(
            x: center.dx + rx * math.cos(theta),
            y: center.dy + ry * math.sin(theta),
            width: width,
          ));
        }
        return points;
      default:
        return [];
    }
  }

  XppStrokeTool getToolFromPointer(PointerEvent data) {
    XppStrokeTool tool = XppStrokeTool.PEN;
    if (isHighlighter(data))
      tool = XppStrokeTool.HIGHLIGHTER;
    else if (isEraser(data)) tool = XppStrokeTool.ERASER;
    else if (isWhiteout(data)) tool = XppStrokeTool.ERASER;
    return tool;
  }

  bool _detectTwoFingerGesture(PointerEvent data, {bool shouldPop = false}) {
    // detecting two-finger gestures
    final timestamp = DateTime.now();
    bool foundCloseOffset = false;
    pointerTimestamps.remove(data.device);
    pointerTimestamps.forEach((key, value) {
      if (value.difference(timestamp).inMilliseconds.abs() < 100) {
        foundCloseOffset = true;
      }
    });
    if (shouldPop && foundCloseOffset && !poppedContentForCurrentPointer) {
      poppedContentForCurrentPointer = true;
    }
    pointerTimestamps[data.device] = timestamp;
    return foundCloseOffset;
  }
}
