import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/profile/repository/profile_repository.dart';
import 'package:slice_quest/utils.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) => ProfileController(
        profileRepository: ref.read(profileRepositoryProvider), ref: ref));

class ProfileController extends StateNotifier<bool> {
  ProfileController(
      {required ProfileRepository profileRepository, required Ref ref})
      : _profileRepository = profileRepository,
        _ref = ref,
        super(false);
  final ProfileRepository _profileRepository;
  final Ref _ref;

  Future<void> uploadProfileImage(
      BuildContext context, File image, String userID) async {
    final user = await _profileRepository.uploadProfileImage(image, userID);

    user.fold((l) => showSnackBar(context, l.errorMessage),
        (user) => _ref.read(currentUserProvider.notifier).state = user);
  }
}
