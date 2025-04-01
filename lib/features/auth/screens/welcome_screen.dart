import 'package:flutter/material.dart';
import 'package:slice_quest/features/auth/screens/auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Slice Quest",
              style: TextStyle(fontFamily: "Pizzaman", fontSize: 50),
            ),
            Image.asset('assets/images/pizza.png', height: 500),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return AuthScreen(true);
                    }));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontFamily: 'Pizzaman', fontSize: 20),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AuthScreen(false);
                  }));
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontFamily: 'Pizzaman', fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
