import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/src/HexColor.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPageContentWidget.dart';
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';

class XppText extends XppContent {
  @required
  final Color? color;
  double? size;
  String? text;
  @required
  Offset? offset;
  @required
  final String? fontFamily;

  /// Mobile-only rotation, in radians.
  double rotation;

  XppText(
      {this.size,
      this.offset,
      this.fontFamily,
      this.color,
      this.text,
      this.rotation = 0});

  @override
  Offset? getOffset() => offset;

  Size _measureText() {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text ?? '',
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: size ?? 16,
          fontFamily: fontFamily,
        ),
      ),
    );
    painter.layout();
    return painter.size;
  }

  @override
  Rect getBounds() {
    final size = _measureText();
    return Rect.fromLTWH(offset!.dx, offset!.dy, size.width, size.height);
  }

  @override
  XppPageContentWidget render() {
    return XppPageContentWidget(
      child: Transform.rotate(
        angle: rotation,
        alignment: Alignment.topLeft,
        child: Text(
          text ?? '',
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: size ?? 16,
            fontFamily: fontFamily,
          ),
        ),
      ),
      tool: EditingTool.TEXT,
    );
  }

  static Future<XppText?> edit({
    required BuildContext context,
    required Offset topLeft,
    required Color? color,
    required double? size,
    String? initialText,
  }) async {
    final ctrl = TextEditingController(text: initialText);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add text'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Enter text…'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('OK')),
        ],
      ),
    );
    if (result == null || result.isEmpty) return null;
    return XppText(
      offset: topLeft,
      color: color,
      size: size,
      text: result,
      // Default font matches desktop Xournal++'s default Sans font.
      fontFamily: 'Sans',
    );
  }

  @override
  XmlElement toXmlElement() {
    final attrs = [
      XmlAttribute(XmlName('font'), fontFamily ?? 'Sans'),
      XmlAttribute(XmlName('size'), size.toString()),
      XmlAttribute(XmlName('x'), offset!.dx.toString()),
      XmlAttribute(XmlName('y'), offset!.dy.toString()),
      XmlAttribute(XmlName('color'), color!.toHexTriplet()),
    ];
    if (rotation != 0) {
      attrs.add(XmlAttribute(
          XmlName('rotation'), (rotation * 180 / math.pi).toStringAsFixed(4)));
    }
    return XmlElement(XmlName('text'), attrs, [XmlText(encodeText(text!))]);
  }

  static String encodeText(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
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
    offset = offset! + delta;
  }

  @override
  void applyScaleDelta(double scaleDelta, {Offset? anchor}) {
    final a = anchor ?? offset!;
    offset = Offset(a.dx + (offset!.dx - a.dx) * scaleDelta,
        a.dy + (offset!.dy - a.dy) * scaleDelta);
    size = (size ?? 16) * scaleDelta;
  }

  @override
  void applyRotationDelta(double radians, {Offset? center}) {
    rotation += radians;
  }

  @override
  XppText clone() {
    return XppText(
      text: text,
      size: size,
      fontFamily: fontFamily,
      color: color,
      offset: offset,
      rotation: rotation,
    );
  }
}

class RichTextField extends StatefulWidget {
  final Function(String text)? onChange;

  final String? text;

  final double? size;

  final Color? color;

  const RichTextField(
      {Key? key, this.onChange, this.text, this.size, this.color})
      : super(key: key);

  @override
  _RichTextFieldState createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  //ZefyrController _controller;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  bool active = false;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    //_controller = ZefyrController(
    //   NotusDocument.fromDelta(NotusMarkdownCodec().decode(widget.text)));
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return XppPageContentWidget(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
    /*return ZefyrEditor(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      mode: active ? ZefyrMode.edit : ZefyrMode.select,
    );*/
  }

  /*@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/
}
