import 'package:flutter/material.dart';
import 'package:slice_quest/data/quest_data.dart';

class AllQuestsScreen extends StatefulWidget {
  const AllQuestsScreen({super.key});

  @override
  State<AllQuestsScreen> createState() => _AllQuestsScreenState();
}

class _AllQuestsScreenState extends State<AllQuestsScreen> {
  @override
  Widget build(BuildContext context) {
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
        child: Container(
          margin: EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: ListView.separated(
            itemCount: questData.length,
            separatorBuilder: (ctx, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (ctx, index) => ListTile(
              contentPadding: const EdgeInsets.all(15),
              tileColor: ThemeData().colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              title: Text(
                questData[index].name,
                style: const TextStyle(fontFamily: 'Pizzaman', fontSize: 15),
              ),
              trailing: Text(
                'XP ${questData[index].xp.toString()}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
