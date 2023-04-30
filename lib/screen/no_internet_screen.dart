import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "packages/internet_handler/assets/no-internet.png",
          width: 400,
          height: 400,
        ),
      ),
    );
  }
}
