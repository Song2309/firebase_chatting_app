import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chatting_app/models/message.dart';
import 'package:demo_chatting_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/chat.dart';
import '../models/user_profile.dart';
import '../utils.dart';

class DatabaseService {
  final GetIt getIt = GetIt.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late AuthServices _authServices;
  CollectionReference? _userCollection;
  CollectionReference? _chatsCollection;
  DatabaseService() {
    _authServices = getIt.get<AuthServices>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCollection = _firestore.collection('users').withConverter<UserProfile>(
        fromFirestore: (snapshot, _) => UserProfile.fromJson(snapshot.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson());
    _chatsCollection = _firestore.collection('chats').withConverter<Chat>(
        fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
        toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _userCollection
        ?.where('uid', isNotEqualTo: _authServices.user?.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    await docRef.update({
      'messages': FieldValue.arrayUnion([
        message.toJson(),
      ]),
    });
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
