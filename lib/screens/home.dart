import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:retro_radar/screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Display name', style: TextStyle(fontSize: 35)),
            SizedBox(height: 20.0),
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://robohash.org/mail@ashallendesign.co.uk',
              ),
              radius: 65.0,
            ),
            SizedBox(height: 80),
            SignInButton(
              Buttons.Google,
              text: 'Sign out',
              onPressed:
                  () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}


// 15.40 minuty hihi