import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/quests/repository/quest_repository.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:slice_quest/utils.dart';
import 'package:flutter/material.dart';

final questDataProvider = StateProvider<List<QuestModel>>((ref) {
  return [];
});
final questControllerProvider =
    StateNotifierProvider<QuestController, bool>((ref) {
  return QuestController(
      questRepository: ref.watch(questRepositoryProvider), ref: ref);
});

class QuestController extends StateNotifier<bool> {
  QuestController({required QuestRepository questRepository, required Ref ref})
      : _questRepository = questRepository,
        _ref = ref,
        super(false);

  final QuestRepository _questRepository;
  final Ref _ref;

  Future<void> getQuestData() async {
    List<QuestModel> questData = await _questRepository.getQuestData();

    _ref.read(questDataProvider.notifier).state = questData;
  }

  Future<void> addActiveQuest(
      BuildContext context, String questID, String userID) async {
    final user = await _questRepository.addActiveQuest(questID, userID);
    user.fold((l) => showSnackBar(context, l.errorMessage),
        ((user) => _ref.read(currentUserProvider.notifier).state = user));
  }

  Future<void> removeActiveQuest(BuildContext context, String userID) async {
    final user = await _questRepository.removeActiveQuest(userID);
    user.fold((l) => showSnackBar(context, l.errorMessage),
        ((user) => _ref.read(currentUserProvider.notifier).state = user));
  }
}
