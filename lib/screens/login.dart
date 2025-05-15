import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:retro_radar/blocs/auth_bloc.dart';
import 'package:retro_radar/screens/home.dart';
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
                    children: [SignInButton(Buttons.Google, onPressed: _login)],
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
