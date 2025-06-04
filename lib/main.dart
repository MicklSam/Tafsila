import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'utils/user_data.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/measurements_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/camera.dart';
import 'screens/settings_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/about_screen.dart';
import 'screens/help_screen.dart';
import 'screens/suggestions_screen.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tafsila',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B68EE)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/camera':
            (context) => CameraScreen(
              camera: cameras.first,
              userHeight: UserData.userHeight ?? 170.0,
              userWeight: UserData.userWeight ?? 70.0,
            ),
        '/measurements': (context) => const MeasurementsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsScreen(),
        '/about': (context) => const AboutScreen(),
        '/help': (context) => const HelpScreen(),
        '/suggestions': (context) => const SuggestionsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}
