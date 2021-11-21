import 'package:f_poker/modules/game_page.dart';
import 'package:f_poker/modules/splash_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static final route = 'main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Row(
        children: [
          Visibility(visible: large, child: const LeftPanel()),
          Visibility(visible: large, child: const VerticalDivider(width: 0)),
          Expanded(child: const RightPanel()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New game'),
        onPressed: () {
          // TODO: fix

          Navigator.of(context).pushNamed(GamePage.route);
        },
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
      child: Material(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Profile',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: const CircleAvatar(maxRadius: 64),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextButton(
                child: const Text('Settings'),
                onPressed: () {
                  // TODO: fix
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextButton(
                child: const Text('Logout'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                  overlayColor: MaterialStateProperty.all(
                    Colors.red.withAlpha(16),
                  ),
                ),
                onPressed: () {
                  // TODO: fix

                  Navigator.of(context).pushReplacementNamed(SplashPage.route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Games',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListView.separated(
          itemCount: 60,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 128),
          separatorBuilder: (context, index) {
            return const Divider(height: 0, indent: 64);
          },
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                title: Text('Game $index'),
                leading: const Icon(Icons.gamepad),
                trailing: TextButton(
                  child: const Text('Join'),
                  onPressed: () {
                    // TODO: fix
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
