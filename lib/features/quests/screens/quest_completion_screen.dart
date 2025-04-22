import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/quests/controller/quest_controller.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:slice_quest/utils.dart';

class CompleteQuestScreen extends ConsumerStatefulWidget {
  const CompleteQuestScreen(this.quest, {super.key});
  final QuestModel quest;

  @override
  ConsumerState<CompleteQuestScreen> createState() =>
      _CompleteQuestScreenState();
}

class _CompleteQuestScreenState extends ConsumerState<CompleteQuestScreen> {
  bool _isSubmitting = false;
  File? _selectedimage;
  double _rating = 3;
  String? _review;
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  void _takePictureViaCamera() async {
    final imagePicker = ImagePicker();
    final image =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 800);
    if (image == null) {
      return;
    }
    setState(() {
      _selectedimage = File(image.path);
    });
  }

  void _selectPictureViaGallery() async {
    final imagePicker = ImagePicker();
    final image =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (image == null) {
      return;
    }
    setState(() {
      _selectedimage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _submit() async {
      String userID = ref.read(currentUserProvider)!.uid;
      String username = ref.read(currentUserProvider)!.username;
      try {
        setState(() {
          _isSubmitting = true;
        });
        await ref.read(questControllerProvider.notifier).completeQuest(context,
            userID, widget.quest, _selectedimage!, username, _review!, _rating);

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (error) {
        showSnackBar(context, error.toString());
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    Widget activeContent = _selectedimage == null
        ? GestureDetector(
            onTap: _takePictureViaCamera,
            onDoubleTap: _selectPictureViaGallery,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/pizza_camera_icon.png',
                height: 50,
              ),
              const Text('Tap for camera and Double tap for gallery')
            ]),
          )
        : GestureDetector(
            onTap: _takePictureViaCamera,
            onDoubleTap: _selectPictureViaGallery,
            child: Image.file(_selectedimage!),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Slice Quest',
          style: TextStyle(
            fontFamily: 'Pizzaman',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: ThemeData().colorScheme.primary,
                  ),
                ),
                width: 500,
                height: 250,
                alignment: Alignment.center,
                child: activeContent),
            const SizedBox(
              height: 30,
            ),
            Container(
                width: 500,
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      hintText: 'Review',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeData().colorScheme.primary))),
                  maxLines: 5,
                  onChanged: (text) {
                    _review = text;
                  },
                )),
            const SizedBox(
              height: 30,
            ),
            StarRating(
              filledIcon: Icons.local_pizza,
              rating: _rating,
              allowHalfRating: true,
              onRatingChanged: ((rating) => setState(() {
                    this._rating = rating;
                  })),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  _submit();
                },
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Complete Quest',
                        style: TextStyle(fontFamily: 'Pizzaman', fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
