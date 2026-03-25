import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/pair_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/notes/presentation/note_detail_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/alarms/presentation/alarms_screen.dart';
import '../../features/games/presentation/games_lobby_screen.dart';
import '../../features/watch/presentation/watch_lobby_screen.dart';
import '../../features/location/presentation/location_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/pair',
      builder: (context, state) => const PairScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/notes/:id',
      builder: (context, state) => NoteDetailScreen(noteId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      path: '/alarms',
      builder: (context, state) => const AlarmsScreen(),
    ),
    GoRoute(
      path: '/games',
      builder: (context, state) => const GamesLobbyScreen(),
    ),
    GoRoute(
      path: '/watch',
      builder: (context, state) => const WatchLobbyScreen(),
    ),
    GoRoute(
      path: '/location',
      builder: (context, state) => const LocationScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
