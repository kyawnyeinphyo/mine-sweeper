import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/game_board/board.dart';
import 'package:mine_sweeper/game_board/enum.dart';

enum GameState {
  unBoard,
  resume,
  pause,
  gameOver,
  win,
}

class GameController extends ChangeNotifier {
  StreamController<int> _cleanQtyCtrl = StreamController();
  StreamController<int> _flagQtyCtrl = StreamController();
  StreamController<int> _diffuseQtyCtrl = StreamController();
  StreamController<Duration> _remainTimeCtrl = StreamController();
  StreamController<GameState> _gameStateCtrl = StreamController();

  @override
  void dispose() {
    _cleanQtyCtrl.close();
    _flagQtyCtrl.close();
    _diffuseQtyCtrl.close();
    _remainTimeCtrl.close();
    _gameStateCtrl.close();

    _timer?.cancel();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////////
  int _explodeQty = 0;

  int _cleanQty = 0;

  Stream<int> get cleanQtyStream => _cleanQtyCtrl.stream;

  int _flagQty = 0;

  Stream<int> get flagQtyStream => _flagQtyCtrl.stream;

  int _diffuseLeftQty = 0;

  Stream<int> get diffuseQtyStream => _diffuseQtyCtrl.stream;

  /////////////////////////////////////////////////////////////////////

  Duration? _remainTime;

  Stream<Duration> get remainTimeStream => _remainTimeCtrl.stream;

  late List<Cell> _stateBoard;

  List<Cell> get stateBoard => _stateBoard;

  int _currentCell = -1;

  int get currentCell => _currentCell;

  Timer? _timer;

  late int _row;
  late int _column;
  late int _total;
  late int _totalBomb;
  late int _diffuser;

  late Tool _tool;

  Tool get tool => _tool;

  set tool(Tool v) {
    _tool = v;
    notifyListeners();
  }

  int _durationInMin = 0;

  GameState _gameState = GameState.unBoard;

  GameState get gameState => _gameState;

  Stream<GameState> get gameStateStream => _gameStateCtrl.stream;

  set gameState(GameState v) {
    _gameState = v;
    _gameStateCtrl.sink.add(_gameState);

    switch (v) {
      case GameState.unBoard:
        initState(
          row: _row,
          column: _column,
          totalBomb: _totalBomb,
          duration: _durationInMin,
          diffuser: _diffuser,
        );

        notifyListeners();

        break;
      case GameState.resume:
        //resume the timer
        if (_timer != null) {
          _timer!.cancel();

          _timer = Timer.periodic(
            Duration(seconds: 1),
            _tickerCallback,
          );
        }
        break;
      case GameState.pause:
        //pause timer
        if (_timer != null) {
          _timer!.cancel();
        }
        break;
      case GameState.gameOver:
        break;
      case GameState.win:
        _timer?.cancel();
        break;
    }
  }

  void _checkGameOver() {
    _timer?.cancel();

    List<Cell> bombList = _stateBoard.where((e) => e.isBomb).toList();
    bombList.shuffle();
    _explode(bombList);
  }

  void _explode(List<Cell> bombList) {
    if (bombList.length == 0) return;
    bombList.removeLast().checked = true;
    _explodeQty++;

    if (_explodeQty == _totalBomb) {
      gameState = GameState.gameOver;
    } else {
      Future.delayed(Duration(milliseconds: 25)).then((value) {
        _explode(bombList);
        notifyListeners();
      });
    }
  }

  void _checkWinState() {
    if (_cleanQty == _total - _totalBomb) {
      Future.delayed(Duration(milliseconds: 200))
          .then((value) => gameState = GameState.win);
    }
  }

  /// Init State Must be called
  void initState({
    required int row,
    required int column,
    required int totalBomb,
    required int diffuser,
    required int duration,
  }) {
    this._row = row;
    this._column = column;

    this._total = row * _column;
    this._totalBomb = totalBomb;
    this._diffuser = diffuser;
    this._durationInMin = duration;

    this._tool = Tool.clean;

    _explodeQty = 0;
    _cleanQty = 0;
    _flagQty = _totalBomb;
    _diffuseLeftQty = _diffuser;

    _cleanQtyCtrl.sink.add(0);
    _flagQtyCtrl.sink.add(_totalBomb);
    _diffuseQtyCtrl.sink.add(_diffuser);

    _initBoard();
    _shuffleBoard();
    _calculateBomb();
    _initTimer();
  }

  /// n is the index of cell
  void onCellTap(int n) {
    if (n == -1 || _stateBoard[n].checked) return;

    switch (_tool) {
      case Tool.clean:

        ///Can't clean if flag
        if (_stateBoard[n].flag) return;

        if (_stateBoard[n].isBomb) {
          _checkGameOver();

          notifyListeners();
          return;
        }

        _stateBoard[n].checked = true;

        _cleanQtyCtrl.sink.add(++_cleanQty);

        _checkWinState();

        _checkNeighborHasBomb(n);

        /// change state
        notifyListeners();
        break;
      case Tool.flag:
        if (_stateBoard[n].flag) {
          _flagQtyCtrl.sink.add(++_flagQty);
        } else {
          if (_flagQty == 0) return;
          _flagQtyCtrl.sink.add(--_flagQty);
        }

        _stateBoard[n].flag = !_stateBoard[n].flag;

        /// change state
        notifyListeners();
        break;
      case Tool.diffuse:
        if (_diffuseLeftQty == 0) return;

        ///Can't diffuse if flag
        if (_stateBoard[n].flag) return;

        ///it doesn't matter a bomb or empty cell
        _stateBoard[n].checked = true;

        _diffuseQtyCtrl.sink.add(--_diffuseLeftQty);

        if (!_stateBoard[n].isBomb) {
          _cleanQtyCtrl.sink.add(++_cleanQty);
          _checkWinState();
        }

        /// change state
        notifyListeners();
        break;
    }
  }

  void _initTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    if (_durationInMin != 0) {
      _remainTime = Duration(minutes: _durationInMin);

      _timer = Timer.periodic(
        Duration(seconds: 1),
        _tickerCallback,
      );
    }
  }

