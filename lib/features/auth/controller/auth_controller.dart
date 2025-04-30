import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/repository/auth_repository.dart';
import 'package:slice_quest/models/user.dart';
import 'package:slice_quest/utils.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) {
  return null;
});
// });
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.read(authRepositoryProvider), ref: ref));

class AuthController extends StateNotifier<bool> {
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  final AuthRepository _authRepository;
  final Ref _ref;

  Future<void> signUpWithEmail(BuildContext context, String email,
      String password, String username) async {
    final user =
        await _authRepository.signUpWithEmail(email, password, username);
    user.fold((l) => showSnackBar(context, l.errorMessage), (usermodel) {
      _ref.read(currentUserProvider.notifier).update((state) => usermodel);
    });
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    final user = await _authRepository.signInWithEmail(email, password);
    user.fold((l) => showSnackBar(context, l.errorMessage), (usermodel) {
      _ref.read(currentUserProvider.notifier).state = usermodel;
    });
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.errorMessage), (usermodel) {
      _ref.read(currentUserProvider.notifier).state = usermodel;
    });
  }

  Future<void> signOut(BuildContext context) async {
    await _authRepository.signOut();
    _ref.read(currentUserProvider.notifier).state = null;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> getUserViaEmail(String email) async {
    final user = await _authRepository.getUserDataViaEmail(email);
    print('Hello $user');

    _ref.read(currentUserProvider.notifier).state = user;
  }

  Future<bool> isUsername(String name) {
    var isUser = _authRepository.isUsername(name);
    return isUser;
  }
}
