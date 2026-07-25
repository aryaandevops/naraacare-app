import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/signup/signup_screen.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/onboarding/onboarding_intro_screen.dart';

void main() {
  runApp(const NaraaCareApp());
}

class NaraaCareApp extends StatelessWidget {
  const NaraaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naraa Care',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/onboarding': (context) => const OnboardingIntroScreen(),
        // VerificationScreen removed — it needs `email`, so it's
        // navigated to directly (see signup_screen.dart) instead of by route name
        // Onboarding steps 2-5 (Gender/Name, Height, Weight, Age/Activity, Body Type,
        // Avatar Ready, Saved Details) are also navigated to directly since they pass
        // data forward via constructors, not route names.
      },
    );
  }
}