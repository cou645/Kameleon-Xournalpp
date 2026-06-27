import 'dart:async';
import 'dart:convert';
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

  @required
  final Uint8List? data;

  XppImage({this.data, this.topLeft, this.bottomRight});

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
  XppPageContentWidget render() {
    return XppPageContentWidget(
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
      tool: EditingTool.IMAGE,
    );
  }

  @override
  Offset? getOffset() => topLeft;

  @override
  XmlElement toXmlElement() => XmlElement(XmlName('image'), [
        XmlAttribute(XmlName('left'), topLeft!.dx.toString()),
        XmlAttribute(XmlName('right'), bottomRight!.dx.toString()),
        XmlAttribute(XmlName('top'), topLeft!.dy.toString()),
        XmlAttribute(XmlName('bottom'), bottomRight!.dy.toString()),
      ], [
        XmlText(base64Encode(data!))
      ]);

  @override
  bool inRegion({Offset? topLeft, Offset? bottomRight}) {
    // TODO: implement inRegion
    throw UnimplementedError();
  }

  @override
  bool shouldSelectAt({Offset? coordinates, EditingTool? tool}) {
    // TODO: implement shouldSelectAt
    throw UnimplementedError();
  }
}
