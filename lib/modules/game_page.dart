import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  static final route = 'game';

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.green.shade700,
      appBar: AppBar(title: const Text('Game')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Material(
                        elevation: 5,
                        color: Colors.transparent,
                        child: Image.asset('assets/images/as.png'),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(2, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Material(
                      elevation: 5,
                      color: Colors.transparent,
                      child: Image.asset('assets/images/as.png'),
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   icon: const Icon(Icons.add),
      //   label: const Text('New game'),
      //   onPressed: () {
      //     // TODO: fix
      //   },
      // ),
    );
  }
}
