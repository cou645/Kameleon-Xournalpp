import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class XppTexImage extends XppContent {
  Offset? topLeft = Offset(0, 0);

  /// TODO: proper implementation of bottom and right
  Offset? bottomRight = Offset(0, 0);

  /// Mobile-only visual scale and rotation.
  double scale;
  double rotation;

  @required
  final String? text;

  Color? color;

  XppTexImage(
      {this.text,
      this.topLeft,
      this.bottomRight,
      this.color,
      this.scale = 1,
      this.rotation = 0});

  static Future<XppTexImage> edit(
      {required BuildContext context,
      String text = 'x^2',
      Offset? topLeft,
      Color? color}) async {
    var laTeXController = TextEditingController(text: text);
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter LaTeX code'),
        content: TextField(
            controller: laTeXController = laTeXController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LaTeX code',
                helperText: 'No delimiter required')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Okay'))
        ],
      ),
    );
    if (result == false) throw (UnsupportedError('Aborted.'));
    return (XppTexImage(
        text: laTeXController.text, topLeft: topLeft, color: color));
  }

  static const double _baseFontSize = 18;

  @override
  Rect getBounds() {
    // Approximate size; LaTeX widgets measure themselves.
    final approxWidth = (text?.length ?? 1) * _baseFontSize * scale * 0.6;
    final approxHeight = _baseFontSize * scale * 1.4;
    return Rect.fromLTWH(topLeft!.dx, topLeft!.dy, approxWidth, approxHeight);
  }

  @override
  XppPageContentWidget render() {
    return XppPageContentWidget(
      child: Transform.rotate(
        angle: rotation,
        alignment: Alignment.topLeft,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topLeft,
          child: Math.tex(
            text ?? '',
            mathStyle: MathStyle.display,
            textStyle: TextStyle(color: color, fontSize: _baseFontSize),
            onErrorFallback: (err) => Text(
              text ?? '',
              style: TextStyle(
                  color: Colors.red, fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ),
      tool: EditingTool.LATEX,
    );
  }

  @override
  Offset? getOffset() => topLeft;

  @override
  XmlElement toXmlElement() {
    final attrs = [
      XmlAttribute(XmlName('text'), text!),
      XmlAttribute(XmlName('color'), color!.toHexTriplet()),
      XmlAttribute(XmlName('left'), topLeft!.dx.toString()),
      XmlAttribute(XmlName('right'), bottomRight?.dx.toString() ?? '0'),
      XmlAttribute(XmlName('top'), topLeft!.dy.toString()),
      XmlAttribute(XmlName('bottom'), bottomRight?.dy.toString() ?? '0'),
    ];
    if (scale != 1) {
      attrs.add(XmlAttribute(XmlName('xpp-scale'), scale.toStringAsFixed(4)));
    }
    if (rotation != 0) {
      attrs.add(XmlAttribute(
          XmlName('xpp-rotation'), (rotation * 180 / math.pi).toStringAsFixed(4)));
    }
    return XmlElement(XmlName('teximage'), attrs, [XmlText(XppText.encodeText(text!))]);
  }

  @override
  bool inRegion({Offset? topLeft, Offset? bottomRight}) {
    final region = Rect.fromLTRB(
        topLeft!.dx, topLeft.dy, bottomRight!.dx, bottomRight.dy);
    return region.contains(getBounds().topLeft) &&
        region.contains(getBounds().bottomRight);
  }

  @override
  bool shouldSelectAt({Offset? coordinates, EditingTool? tool}) {
    return getBounds().inflate(8).contains(coordinates!);
  }

  @override
  void translate(Offset delta) {
    topLeft = topLeft! + delta;
    bottomRight = bottomRight! + delta;
  }

  @override
  void applyScaleDelta(double scaleDelta, {Offset? anchor}) {
    scale *= scaleDelta;
  }

  @override
  void applyRotationDelta(double radians, {Offset? center}) {
    rotation += radians;
  }

  @override
  XppTexImage clone() {
    return XppTexImage(
      text: text,
      color: color,
      topLeft: topLeft,
      bottomRight: bottomRight,
      scale: scale,
      rotation: rotation,
    );
  }
}
