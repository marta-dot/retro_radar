import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:retro_radar/blocs/auth_bloc.dart';
import 'package:retro_radar/screens/login.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder(
      stream: authBloc.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            //zalogowany
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.displayName ?? 'Brak',
                      style: TextStyle(fontSize: 35),
                    ),
                    SizedBox(height: 20.0),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoURL ??
                            'https://robohash.org/mail@ashallendesign.co.uk',
                      ),
                      radius: 65.0,
                    ),
                    SizedBox(height: 80),
                    SignInButton(
                      Buttons.Google,
                      text: 'Sign out',
                      onPressed: () => authBloc.logout(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const LoginScreen();
          }
        } else {
          // Pokazujemy loader podczas sprawdzania stanu logowania
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
