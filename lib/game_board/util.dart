import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double cellSide = 40;
double gap = 1;

Offset cellPosition(int n, int c) {
  /// 0 1 2
  /// 3 4 5
  /// if n=3, n%col==0

  double left = (cellSide + gap) * (n % c);

  /// 0 1 2
  /// 3 4 5
  /// if n=4, n~/col==1
  double top = (cellSide + gap) * (n ~/ c);
  return Offset(left, top);
}

/// Return the cell position
/// if doesn't contain in any cell, return -1
int calculatePosition(Offset localPosition, int r, int c) {
  int x = localPosition.dx ~/ (cellSide + gap);
  int y = localPosition.dy ~/ (cellSide + gap);

  int estimate = x + (y * c);

  if (estimate >= r * c) return -1;

  Offset position = cellPosition(estimate, c);

  double l = position.dx;
  double t = position.dy;

  bool result = Rect.fromLTWH(l, t, cellSide, cellSide).contains(localPosition);

  return result ? estimate : -1;
}

UI.Paragraph buildParagraph(String text, {UI.TextStyle? textStyle}) {
  final builder = UI.ParagraphBuilder(
    UI.ParagraphStyle(
      textAlign: TextAlign.center,
      height: 0.5,
      textDirection: TextDirection.ltr,
    ),
  );

  if (textStyle != null) {
    builder.pushStyle(textStyle);
  }

  builder.addText(text);

  final paragraph = builder.build();
  paragraph.layout(UI.ParagraphConstraints(width: 1));
  return paragraph;
}

Future<UI.Image> loadImage(String asset) async {
  final ByteData data = await rootBundle.load(asset);
  final Completer<UI.Image> completer = Completer();
  UI.decodeImageFromList(
      Uint8List.view(data.buffer), (result) => completer.complete(result));

  return completer.future;
}
