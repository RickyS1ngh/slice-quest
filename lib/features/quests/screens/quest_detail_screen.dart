import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/quests/controller/quest_controller.dart';
import 'package:slice_quest/features/quests/screens/quest_completion_screen.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slice_quest/models/review.dart';

class QuestDetailScreen extends ConsumerStatefulWidget {
  const QuestDetailScreen(this.quest, {super.key});
  final QuestModel quest;

  @override
  ConsumerState<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends ConsumerState<QuestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> completedQuests =
        ref.read(currentUserProvider)?.completedQuests ?? [];

    List<ReviewModel> questCompleted = [];

    if (completedQuests.contains(widget.quest.uuid)) {
      ref
          .read(questControllerProvider.notifier)
          .getReview(context, widget.quest.uuid);
      questCompleted = ref.read(reviewProvider);
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            if (!completedQuests.contains(widget.quest.uuid))
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return CompleteQuestScreen(widget.quest);
                  }));
                },
                child: SizedBox(
                  width: 60,
                  child: Image.asset('assets/images/pizza_add_icon.png',
                      height: 45, color: Colors.white),
                ),
              )
          ],
          title: const Text(
            'Slice Quest',
            style: TextStyle(
              fontFamily: 'Pizzaman',
            ),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/${widget.quest.imageName}.png',
                      height: 600,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Pizzaman',
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.quest.description,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'XP',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Pizzaman',
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Total XP earned for this quest: ${widget.quest.xp}',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Pizzeria Name',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Pizzaman',
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.quest.pizzeriaName,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Location',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Pizzaman',
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.quest.location,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 300,
                        child: GoogleMap(
                            gestureRecognizers: {},
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            mapType: MapType.normal,
                            scrollGesturesEnabled: false,
                            zoomControlsEnabled: true,
                            initialCameraPosition: CameraPosition(
                              zoom: 17,
                              target: LatLng(widget.quest.latitude,
                                  widget.quest.longitude),
                            ),
                            markers: {
                              Marker(
                                  infoWindow: InfoWindow(
                                      title: widget.quest.name,
                                      snippet: widget.quest.pizzeriaName),
                                  markerId: MarkerId(widget.quest.pizzeriaName),
                                  position: LatLng(widget.quest.latitude,
                                      widget.quest.longitude)),
                            })),
                    if (questCompleted.isNotEmpty) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Quest Completed',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'Pizzaman',
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: questCompleted.length,
                            itemBuilder: (contex, index) {
                              return Container(
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                      color: ThemeData().colorScheme.primary,
                                      borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(questCompleted[index].username,
                                                style: const TextStyle(
                                                    fontFamily: 'Pizzaman',
                                                    fontSize: 15)),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            StarRating(
                                              rating:
                                                  questCompleted[index].rating,
                                              filledIcon: Icons.local_pizza,
                                            ),
                                          ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              questCompleted[index].comment)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Image.network(
                                        questCompleted[index].image,
                                        height: 100,
                                      ),
                                    ],
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
