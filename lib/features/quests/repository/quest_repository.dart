import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:slice_quest/error_handle.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:slice_quest/models/review.dart';
import 'package:slice_quest/models/user.dart';
import 'package:slice_quest/providers/firebase_providers.dart';
import 'package:slice_quest/typedef.dart';
import 'package:uuid/uuid.dart';

typedef EitherID<T> = Future<Either<ErrorHandle, T>>;
typedef EitherEmpty<T> = Future<Either<ErrorHandle, T>>;

final questRepositoryProvider = Provider((ref) {
  return QuestRepository(
      ref.read(firestoreProvider), ref.read(storageProvider));
});

class QuestRepository {
  QuestRepository(FirebaseFirestore firestore, FirebaseStorage storage)
      : _firestore = firestore,
        _storage = storage;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

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
          activeQuest: questID,
          reviews: user.reviews));
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
          activeQuest: '',
          reviews: user.reviews));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }

  EitherUser completeQuest(String userID, QuestModel quest, File image,
      String username, String comment, double rating) async {
    try {
      String? imageLink;

      final uploadTask = _storage.ref(const Uuid().v4()).putFile(image);
      final taskSnasphot = await uploadTask;

      imageLink = await taskSnasphot.ref.getDownloadURL();
      ReviewModel review = ReviewModel(
          image: imageLink,
          rating: rating,
          comment: comment,
          username: username,
          questID: quest.uuid);
      UserModel user = await _firestore
          .collection('Users')
          .doc(userID)
          .snapshots()
          .map((user) => UserModel.fromMap(user.data() as Map<String, dynamic>))
          .first;
      await _firestore
          .collection('Review')
          .doc(review.uuid)
          .set(review.toMap());

      await _firestore.collection('Users').doc(userID).update({
        "completedQuests": FieldValue.arrayUnion(['${quest.uuid}'])
      });
      await _firestore.collection('Users').doc(user.uid).update({
        "reviews": FieldValue.arrayUnion(["${review.uuid}"])
      });
      await _firestore
          .collection('Users')
          .doc(userID)
          .update({'xp': user.xp + quest.xp});
      user.completedQuests.add(quest.uuid);
      user.reviews.add(review.uuid);

      return right(UserModel(
          email: user.email,
          username: user.username,
          uid: user.uid,
          profileImage: user.profileImage,
          completedQuests: user.completedQuests,
          xp: user.xp + quest.xp,
          activeQuest: quest.uuid == user.activeQuest ? '' : user.activeQuest,
          reviews: user.reviews));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }
}
