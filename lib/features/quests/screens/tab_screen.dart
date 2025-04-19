import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
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
    var profileImage =
        ref.read(currentUserProvider)?.profileImage ?? 'pizza_user_avatar';
    return Scaffold(
        appBar: AppBar(
            leading: Image.asset('assets/images/pizza.png'),
            title: const Text(
              'Slice Quest',
              style: TextStyle(
                fontFamily: 'Pizzaman',
              ),
            ),
            actions: [
              CircleAvatar(
                  backgroundImage:
                      Image.asset('assets/images/$profileImage.png').image)
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  const AssetImage('assets/images/scroll_icon.png'),
                  color: ThemeData().colorScheme.primary,
                  size: 30,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  const AssetImage('assets/images/pizza_complete_icon.png'),
                  color: ThemeData().colorScheme.primary,
                  size: 35,
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
