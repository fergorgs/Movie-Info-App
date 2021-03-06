import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// LOADING SCREEN
// Apenas um widget com uma animação para indicar carregamento
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        )
      )
    );
  }
}
