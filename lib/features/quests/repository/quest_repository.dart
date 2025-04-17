import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:slice_quest/error_handle.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:slice_quest/models/user.dart';
import 'package:slice_quest/providers/firebase_providers.dart';
import 'package:slice_quest/typedef.dart';

typedef EitherID<T> = Future<Either<ErrorHandle, T>>;
typedef EitherEmpty<T> = Future<Either<ErrorHandle, T>>;

final questRepositoryProvider = Provider((ref) {
  return QuestRepository(ref.read(firestoreProvider));
});

class QuestRepository {
  QuestRepository(FirebaseFirestore firestore) : _firestore = firestore;
  final FirebaseFirestore _firestore;

  Future<List<QuestModel>> getQuestData() async {
    List<QuestModel> questData = [];
    await _firestore.collection('Quests').get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        questData.add(QuestModel.fromMap(docSnapshot.data()));
      }
    });

    return questData;
  }

  EitherUser<UserModel> addActiveQuest(String questID, String userID) async {
    try {
      UserModel user = await _firestore
          .collection('Users')
          .doc(userID)
          .snapshots()
          .map((user) => UserModel.fromMap(user.data() as Map<String, dynamic>))
          .first;

      await _firestore
          .collection('Users')
          .doc(userID)
          .update({'activeQuest': questID});

      return right(UserModel(
          email: user.email,
          username: user.username,
          uid: user.uid,
          profileImage: user.profileImage,
          completedQuests: user.completedQuests,
          xp: user.xp,
          activeQuest: questID));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }

  EitherUser<UserModel> removeActiveQuest(String userID) async {
    try {
      UserModel user = await _firestore
          .collection('Users')
          .doc(userID)
          .snapshots()
          .map((user) => UserModel.fromMap(user.data() as Map<String, dynamic>))
          .first;

      await _firestore
          .collection('Users')
          .doc(userID)
          .update({'activeQuest': ''});
      return right(UserModel(
          email: user.email,
          username: user.username,
          uid: user.uid,
          profileImage: user.profileImage,
          completedQuests: user.completedQuests,
          xp: user.xp,
          activeQuest: ''));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }
}
