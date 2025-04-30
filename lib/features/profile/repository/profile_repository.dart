import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/constants/constants.dart';
import 'package:slice_quest/error_handle.dart';
import 'package:slice_quest/models/user.dart';
import 'package:slice_quest/providers/firebase_providers.dart';
import 'package:slice_quest/typedef.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

final profileRepositoryProvider = Provider((ref) {
  return ProfileRepository(
      ref.read(firestoreProvider), ref.read(storageProvider));
});

class ProfileRepository {
  ProfileRepository(FirebaseFirestore firestore, FirebaseStorage storage)
      : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  EitherUser<UserModel> uploadProfileImage(File image, String userID) async {
    try {
      UserModel user = await _firestore
          .collection('Users')
          .doc(userID)
          .snapshots()
          .map((item) => UserModel.fromDoc(item))
          .first;

      if (user.profileImage != Constants.defaultProfilePic) {
        final oldImage = _storage.ref().child(userID);
        oldImage.delete();
      }
      final uploadTask = _storage.ref(userID).putFile(image);
      final taskSnapshot = await uploadTask;

      final url = await taskSnapshot.ref.getDownloadURL();

      await _firestore
          .collection('Users')
          .doc(userID)
          .update({'profileImage': url});

      return right(UserModel(
          email: user.email,
          username: user.username,
          uid: user.uid,
          profileImage: url,
          completedQuests: user.completedQuests,
          xp: user.xp,
          activeQuest: user.activeQuest,
          reviews: user.reviews));
    } on FirebaseException catch (error, stack) {
      print(stack);
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }
}
