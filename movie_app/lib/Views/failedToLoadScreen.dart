import 'package:flutter/material.dart';

class FailedToLoadScreen extends StatelessWidget {

  FailedToLoadScreen(this.errorMessage, this.retryFunction);
  final String errorMessage;
  final dynamic retryFunction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[300],
                )
              ),
              GestureDetector(
                onTap: () {retryFunction();},
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[400]
                    )
                  ),
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}
