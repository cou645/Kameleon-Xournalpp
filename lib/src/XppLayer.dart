import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

import 'XppPageContentWidget.dart';

class XppLayer {
  XppLayer({this.content, this.name});

  List<XppContent?>? content;

  /// Optional layer name (Xournal++ file attribute).
  String? name;

  static XppLayer empty() => XppLayer(content: []);

  XmlElement toXmlElement() {
    final attributes = <XmlAttribute>[];
    if (name != null && name!.isNotEmpty) {
      attributes.add(XmlAttribute(XmlName('name'), name!));
    }
    return XmlElement(
        XmlName('layer'), attributes, content!.map((e) => e!.toXmlElement()));
  }
}

abstract class XppContent {
  Offset? getOffset();

  /// Axis-aligned bounding box in page coordinates.
  Rect getBounds();

  XppPageContentWidget render();

  XmlElement toXmlElement();

  /// Create an independent copy of this content object.
  XppContent clone();

  bool shouldSelectAt({Offset? coordinates, EditingTool? tool});

  bool inRegion({Offset? topLeft, Offset? bottomRight});

  /// return [true] in case it should be fully deleted
  XppContentEraseData eraseWhere({Offset? coordinates, double? radius}) =>
      XppContentEraseData();

  /// Move the object by [delta] in page coordinates.
  void translate(Offset delta);

  /// Scale the object around [anchor] by the relative factor [scaleDelta].
  void applyScaleDelta(double scaleDelta, {Offset? anchor});

  /// Rotate the object around [center] by [radians].
  void applyRotationDelta(double radians, {Offset? center});
}

class XppContentEraseData {
  final bool affected;
  final bool delete;
  final List<XppContent> newContent;

  XppContentEraseData(
      {this.affected = false, this.delete = false, this.newContent = const []});
}
