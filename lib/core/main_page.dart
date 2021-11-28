import 'package:f_poker/modules/game_page.dart';
import 'package:f_poker/modules/splash_page.dart';
import 'package:f_poker/providers/app_provider.dart';
import 'package:f_poker/utils/services/networking.dart';
import 'package:f_poker/widgets/data_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static final route = 'main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  IO.Socket? _socket;
  List<dynamic>? _games;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final headers = await Api.getHeaders;

      final socket = IO.io(
        '${kReleaseMode ? 'https' : 'http'}://${dotenv.env['API_URL']}',
        IO.OptionBuilder()
            .setExtraHeaders(headers)
            .setTransports(['websocket']).build(),
      );

      socket.onConnect((_) {
        socket.emit('get_games', {});
      });

      socket.on('get_games', (data) {
        setState(() {
          _games = data;
        });
      });

      socket.onDisconnect((_) async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Notice'),
              content: const Text('Disconnected'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    // TODO: fix

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });

      socket.connect();

      setState(() {
        _socket = socket;
      });
    });
  }

  @override
  void dispose() {
    _socket?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Row(
        children: [
          Visibility(visible: large, child: const LeftPanel()),
          Visibility(visible: large, child: const VerticalDivider(width: 0)),
          Expanded(child: RightPanel(games: _games)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New game'),
        onPressed: () async {
          // TODO: fix, extract

          final ans = await showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();

              return AlertDialog(
                title: const Text('New game'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Name your game room:'),
                    TextFormField(controller: controller),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Create game'),
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                    },
                  ),
                ],
              );
            },
          );

          if (ans is String) {
            _socket?.emit('create_game', {'name': ans});

            // Navigator.of(context).pushNamed(GamePage.route);
          }
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
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                Provider.of<AppProvider>(context).user?.username ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextButton(
                child: const Text('Settings'),
                onPressed: () {
                  // TODO: fix

                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.vertical(
                        top: const Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Settings',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              ListTile(
                                title: const Text('Info'),
                                onTap: () {
                                  showLicensePage(context: context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
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
    required this.games,
  }) : super(key: key);

  final List<dynamic>? games;

  @override
  Widget build(BuildContext context) {
    final length = games?.length ?? 0;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Games',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (length == 0)
          const DataErrorWidget(message: 'No games were found')
        else
          ListView.separated(
            shrinkWrap: true,
            itemCount: length,
            padding: const EdgeInsets.only(bottom: 128),
            separatorBuilder: (context, index) {
              return const Divider(height: 0, indent: 64);
            },
            itemBuilder: (context, index) {
              final game = games?[index];

              return InkWell(
                child: ListTile(
                  title: Text(game['name']),
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
