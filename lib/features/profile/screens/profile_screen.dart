import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slice_quest/error_handle.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/profile/controller/profile_controller.dart';
import 'package:slice_quest/features/quests/controller/quest_controller.dart';
import 'package:slice_quest/utils.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImage;
  void _takeImageViaCamera() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 400);
      if (image == null) {
        return;
      }
      await ref.read(profileControllerProvider.notifier).uploadProfileImage(
          context, _profileImage!, ref.read(currentUserProvider)!.uid);
      setState(() {
        _profileImage = File(image.path);
      });
    } catch (errorMessage) {
      showSnackBar(context, errorMessage.toString());
    }
  }

  void _selectImageViaGallery() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300);

      if (image == null) {
        return;
      }
      await ref.read(profileControllerProvider.notifier).uploadProfileImage(
          context, _profileImage!, ref.read(currentUserProvider)!.uid);
      setState(() {
        _profileImage = File(image.path);
      });
    } catch (errorMessage) {
      showSnackBar(context, errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestCompleted =
        ((ref.read(currentUserProvider)!.completedQuests.length) /
            (ref.read(questDataProvider).length) *
            100);
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: SizedBox(
          height: 450,
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                    onTap: _takeImageViaCamera,
                    onDoubleTap: _selectImageViaGallery,
                    child: CircleAvatar(
                        maxRadius: 75,
                        backgroundImage: _profileImage != null
                            ? Image.file(_profileImage!).image
                            : Image.network(
                                    ref.read(currentUserProvider)!.profileImage)
                                .image)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  ref.read(currentUserProvider)!.username,
                  style: const TextStyle(fontFamily: 'Pizzaman', fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/xp_icon.png',
                      color: ThemeData().colorScheme.primary,
                      height: 45,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(ref.read(currentUserProvider)!.xp.toString(),
                        style: const TextStyle(
                            fontFamily: 'Pizzaman', fontSize: 20)),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Quest Completion Status',
                  style: TextStyle(fontFamily: 'Pizzaman', fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('$totalQuestCompleted%',
                    style:
                        const TextStyle(fontFamily: 'Pizzaman', fontSize: 20))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
