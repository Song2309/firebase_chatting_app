import 'package:demo_chatting_app/firebase_options.dart';
import 'package:demo_chatting_app/services/alert_service.dart';
import 'package:demo_chatting_app/services/database_service.dart';
import 'package:demo_chatting_app/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'services/auth_services.dart';
import 'services/media_service.dart';
import 'services/storage_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthServices>(
    AuthServices(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
  getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold('', (id, uid) => '$id$uid');
  return chatID;
}
