import 'package:flutter/material.dart';
import 'package:mine_sweeper/model/game_info.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:mine_sweeper/widget/label.dart';
import 'package:mine_sweeper/widget/number_field.dart';
import 'package:provider/provider.dart';

class GameInfoEntryView extends StatefulWidget {
  const GameInfoEntryView({Key? key}) : super(key: key);

  @override
  _GameInfoEntryViewState createState() => _GameInfoEntryViewState();
}

class _GameInfoEntryViewState extends State<GameInfoEntryView> {
  late TextEditingController _rowCtrl,
      _colCtrl,
      _bombCtrl,
      _diffuserCtr,
      _durationCtrl;

  void _onStartGame() {
    if (_validate()) {
      final newInfo = GameInfo();

      newInfo.row = int.parse(_rowCtrl.text);
      newInfo.column = int.parse(_colCtrl.text);
      newInfo.totalBomb = int.parse(_bombCtrl.text);
      newInfo.diffuser = int.parse(_diffuserCtr.text);
      newInfo.durationInMinute = int.parse(_durationCtrl.text);

      final provider = context.read<GameStateProvider>();
      provider.gameInfo = newInfo;
      provider.toggleStartGame();
    }
  }

  bool _validate() {
    if (_rowCtrl.text.isEmpty ||
        _colCtrl.text.isEmpty ||
        _bombCtrl.text.isEmpty ||
        _diffuserCtr.text.isEmpty ||
        _durationCtrl.text.isEmpty) return false;

    int row = int.parse(_rowCtrl.text);
    int col = int.parse(_colCtrl.text);
    int bomb = int.parse(_bombCtrl.text);

    if (row * col <= bomb) {
      _bombCtrl.clear();
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    final info = context.read<GameStateProvider>().gameInfo;

    _rowCtrl = TextEditingController(text: info.row.toString());
    _colCtrl = TextEditingController(text: info.column.toString());
    _bombCtrl = TextEditingController(text: info.totalBomb.toString());
    _diffuserCtr = TextEditingController(text: info.diffuser.toString());
    _durationCtrl =
        TextEditingController(text: info.durationInMinute.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<GameStateProvider>().toggleShowHomeScreen();
        return Future.value(false);
      },
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      sizeWrap(child: Label('Dimension')),
                      Spacer(),
                      NumberField(controller: _rowCtrl),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'x',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      NumberField(controller: _colCtrl),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      sizeWrap(child: Label('Total Bomb')),
                      Spacer(),
                      NumberField(controller: _bombCtrl),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      sizeWrap(child: Label('Diffuser')),
                      Spacer(),
                      NumberField(controller: _diffuserCtr),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      sizeWrap(child: Label('Duration (In Minute)')),
                      Spacer(),
                      NumberField(controller: _durationCtrl),
                    ],
                  ),
                  SizedBox(height: 60),
                  SizedBox(
                    width: 500,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onStartGame,
                      child: Text(
                        'Start Game',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: 500,
                    height: 48,
                    child: TextButton.icon(
                      onPressed: () => context
                          .read<GameStateProvider>()
                          .toggleShowHomeScreen(),
                      icon: Icon(Icons.arrow_back),
                      label: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sizeWrap({Widget? child}) => SizedBox(
        width: 100,
        child: child,
      );
}
