import 'package:flutter/material.dart';
import 'package:mine_sweeper/provider/game_state_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('___build : home view____');
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Mine Sweeper',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () =>
                    context.read<GameStateProvider>().toggleShowHomeScreen(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Get Source Code',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
              FlutterLogo(size: 40),
            ],
          ),
        ),
      ),
    );
  }
}
