import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:slice_quest/data/quest_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slice_quest/firebase_options.dart';

Future<void> seedDB() async {
  try {
    var firestore = FirebaseFirestore.instance;

    for (int i = 0; i < questData.length; i++) {
      await firestore
          .collection('Quests')
          .doc(questData[i].uuid)
          .set(questData[i].toMap());
    }
  } on FirebaseException catch (error) {
    print(error);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await seedDB();
}