  void _tickerCallback(timer) {
    _remainTime = _remainTime! - Duration(seconds: 1);

    _remainTimeCtrl.sink.add(_remainTime!);

    if (_remainTime!.inSeconds == 0) {
      _checkGameOver();
    }
  }

  void _initBoard() {
    _stateBoard = List<Cell>.generate(
      _total - _totalBomb,
      (index) => Cell(isBomb: false),
    );

    List<Cell> bomb = List<Cell>.generate(
      _totalBomb,
      (index) => Cell(isBomb: true),
    );

    _stateBoard.addAll(bomb);
  }

  void _shuffleBoard() {
    _stateBoard.shuffle();
  }

  void _calculateBomb() {
    for (int n = 0; n < _row * _column; n++) {
      bool isStart = n % _column == 0;
      bool isEnd = (n + 1) % _column == 0;

      if (_stateBoard[n].isBomb) continue;

      int bomb = 0;

      /// check left is bomb
      if (!isStart && _stateBoard[n - 1].isBomb) {
        bomb++;
      }

      /// check right is bomb
      if (!isEnd && _stateBoard[n + 1].isBomb) {
        bomb++;
      }

      /// check up is bomb
      if (n >= _column && _stateBoard[n - _column].isBomb) {
        bomb++;
      }

      /// check down is bomb
      if (n < _total - _column && _stateBoard[n + _column].isBomb) {
        bomb++;
      }

      /// check top-left is bomb
      if (!isStart && n >= _column && _stateBoard[n - (_column + 1)].isBomb) {
        bomb++;
      }

      /// check top-right is bomb
      if (!isEnd && n >= _column && _stateBoard[n - (_column - 1)].isBomb) {
        bomb++;
      }

      /// check bottom-left is bomb
      if (!isStart &&
          n < _total - _column &&
          _stateBoard[n + (_column - 1)].isBomb) {
        bomb++;
      }

      /// check bottom-right is bomb
      if (!isEnd &&
          n < _total - _column &&
          _stateBoard[n + (_column + 1)].isBomb) {
        bomb++;
      }

      _stateBoard[n].nearBomb = bomb;
    }
  }

  void _checkNeighborHasBomb(int n) {
    if (_stateBoard[n].nearBomb != 0) return;

    bool isStart = n % _column == 0;
    bool isEnd = (n + 1) % _column == 0;

    void check(int index, [bool condition = true]) {
      if (condition &&
          !_stateBoard[index].checked &&
          !_stateBoard[index].isBomb &&
          !_stateBoard[index].flag) {
        _cleanQtyCtrl.sink.add(++_cleanQty);
        _checkWinState();

        _stateBoard[index].checked = true;

        /// Delay the search
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          notifyListeners();
          _checkNeighborHasBomb(index);
        });
      }
    }

    /// check left is bomb
    check(n - 1, !isStart);

    /// check right is bomb
    check(n + 1, !isEnd);

    /// check up is bomb
    check(n - _column, n >= _column);

    /// check down is bomb
    check(n + _column, n < _total - _column);

    /// check top-left is bomb
    check(n - (_column + 1), !isStart && n >= _column);

    /// check top-right is bomb
    check(n - (_column - 1), !isEnd && n >= _column);

    /// check bottom-left is bomb
    check(n + (_column - 1), !isStart && n < _total - _column);

    /// check bottom-right is bomb
    check(n + (_column + 1), !isEnd && n < _total - _column);
  }
}
