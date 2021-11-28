import 'package:f_poker/utils/functions/show_default_snack_bar.dart';
import 'package:f_poker/utils/services/networking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  static final route = 'game';

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  IO.Socket? _socket;

  Future<bool> _leave() async {
    final ans = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: const Text('Do you wish to leave the game room?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return ans == true;
  }

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

      if (socket.connected) {
        socket.emit('game_info', {});
      }

      // socket.onConnect((_) {
      //   socket.emit('game_info', {});

      //   showDefaultSnackBar(context: context, content: 'Connected');
      // });

      socket.on('game_info', (data) {
        print(data);
      });

      socket.onDisconnect((_) async {
        showDefaultSnackBar(context: context, content: 'Disconnected');
      });

      socket.connect();

      setState(() {
        _socket = socket;
      });
    });
  }

  @override
  void dispose() {
    _socket?.off('game_info');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _leave,
      child: Scaffold(
        backgroundColor: Colors.green.shade700,
        appBar: AppBar(
          title: const Text('Game'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () async {
              if (await _leave()) Navigator.of(context).pop();
            },
          ),
        ),
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
      ),
    );
  }
}
