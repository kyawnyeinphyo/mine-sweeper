import 'package:flutter/material.dart';
import 'package:mine_sweeper/model/game_info.dart';

class GameStateProvider extends ChangeNotifier {
  bool _showHomeScreen = true;

  bool get showHomeScreen => _showHomeScreen;

  void toggleShowHomeScreen() {
    _showHomeScreen = !_showHomeScreen;
    notifyListeners();
  }

  bool _startGame = false;

  bool get startGame => _startGame;

  void toggleStartGame() {
    _startGame = !_startGame;
    notifyListeners();
  }

  GameInfo _gameInfo = GameInfo.defaultSetting();

  GameInfo get gameInfo => _gameInfo;

  set gameInfo(GameInfo gameInfo) {
    _gameInfo = gameInfo;
    notifyListeners();
  }
}
