import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/home/directory_screen.dart';
import 'screens/home/my_listings_screen.dart';
import 'screens/home/map_view_screen.dart';
import 'screens/home/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
    debugPrint('App will run in demo mode. To enable Firebase:');
    debugPrint('1. Create project at firebase.google.com');
    debugPrint('2. Download google-services.json (Android) and GoogleService-Info.plist (iOS)');
    debugPrint('3. Place them in android/app/ and ios/Runner/ respectively');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final themeMode = ref.watch(flutterThemeModeProvider);
    return MaterialApp(
      title: 'Kigali City Services',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routes: {
        '/signup': (_) => const SignupScreen(),
      },
      home: auth.when(
        data: (user) {
          if (user == null) return const LoginScreen();
          if (!user.emailVerified) return const VerifyEmailScreen();
          return const HomeShell();
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Firebase Setup Required'),
                Text('Error: $e'),
                const SizedBox(height: 16),
                const Text('To enable the app:'),
                const Text('1. Go to firebase.google.com'),
                const Text('2. Create a new project'),
                const Text('3. Enable Authentication & Firestore'),
                const Text('4. Download config files'),
                const Text('5. Place in android/app/ and ios/Runner/'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _current = 0;
  final _screens = const [
    DirectoryScreen(),
    MyListingsScreen(),
    MapViewScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Directory'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Listings'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
