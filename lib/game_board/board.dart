import 'dart:ui' as UI;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mine_sweeper/game_board/game_controller.dart';
import 'package:mine_sweeper/game_board/util.dart';
import 'package:provider/provider.dart';

class Cell {
  bool isBomb;
  int nearBomb;
  bool checked;
  bool flag;

  Cell({
    required this.isBomb,
    this.nearBomb = 0,
    this.checked = false,
    this.flag = false,
  });
}

class Board extends StatefulWidget {
  final int row;
  final int column;
  final int totalBomb;
  final int diffuser;
  final int durationInMinute;
  final GameController controller;

  Board({
    Key? key,
    required this.row,
    required this.column,
    required this.totalBomb,
    required this.diffuser,
    this.durationInMinute = 0,
    required this.controller,
  })  : assert(row * column > totalBomb),
        super(key: key) {
    _restart();
  }

  void _restart() {
    controller.initState(
      row: row,
      column: column,
      diffuser: diffuser,
      totalBomb: totalBomb,
      duration: durationInMinute,
    );
  }

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _transformCtrl = TransformationController();

  /// To access the interactive viewer position
  final _key = GlobalKey();

  /// Start Position of interactive viewer

  @override
  void initState() {
    super.initState();
  }

  /// When the board tapUp
  void _onTapUp(TapUpDetails details) {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final offset =
        details.globalPosition - renderBox.localToGlobal(Offset.zero);
    final scenePoint = _transformCtrl.toScene(offset);

    int n = calculatePosition(
      scenePoint,
      widget.row,
      widget.column,
    );

    widget.controller.onCellTap(n);
  }

  double get boardWidth => ((cellSide + gap) * widget.column);

  double get boardHeight => ((cellSide + gap) * widget.row);

  @override
  void dispose() {
    _transformCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>.value(
      value: widget.controller,
      child: FutureBuilder<UI.Image>(
        future: loadImage('asset/grass40x40.png'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                /// Set the board to center of screen
                void _centerScreen({required Size viewportSize}) {
                  Matrix4 _start = Matrix4.identity()
                    ..translate(
                      viewportSize.width / 2 - boardWidth / 2,
                      viewportSize.height / 2 - boardHeight / 2,
                    );

                  _transformCtrl.value = _start;
                }

                _centerScreen(
                    viewportSize: Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ));

                return GestureDetector(
                  onTapUp: _onTapUp,
                  behavior: HitTestBehavior.opaque,
                  child: InteractiveViewer(
                    key: _key,
                    transformationController: _transformCtrl,
                    minScale: 0.1,
                    boundaryMargin: EdgeInsets.symmetric(
                      horizontal: boardWidth * 2,
                      vertical: boardHeight * 2,
                    ),
                    child: Consumer<GameController>(
                      builder: (context, notifier, _) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: _BoardPainter(
                              grassImage: snapshot.data!,
                              col: widget.column,
                              row: widget.row,
                              currentCell: notifier.currentCell,
                              board: notifier.stateBoard),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final int col;
  final int row;
  final int currentCell;
  final List<Cell> board;
  final UI.Image grassImage;

  _BoardPainter({
    required this.col,
    required this.row,
    required this.currentCell,
    required this.board,
    required this.grassImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellPaint = Paint();

    Rect rect(int n) {
      final offset = cellPosition(n, col);
      return Rect.fromLTWH(offset.dx, offset.dy, cellSide, cellSide);
    }

    final textStyle = UI.TextStyle(fontSize: 20);

    for (int n = 0; n < (row * col); n++) {
      if (board[n].isBomb && board[n].checked) {
        canvas.drawRect(rect(n), cellPaint..color = Colors.red);
      } else if (board[n].checked) {
        canvas.drawRect(rect(n), cellPaint..color = Colors.orange);
      } else if (board[n].flag) {
        canvas.drawRect(rect(n), cellPaint..color = Colors.blue);
      } else {
        canvas.drawImage(grassImage, cellPosition(n, col), Paint());
      }

      if (!board[n].isBomb && board[n].nearBomb != 0 && board[n].checked) {
        final paragraph = buildParagraph(
          board[n].nearBomb.toString(),
          textStyle: textStyle,
        );

        canvas.drawParagraph(
          paragraph,
          rect(n).center,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter old) => true;
}
