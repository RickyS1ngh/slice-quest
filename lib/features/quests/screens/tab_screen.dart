import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slice_quest/features/quests/screens/all_quests_screen.dart';
import 'package:slice_quest/features/quests/screens/completed_quests_screen.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/images/scroll_icon.png'),
                  size: 30,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline_sharp,
                  size: 30,
                ),
                label: ''),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _selectedIndex == 0
            ? const AllQuestsScreen()
            : const CompletedQuestsScreen());
  }
}
