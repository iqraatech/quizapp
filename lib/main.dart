import 'package:flashcard_neon_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'providers/flashcard_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart'; // Make sure this path matches your file structure

void main() async {
  // 1. Ensure Flutter binding layer is ready
  // (Crucial so that your splash screen can draw immediately)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize your local Hive database storage layer
  await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FlashcardProvider()..loadFlashcards(),
        ),
      ],
      child: const FlashcardNeonApp(),
    ),
  );
}

class FlashcardNeonApp extends StatelessWidget {
  const FlashcardNeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CORE.MEM Flashcards',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(), // 🌟 Sets splash screen as the root entry point
    );
  }
}