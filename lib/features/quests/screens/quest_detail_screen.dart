import 'package:flutter/material.dart';
import 'package:slice_quest/features/quests/screens/finish_quest_screen.dart';
import 'package:slice_quest/models/quest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuestDetailScreen extends StatefulWidget {
  const QuestDetailScreen(this.quest, {super.key});
  final QuestModel quest;

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return FinishQuestScreen(widget.quest);
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
                  mainAxisSize: MainAxisSize.max,
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
                      style: TextStyle(fontSize: 18),
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
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2)),
                        child: GoogleMap(
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
                            }))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
