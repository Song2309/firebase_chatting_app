import 'package:demo_chatting_app/models/user_profile.dart';
import 'package:demo_chatting_app/services/auth_services.dart';
import 'package:demo_chatting_app/services/database_service.dart';
import 'package:demo_chatting_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/alert_service.dart';
import '../../widgets/chat_tile.dart';
import '../chat/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.instance;

  late AuthServices _authService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthServices>();
    _navigationService = getIt.get<NavigationService>();
    _alertService = getIt.get<AlertService>();
    _databaseService = getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _alertService.showToast(
                    text: 'Successfully logout', icon: Icons.check);
                _navigationService.pushReplacementNamed('/login');
              }
            },
            color: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _builUI(),
    );
  }

  Widget _builUI() {
    final kWidth = MediaQuery.sizeOf(context).width;
    final kHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: _chatList(),
    ));
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Unable to load data'),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ChatTile(
                  userProfile: user,
                  onTap: () async {
                    final chatExists = await _databaseService.checkChatExists(
                        _authService.user!.uid, user.uid!);
                    if (!chatExists) {
                      await _databaseService.createNewChat(
                          _authService.user!.uid, user.uid!);
                    }
                    _navigationService
                        .push(MaterialPageRoute(builder: (context) {
                      return ChatPage(chatUser: user);
                    }));
                  },
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
