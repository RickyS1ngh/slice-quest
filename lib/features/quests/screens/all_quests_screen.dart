import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';

import 'package:slice_quest/features/quests/controller/quest_controller.dart';
import 'package:slice_quest/features/quests/screens/quest_detail_screen.dart';
import 'package:slice_quest/models/quest.dart';

class AllQuestsScreen extends ConsumerStatefulWidget {
  const AllQuestsScreen({super.key});

  @override
  ConsumerState<AllQuestsScreen> createState() => _AllQuestsScreenState();
}

class _AllQuestsScreenState extends ConsumerState<AllQuestsScreen> {
  @override
  Widget build(BuildContext context) {
    String? activeQuest = ref.watch(currentUserProvider)?.activeQuest ?? '';

    List<QuestModel> originalQuestData = ref.read(questDataProvider);
    List<QuestModel> questData = activeQuest == ''
        ? originalQuestData
        : originalQuestData
            .where((quest) => quest.uuid != activeQuest)
            .toList();
    List<QuestModel> title = activeQuest == ''
        ? []
        : originalQuestData
            .where((quest) => quest.uuid == activeQuest)
            .toList();

    return Scaffold(
      body: originalQuestData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  if (activeQuest != '') ...[
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        ' Active Quests',
                        style: TextStyle(
                          fontFamily: 'Pizzaman',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          activeQuest = null;
                          ref
                              .read(questControllerProvider.notifier)
                              .removeActiveQuest(
                                  context, ref.read(currentUserProvider)!.uid);
                        });
                      },
                      key: UniqueKey(),
                      child: GestureDetector(
                        onTap: () {
                          List<QuestModel> quest = originalQuestData
                              .where((quest) => quest.uuid == activeQuest)
                              .toList();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return QuestDetailScreen(quest[0]);
                          }));
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              color: ThemeData().colorScheme.primary,
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title[0].name,
                                style: const TextStyle(
                                    fontFamily: 'Pizzaman', fontSize: 15),
                              ),
                              const ImageIcon(
                                AssetImage(
                                  'assets/images/pizza_active_icon.png',
                                ),
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      ' All Quests',
                      style: TextStyle(
                        fontFamily: 'Pizzaman',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: questData.length,
                      separatorBuilder: (ctx, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (ctx, index) => Dismissible(
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            activeQuest = questData[index].uuid;

                            ref
                                .read(questControllerProvider.notifier)
                                .addActiveQuest(context, questData[index].uuid,
                                    ref.read(currentUserProvider)!.uid);
                          });
                        },
                        key: UniqueKey(),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return QuestDetailScreen(questData[index]);
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeData().colorScheme.primary,
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  questData[index].name,
                                  style: const TextStyle(
                                      fontFamily: 'Pizzaman', fontSize: 15),
                                ),
                                Text(
                                  'XP ${questData[index].xp.toString()}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
