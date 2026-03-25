import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Wait for the animation (min 1.5s as per prompt)
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        // Animated heartbeat pulse
        child: const Icon(
          Icons.favorite,
          color: AppColors.primary,
          size: 80,
        ).animate(onPlay: (controller) => controller.repeat())
         .scaleXY(begin: 1.0, end: 1.2, duration: 800.ms, curve: Curves.easeInOut)
         .then()
         .scaleXY(begin: 1.2, end: 1.0, duration: 800.ms, curve: Curves.easeInOut),
      ),
    );
  }
}
