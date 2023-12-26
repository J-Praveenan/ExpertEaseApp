import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], 
       body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's Find Your Tutor Here..",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // Add more styles as needed
              ),
            ),
            SizedBox(height: 20), // Adjust the spacing between text and animation
            Lottie.network(
              'https://lottie.host/c0a98149-039e-43e2-ba00-dcdc26c28ce1/7zeJPGbLJq.json',
            
            ),
          ],
        ),
      ),
    );
  }
}
