import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100], 
       body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chat With Your Tutor..",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // Add more styles as needed
              ),
            ),
            SizedBox(height: 20), // Adjust the spacing between text and animation
            Lottie.network(
              'https://lottie.host/9b433f90-256f-4990-8121-70701e1dc306/JD8FbisLqZ.json',
            ),
          ],
        ),
      ),
    );
  }
}