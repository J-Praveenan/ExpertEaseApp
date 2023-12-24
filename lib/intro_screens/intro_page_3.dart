import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100], 
       body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Show Your Teaching Talents..",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // Add more styles as needed
              ),
            ),
            SizedBox(height: 20), // Adjust the spacing between text and animation
            Lottie.network(
              'https://lottie.host/fea7ffa2-cc74-4446-b06d-0aee5a04b94e/5JUmERWQQs.json',
            ),
          ],
        ),
      ),
    );
  }
}