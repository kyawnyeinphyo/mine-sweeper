import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:mine_sweeper/game_board/util.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:mine_sweeper/view/game_view.dart';
import 'package:mine_sweeper/view/gameinfo_entry_view.dart';
import 'package:mine_sweeper/view/home_view.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameStateProvider>(
        builder: (context, provider, child) {
          if (provider.showHomeScreen) {
            return HomeView();
          }

          if (!provider.startGame) {
            return GameInfoEntryView();
          } else {
            return GameView();
          }
        },
      ),
    );
  }
}
