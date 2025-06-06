import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:retro_radar/blocs/auth_bloc.dart';
import 'package:retro_radar/screens/home.dart';
import 'package:retro_radar/screens/map.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    await Provider.of<AuthBloc>(context, listen: false).loginGoogle();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder(
      stream: authBloc.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return const HomeScreen();
          } else {
            if (isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/Retro.png',
                        width: 150, // Dopasuj rozmiar według potrzeb
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      SignInButton(Buttons.Google, onPressed: _login),
                      const SizedBox(height: 20),
                      TextButton(
                        child: Text("Skip"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
