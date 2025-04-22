import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slice_quest/error_handle.dart';
import 'package:slice_quest/providers/firebase_providers.dart';
import 'package:slice_quest/models/user.dart';
import 'package:slice_quest/typedef.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  const AuthRepository(
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  EitherUser<UserModel> signUpWithEmail(
      String email, String password, String username) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(
          email: email,
          username: username,
          uid: userCredential.user!.uid,
          profileImage: 'pizza_user_avatar',
          completedQuests: [],
          xp: 0,
          activeQuest: '',
          reviews: []);
      await _firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());
      return right(user);
    } on FirebaseAuthException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(
        ErrorHandle(error.toString()),
      );
    }
  }

  EitherUser<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = await getUserData(userCredential.user!.uid).first;

      return right(user);
    } on FirebaseAuthException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }

  EitherUser<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      final userCredential = await _auth.signInWithCredential(credential);

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
            email: userCredential.user!.email ?? '',
            username: userCredential.user!.displayName ?? '',
            uid: userCredential.user!.uid,
            profileImage: userCredential.user!.photoURL ?? 'pizza_user_avatar',
            completedQuests: [],
            xp: 0,
            activeQuest: '',
            reviews: []);
        await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      } else {
        user = await getUserData(userCredential.user!.uid).first;
      }
      return right(user);
    } on FirebaseAuthException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(ErrorHandle(error.toString()));
    }
  }

  void signInWithApple() {}

  Stream<UserModel> getUserData(String uid) {
    final user = _firestore
        .collection("Users")
        .doc(uid)
        .snapshots()
        .map((item) => UserModel.fromMap(item.data() as Map<String, dynamic>));

    return user;
  }

  Future<UserModel> getUserDataViaEmail(String email) async {
    final userStream = _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((item) => UserModel.fromDoc((item.docs.first)));

    final usermodel = await userStream.first;

    return usermodel;
  }

  Future<bool> isUsername(String name) async {
    final user = await _firestore
        .collection('Users')
        .where('username', isEqualTo: name)
        .get();

    return user.docs.isNotEmpty;
  }
}
