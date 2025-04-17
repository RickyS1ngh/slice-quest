import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/data/quest_data.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';

class CompletedQuestsScreen extends ConsumerStatefulWidget {
  const CompletedQuestsScreen({super.key});

  @override
  ConsumerState<CompletedQuestsScreen> createState() =>
      _CompletedQuestsScreenState();
}

class _CompletedQuestsScreenState extends ConsumerState<CompletedQuestsScreen> {
  @override
  Widget build(BuildContext context) {
    // final List<String> completedQuests =
    //     ref.watch(currentUserProvider)!.completedQuests;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/pizza.png'),
        title: const Text(
          'Slice Quest',
          style: TextStyle(
            fontFamily: 'Pizzaman',
          ),
        ),
      ),
      body: Center(
        child: ref.read(currentUserProvider)!.completedQuests.isEmpty
            ? const Text('There are no completed quests.')
            : Center(
                child: ListView.separated(
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount:
                        ref.read(currentUserProvider)!.completedQuests.length,
                    itemBuilder: (ctx, index) {
                      String? questName;
                      String completedQuestID =
                          ref.read(currentUserProvider)!.completedQuests[0];

                      for (int i = 0; i < questData.length; i++) {
                        if (questData[i].uuid == completedQuestID) {
                          questName = questData[i].name;
                        }
                      }
                      return Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: ThemeData().colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('34',
                                  style: const TextStyle(
                                      fontFamily: 'Pizzaman', fontSize: 15))
                            ],
                          ));
                    })),
      ),
    );
  }
}
