import 'package:demo_chatting_app/services/auth_services.dart';
import 'package:demo_chatting_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils.dart';

void main() async {
  await setup();
  runApp(MainApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registServices();
}

class MainApp extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  late AuthServices authServices;
  late NavigationService navigationService;

  MainApp({super.key}) {
    navigationService = getIt.get<NavigationService>();
    authServices = getIt.get<AuthServices>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      title: 'Demo Chatting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      routes: navigationService.routes,
      initialRoute: authServices.user != null ? '/home' : '/login',
    );
  }
}
