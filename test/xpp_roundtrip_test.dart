import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:xournalpp/layer_contents/XppImage.dart';
import 'package:xournalpp/layer_contents/XppStroke.dart';
import 'package:xournalpp/layer_contents/XppTexImage.dart';
import 'package:xournalpp/layer_contents/XppText.dart';
import 'package:xournalpp/src/XppBackground.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

void main() {
  group('XppBackground round-trip', () {
    test('dotted background serializes style="dotted"', () {
      final bg = XppBackgroundSolidDot(
          size: XppPageSize(width: 100, height: 100), color: Colors.white);
      final xml = bg.toXmlElement();
      expect(xml.getAttribute('type'), 'solid');
      expect(xml.getAttribute('style'), 'dotted');
    });

    test('background image preserves attach domain', () {
      final bg = XppBackgroundImage(
          filename: 'background.png', domain: XppBackgroundImageDomain.ATTACH);
      final xml = bg.toXmlElement();
      expect(xml.getAttribute('type'), 'pixmap');
      expect(xml.getAttribute('domain'), 'attach');
      expect(xml.getAttribute('filename'), 'background.png');
    });
  });

  group('XppLayer round-trip', () {
    test('named layer serializes name attribute', () {
      final layer = XppLayer.empty()..name = 'Layer One';
      final xml = layer.toXmlElement();
      expect(xml.getAttribute('name'), 'Layer One');
    });

    test('unnamed layer omits name attribute', () {
      final layer = XppLayer.empty();
      final xml = layer.toXmlElement();
      expect(xml.getAttribute('name'), isNull);
    });
  });

  group('XppStroke round-trip', () {
    test('preserves capStyle, fill, style and audio attributes', () {
      final stroke = XppStrokePen(
          color: Colors.black,
          points: [
            XppStrokePoint(x: 0, y: 0, width: 1.41),
            XppStrokePoint(x: 10, y: 10, width: 1.41),
          ],
          capStyle: 'round',
          fill: '0',
          style: 'solid',
          audioTs: '1234567890',
          audioFn: 'audio.ogg');
      final xml = stroke.toXmlElement();
      expect(xml.getAttribute('tool'), 'pen');
      expect(xml.getAttribute('capStyle'), 'round');
      expect(xml.getAttribute('fill'), '0');
      expect(xml.getAttribute('style'), 'solid');
      expect(xml.getAttribute('ts'), '1234567890');
      expect(xml.getAttribute('fn'), 'audio.ogg');
    });

    test('eraser stroke serializes tool="eraser"', () {
      final stroke = XppStrokeWhiteout(
          color: Colors.white,
          points: [XppStrokePoint(x: 0, y: 0, width: 5)]);
      final xml = stroke.toXmlElement();
      expect(xml.getAttribute('tool'), 'eraser');
    });
  });

  group('XppText round-trip', () {
    test('escapes XML entities in text body', () {
      final text = XppText(
          text: 'Hello & world <tag>',
          size: 12,
          fontFamily: 'Sans',
          color: Colors.black,
          offset: Offset(0, 0));
      final xml = text.toXmlElement();
      final body = xml.children.whereType<XmlText>().first.value;
      expect(body, 'Hello &amp; world &lt;tag&gt;');
    });

    test('uses default font family when null', () {
      final text = XppText(
          text: 'x',
          size: 12,
          fontFamily: null,
          color: Colors.black,
          offset: Offset(0, 0));
      final xml = text.toXmlElement();
      expect(xml.getAttribute('font'), 'Sans');
    });

    test('preserves rotation attribute', () {
      final text = XppText(
          text: 'x',
          size: 12,
          fontFamily: 'Sans',
          color: Colors.black,
          offset: Offset(0, 0),
          rotation: 0.5);
      final xml = text.toXmlElement();
      expect(xml.getAttribute('rotation'), isNotNull);
    });
  });

  group('XppContent geometry', () {
    test('stroke translate moves all points', () {
      final stroke = XppStrokePen(color: Colors.black, points: [
        XppStrokePoint(x: 0, y: 0, width: 1),
        XppStrokePoint(x: 10, y: 10, width: 1),
      ]);
      stroke.translate(Offset(5, -3));
      expect(stroke.points![0].offset, Offset(5, -3));
      expect(stroke.points![1].offset, Offset(15, 7));
    });

    test('stroke getBounds returns correct bounding box', () {
      final stroke = XppStrokePen(color: Colors.black, points: [
        XppStrokePoint(x: 5, y: 10, width: 1),
        XppStrokePoint(x: 15, y: 2, width: 1),
      ]);
      expect(stroke.getBounds(), Rect.fromLTRB(5, 2, 15, 10));
    });

    test('image translate moves corners', () {
      final img = XppImage(
          data: Uint8List(0),
          topLeft: Offset(0, 0),
          bottomRight: Offset(100, 50));
      img.translate(Offset(10, 20));
      expect(img.topLeft, Offset(10, 20));
      expect(img.bottomRight, Offset(110, 70));
    });

    test('text scale changes size and offset relative to anchor', () {
      final text = XppText(
          text: 'Hi',
          size: 20,
          fontFamily: 'Sans',
          color: Colors.black,
          offset: Offset(10, 10));
      text.applyScaleDelta(2, anchor: Offset(0, 0));
      expect(text.size, 40);
      expect(text.offset, Offset(20, 20));
    });

    test('teximage rotation is stored', () {
      final tex = XppTexImage(
          text: 'x^2', color: Colors.black, topLeft: Offset(0, 0));
      tex.applyRotationDelta(0.5);
      expect(tex.rotation, 0.5);
    });
  });
}
