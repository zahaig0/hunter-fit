import 'package:flutter/material.dart';
import 'common.dart';

// ------------------------- DAILY QUESTS -------------------------
class QuestPage extends StatelessWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final m = 1 + rankIndex(app.level) * 0.5;
        final quests = <List<dynamic>>[
          ['push', 'Push-ups', (50 * m).round(), 40],
          ['sit', 'Sit-ups', (50 * m).round(), 40],
          ['squat', 'Squats', (50 * m).round(), 40],
          ['plank', 'Plank (seconds)', (60 * m).round(), 30],
          ['run', 'Run (km)', (3 * m).round(), 60],
        ];
        final doneCount = quests.where((q) => app.doneToday.contains(q[0])).length;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            heading('DAILY QUEST'),
            banner(12, 'TRAIN HARD', '$doneCount / ${quests.length} completed today',
                h: 200, onTap: () => showFull(context, 12)),
            ...quests.map((q) {
              final id = q[0] as String;
              final done = app.doneToday.contains(id);
              return panel(
                border: done ? Colors.greenAccent : null,
                child: Row(children: [
                  Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: done ? Colors.greenAccent : Colors.white54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${q[1]}  [${q[2]}]',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('+${q[3]} XP', style: const TextStyle(color: kGold)),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: done ? null : () => app.completeOnce(id, q[3] as int),
                    child: Text(done ? 'DONE' : 'CLAIM'),
                  ),
                ]),
              );
            }),
          ],
        );
      },
    );
  }
}
