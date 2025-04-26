import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/data/quest_data.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/quests/controller/quest_controller.dart';
import 'package:slice_quest/models/quest.dart';

class CompletedQuestsScreen extends ConsumerStatefulWidget {
  const CompletedQuestsScreen({super.key});

  @override
  ConsumerState<CompletedQuestsScreen> createState() =>
      _CompletedQuestsScreenState();
}

class _CompletedQuestsScreenState extends ConsumerState<CompletedQuestsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<QuestModel> completedQuests = [];
    final List<QuestModel> questData = ref.read(questDataProvider);
    final List<String> userCompletedQuests =
        ref.watch(currentUserProvider)?.completedQuests ?? [];

    if (userCompletedQuests != []) {
      for (int i = 0; i < questData.length; i++) {
        for (int j = 0; j < userCompletedQuests.length; j++) {
          if (questData[i].uuid == userCompletedQuests[j]) {
            completedQuests.add(questData[i]);
          }
        }
      }
    }
    return Scaffold(
      body: Center(
        child: userCompletedQuests.isEmpty
            ? const Text('There are no completed quests.')
            : Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        '  Completed Quests',
                        style: TextStyle(fontFamily: 'Pizzaman', fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: ListView.separated(
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: completedQuests.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: ThemeData().colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(completedQuests[index].name,
                                  style: const TextStyle(
                                      fontFamily: 'Pizzaman', fontSize: 15)),
                            ],
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
      ),
    );
  }
}
