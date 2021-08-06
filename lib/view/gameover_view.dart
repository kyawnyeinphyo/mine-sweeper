import 'package:flutter/material.dart';
import 'package:mine_sweeper/game_board/game_controller.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:provider/provider.dart';

class GameOverView extends StatelessWidget {
  final GameController controller;

  const GameOverView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.85),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Game Over',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  controller.gameState = GameState.unBoard;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Restart',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  controller.gameState = GameState.unBoard;
                  context.read<GameStateProvider>()
                    ..toggleShowHomeScreen()
                    ..toggleStartGame();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Back To Home',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
