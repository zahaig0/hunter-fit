import 'package:flutter/material.dart';
import 'common.dart';
import 'guide_data.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final myRank = rankIndex(app.level);
        final cards = <Widget>[];
        kGuide.forEach((cat, list) {
          cards.add(CategoryCard(cat: cat, list: list, myRank: myRank));
        });
        final top = <Widget>[
          heading('CALISTHENICS GUIDE'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Your rank: ' + kRanks[myRank] + '. Harder exercises unlock as you rank up.',
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: top + cards,
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String cat;
  final List<Ex> list;
  final int myRank;
  const CategoryCard({Key? key, required this.cat, required this.list, required this.myRank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int unlocked = 0;
    for (final x in list) {
      if (x.minRank <= myRank) unlocked++;
    }
    final tiles = <Widget>[];
    for (final ex in list) {
      tiles.add(ExerciseTile(cat: cat, ex: ex, myRank: myRank));
    }
    final label = cat.toUpperCase() + '  -  ' + unlocked.toString() + '/' + list.length.toString() + ' unlocked';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBlue.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  pic(kCatPic[cat] ?? 12),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xDD000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 8,
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text('Show exercises'),
              children: tiles,
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String cat;
  final Ex ex;
  final int myRank;
  const ExerciseTile({Key? key, required this.cat, required this.ex, required this.myRank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locked = ex.minRank > myRank;
    final id = cat + '-' + ex.name;
    final done = app.doneToday.contains(id);
    final String sub = locked
        ? 'Unlocks at ' + kRanks[ex.minRank] + '-Rank'
        : ex.prescription + '  |  ' + ex.tip;
    Widget? trail;
    if (!locked) {
      trail = IconButton(
        icon: Icon(
          done ? Icons.check_circle : Icons.add_circle_outline,
          color: done ? Colors.greenAccent : kGold,
        ),
        onPressed: done ? null : () => app.completeOnce(id, 15 + ex.minRank * 5),
      );
    }
    return ListTile(
      leading: Icon(
        locked ? Icons.lock : Icons.fitness_center,
        color: locked ? Colors.white30 : rankColor(ex.minRank),
      ),
      title: Text(ex.name, style: TextStyle(color: locked ? Colors.white38 : Colors.white)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: trail,
    );
  }
}
