import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/controller/auth_controller.dart';
import 'package:slice_quest/features/profile/screens/profile_screen.dart';
import 'package:slice_quest/features/quests/screens/all_quests_screen.dart';
import 'package:slice_quest/features/quests/screens/completed_quests_screen.dart';
import 'package:slice_quest/features/quests/screens/quest_completion_screen.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    var profileImage = ref.watch(currentUserProvider)?.profileImage ?? '';
    return Drawer(
        child: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          CircleAvatar(
              maxRadius: 75,
              backgroundImage: Image.network(profileImage).image),
          const SizedBox(
            height: 30,
          ),
          Text(
            ref.read(currentUserProvider)!.username,
            style: const TextStyle(fontFamily: 'Pizzaman', fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/xp_icon.png',
                height: 45,
                color: ThemeData().colorScheme.primary,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(ref.read(currentUserProvider)!.xp.toString(),
                  style: const TextStyle(fontFamily: 'Pizzaman', fontSize: 20)),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
            },
            leading: Icon(Icons.person),
            title: Text('View Profile',
                style: TextStyle(fontFamily: 'Pizzaman', fontSize: 18)),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 300,
          ),
          ListTile(
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut(context);
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout',
                style: TextStyle(fontFamily: 'Pizzaman', fontSize: 18)),
          )
        ],
      ),
    ));
  }
}
