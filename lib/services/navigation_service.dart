import 'package:flutter/material.dart';

import '../view/chat/chat_page.dart';
import '../view/home/home_page.dart';
import '../view/login/login_page.dart';
import '../view/signup/register_page.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    '/login': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    '/register': (context) => const RegisterPage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState!.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState!.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
