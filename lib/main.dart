import 'dart:ui' as UI;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mine_sweeper/game_board/game_controller.dart';
import 'package:mine_sweeper/game_board/mine_sweeper.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:mine_sweeper/view/game_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameStateProvider>(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        title: 'Mine Sweeper',
        home: GameScreen(),
        // home: Test(),
      ),
    );
  }
}

class Test extends StatelessWidget {
   Test({Key? key}) : super(key: key);

  final controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Board(
          row: 5, column: 5, totalBomb: 5, diffuser: 5, controller: controller),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rectPaint = Paint()..color = Colors.blue;

    canvas.drawRect(Rect.fromLTWH(0, 0, 100, 100), rectPaint);

    canvas.drawCircle(Rect.fromLTWH(0, 0, 100, 100).center, 10,
        rectPaint..color = Colors.red);
    //
    // canvas.drawParagraph(
    //   buildParagraph(
    //     'ABC',
    //     textStyle: UI.TextStyle(
    //       fontSize: 20,
    //       color: Colors.white,
    //     ),
    //   ),
    //   Rect.fromLTWH(0, 0, 100, 100).topLeft,
    // );

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'BOC',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);

    print(textPainter.width);
    print(textPainter.height);

    textPainter.paint(
      canvas,
      Rect.fromLTWH(0, 0, 100, 100).center -
          Offset(textPainter.width / 2, textPainter.height / 2),
    );

    canvas.drawParagraph(
      buildParagraph('A'),
      Rect.fromLTWH(0, 0, 100, 100).center - Offset(4, 8),
    );
  }

  UI.Paragraph buildParagraph(String text, {UI.TextStyle? textStyle}) {
    final builder = UI.ParagraphBuilder(
      UI.ParagraphStyle(
        textAlign: TextAlign.center,
        // height: 100,
        height: 3.5,
        textDirection: TextDirection.ltr,
      ),
    );

    if (textStyle != null) {
      builder.pushStyle(textStyle);
    }

    builder.addText(text);

    final paragraph = builder.build();
    paragraph.layout(
      UI.ParagraphConstraints(
        width: 100,
      ),
    );

    return paragraph;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
