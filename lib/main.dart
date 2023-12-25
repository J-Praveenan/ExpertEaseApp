import 'package:expert_ease/Pages/onBoardingScreen.dart';
import 'package:expert_ease/Pages/video_uploading_page.dart';
import 'package:expert_ease/firebase_options.dart';
import 'package:expert_ease/services/auth/auth_gate.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils.dart';
import 'package:video_player/video_player.dart';
import 'resources/save_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  VideoUploadingPage(),
    );
  }
}

// AuthGate(),