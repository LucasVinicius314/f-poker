import 'package:f_poker/core/main_page.dart';
import 'package:f_poker/model/user.dart';
import 'package:f_poker/providers/app_provider.dart';
import 'package:f_poker/widgets/email_text_form_field.dart';
import 'package:f_poker/widgets/password_text_form_field.dart';
import 'package:f_poker/widgets/username_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static final route = 'register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _back() {
    Navigator.of(context).pop();
  }

  Future<void> _createAccount() async {
    try {
      final user = await User.register(
        context: context,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      Provider.of<AppProvider>(context, listen: false).user = user;

      Navigator.of(context).pushReplacementNamed(MainPage.route);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notice'),
            content: const Text('Invalid credentials'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  // TODO: add validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('F Poker')),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Create account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: UsernameTextFormField(
                        focusNode: _usernameFocusNode,
                        controller: _usernameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EmailTextFormField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PasswordTextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ButtonBar(
                        overflowButtonSpacing: 8,
                        layoutBehavior: ButtonBarLayoutBehavior.padded,
                        children: [
                          TextButton(
                            onPressed: _back,
                            child: const Text('Go back'),
                          ),
                          ElevatedButton(
                            onPressed: _createAccount,
                            child: const Text(
                              'Create account',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
