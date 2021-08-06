import 'package:flutter/material.dart';
import 'package:mine_sweeper/game_board/enum.dart';
import 'package:mine_sweeper/game_board/game_controller.dart';
import 'package:mine_sweeper/game_board/mine_sweeper.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:mine_sweeper/view/gameover_view.dart';
import 'package:mine_sweeper/view/pause_view.dart';
import 'package:mine_sweeper/view/winning_view.dart';
import 'package:provider/provider.dart';

class GameView extends StatelessWidget {
  final GameController controller = GameController();

  GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('___build : game view____');
    return WillPopScope(
      onWillPop: () {
        if (controller.gameState == GameState.gameOver) {
          context.read<GameStateProvider>()
            ..toggleShowHomeScreen()
            ..toggleStartGame();
          return Future.value(false);
        }
        return Future.value(false);
      },
      child: Container(
        child: Stack(
          children: [
            Board(
              controller: controller,
              column: context.read<GameStateProvider>().gameInfo.column,
              row: context.read<GameStateProvider>().gameInfo.row,
              totalBomb: context.read<GameStateProvider>().gameInfo.totalBomb,
              diffuser: context.read<GameStateProvider>().gameInfo.diffuser,
              durationInMinute:
                  context.read<GameStateProvider>().gameInfo.durationInMinute,
            ),
            Positioned(
              right: 24,
              top: MediaQuery.of(context).size.height * 0.24,
              child: Column(
                children: [
                  StreamBuilder<int>(
                    initialData: 0,
                    stream: controller.cleanQtyStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () {
                          controller.tool = Tool.clean;
                        },
                        child: Text('Clean : ${snapshot.data}'),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  StreamBuilder<int>(
                    initialData: 0,
                    stream: controller.flagQtyStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () {
                          controller.tool = Tool.flag;
                        },
                        child: Text('Flag : ${snapshot.data}'),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  StreamBuilder<int>(
                    initialData:
                        context.read<GameStateProvider>().gameInfo.diffuser,
                    stream: controller.diffuseQtyStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () {
                          controller.tool = Tool.diffuse;
                        },
                        child: Text('Diffuse : ${snapshot.data}'),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                left: 24,
                top: 32,
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      controller.gameState = GameState.pause;
                    },
                    color: Colors.white,
                    iconSize: 30,
                    icon: Icon(
                      Icons.pause,
                    ),
                  ),
                )),
            StreamBuilder<Duration>(
              stream: controller.remainTimeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    right: 24,
                    top: 32,
                    child: Container(
                      width: 100,
                      // color: Colors.red.withOpacity(0.2),
                      height: 60,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${snapshot.data!.inSeconds}s',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            StreamBuilder<GameState>(
              stream: controller.gameStateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!) {
                    case GameState.unBoard:
                      break;
                    case GameState.resume:
                      break;
                    case GameState.pause:
                      return PauseView(controller: controller);
                    case GameState.gameOver:
                      return GameOverView(controller: controller);
                    case GameState.win:
                      return WinningView(controller: controller);
                  }
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
