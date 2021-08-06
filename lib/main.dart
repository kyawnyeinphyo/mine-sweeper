import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnconstrainedBox(
        child: InteractiveViewer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.blue, width: 100),
            ),
            width: 2000,
            height: 5000,
          ),
        ),
      ),
    );
  }
}
