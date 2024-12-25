import 'package:demo_chatting_app/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(36)),
      child: ListTile(
        onTap: () {
          onTap();
        },
        dense: false,
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            userProfile.pfpURL!,
          ),
        ),
        title: Text(userProfile.name!),
      ),
    );
  }
}
