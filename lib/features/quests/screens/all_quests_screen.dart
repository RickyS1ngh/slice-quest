import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';

import 'package:slice_quest/features/quests/controller/quest_controller.dart';
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

    List<QuestModel> questData2 = ref.read(questDataProvider);
    List<QuestModel> questData1 = activeQuest == ''
        ? questData2
        : questData2.where((quest) => quest.uuid != activeQuest).toList();
    List<QuestModel> title = activeQuest == ''
        ? []
        : questData2.where((quest) => quest.uuid == activeQuest).toList();

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
      body: questData2.isEmpty
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
                      itemCount: questData1.length,
                      separatorBuilder: (ctx, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (ctx, index) => Dismissible(
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            activeQuest = questData1[index].uuid;

                            ref
                                .read(questControllerProvider.notifier)
                                .addActiveQuest(context, questData1[index].uuid,
                                    ref.read(currentUserProvider)!.uid);
                          });
                        },
                        key: UniqueKey(),
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
                                questData1[index].name,
                                style: const TextStyle(
                                    fontFamily: 'Pizzaman', fontSize: 15),
                              ),
                              Text(
                                'XP ${questData1[index].xp.toString()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
