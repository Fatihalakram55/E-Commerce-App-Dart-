import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center
      (child: Column(
          children: [
            Image.network(
              width: 100,
              height: 100,
              'https://cdn-icons-png.flaticon.com/512/866/866229.png'
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      )
    );
  }
}