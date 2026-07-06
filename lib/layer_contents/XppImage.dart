import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class XppImage extends XppContent {
  Offset? topLeft = Offset(0, 0);
  Offset? bottomRight = Offset(0, 0);

  /// Mobile-only rotation, in radians.
  double rotation;

  @required
  final Uint8List? data;

  XppImage(
      {this.data, this.topLeft, this.bottomRight, this.rotation = 0});

  static Future<XppImage> open({required Offset topLeft}) async {
    FilePickerCross picked =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);

    final bytes = picked.toUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w = frame.image.width.toDouble();
    final h = frame.image.height.toDouble();
    frame.image.dispose();
    codec.dispose();

    return XppImage(
        data: bytes,
        topLeft: topLeft,
        bottomRight: Offset(topLeft.dx + w, topLeft.dy + h));
  }

  @override
  Rect getBounds() {
    return Rect.fromLTRB(topLeft!.dx, topLeft!.dy, bottomRight!.dx,
        bottomRight!.dy);
  }

  @override
  XppPageContentWidget render() {
    return XppPageContentWidget(
      child: Transform.rotate(
        angle: rotation,
        alignment: Alignment.topLeft,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(),
            FadeInImage(
              image: MemoryImage(data!),
              placeholder: MemoryImage(kTransparentImage),
              width: bottomRight!.dx - topLeft!.dx,
              height: bottomRight!.dy - topLeft!.dy,
            )
          ],
        ),
      ),
      tool: EditingTool.IMAGE,
    );
  }

  @override
  Offset? getOffset() => topLeft;

  @override
  XmlElement toXmlElement() {
    final attrs = [
      XmlAttribute(XmlName('left'), topLeft!.dx.toString()),
      XmlAttribute(XmlName('right'), bottomRight!.dx.toString()),
      XmlAttribute(XmlName('top'), topLeft!.dy.toString()),
      XmlAttribute(XmlName('bottom'), bottomRight!.dy.toString()),
    ];
    if (rotation != 0) {
      attrs.add(XmlAttribute(
          XmlName('rotation'), (rotation * 180 / math.pi).toStringAsFixed(4)));
    }
    return XmlElement(XmlName('image'), attrs, [XmlText(base64Encode(data!))]);
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
    final a = anchor ?? topLeft!;
    topLeft = Offset(a.dx + (topLeft!.dx - a.dx) * scaleDelta,
        a.dy + (topLeft!.dy - a.dy) * scaleDelta);
    bottomRight = Offset(a.dx + (bottomRight!.dx - a.dx) * scaleDelta,
        a.dy + (bottomRight!.dy - a.dy) * scaleDelta);
  }

  @override
  void applyRotationDelta(double radians, {Offset? center}) {
    rotation += radians;
  }

  @override
  XppImage clone() {
    return XppImage(
      data: Uint8List.fromList(data!),
      topLeft: topLeft,
      bottomRight: bottomRight,
      rotation: rotation,
    );
  }
}
