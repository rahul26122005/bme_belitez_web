import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/department_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/events_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';

import 'utils/theme.dart';
import 'utils/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BelitezApp());
}

class BelitezApp extends StatelessWidget {
  const BelitezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "B'ELITEZ 2K26",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.data,

      initialRoute: '/',

      onGenerateRoute: (settings) {
        final path = settings.name ?? '/';

        // ======================================================
        // HOME / DEPARTMENT
        // ======================================================

        if (path == '/') {
          return _page(
            const DepartmentScreen(),
          );
        }

        // ======================================================
        // REGISTRATION HOME
        // ======================================================

        if (path == '/register-home') {
          return _page(
            const SymposiumHomeScreen(),
          );
        }

        // ======================================================
        // EVENTS
        // ======================================================

        if (path == '/events') {
          return _page(
            const EventsScreen(),
          );
        }

        // ======================================================
        // REGISTRATION
        // ======================================================

        if (path == '/register') {
          return _page(
            const RegisterScreen(),
          );
        }

        // ======================================================
        // ADMIN LOGIN
        // ======================================================

        if (path == '/admin/login') {
          return _page(
            const AdminLoginScreen(),
          );
        }

        // ======================================================
        // ADMIN DASHBOARD
        // ======================================================

        if (path == '/admin') {
          return _page(
            const AdminDashboardScreen(),
          );
        }

        // ======================================================
        // EVENT DETAILS
        // ======================================================

        if (path.startsWith('/event/')) {
          return _page(
            EventDetailScreen(
              slug: path.substring('/event/'.length),
            ),
          );
        }

        // ======================================================
        // DEFAULT ROUTE
        // ======================================================

        return _page(
          const DepartmentScreen(),
        );
      },
    );
  }

  MaterialPageRoute _page(Widget child) {
    return MaterialPageRoute(
      builder: (_) => child,
    );
  }
}

