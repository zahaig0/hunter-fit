import 'package:flutter/material.dart';
import 'common.dart';

// ------------------------- STATUS PAGE -------------------------
class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final idx = rankIndex(app.level);
        final rc = rankColor(idx);
        final need = xpNeeded(app.level);
        final progress = app.level >= 100 ? 1.0 : app.xp / need;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            heading('PLAYER STATUS'),
            banner(20, '${kRanks[idx]}-RANK HUNTER', 'LEVEL ${app.level} / 100',
                h: 230, onTap: () => showFull(context, 20)),
            panel(
              border: rc,
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 14,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(rc),
                  ),
                ),
                const SizedBox(height: 6),
                Text(app.level >= 100 ? 'MAX LEVEL' : 'XP ${app.xp} / $need',
                    style: const TextStyle(color: Colors.white70)),
              ]),
            ),
            Row(children: [
              Expanded(child: _stat(Icons.directions_walk, '${app.totalSteps}', 'Steps')),
              const SizedBox(width: 10),
              Expanded(child: _stat(Icons.route, app.totalKm.toStringAsFixed(1), 'Km')),
              const SizedBox(width: 10),
              Expanded(
                  child: _stat(Icons.local_fire_department,
                      app.totalKcal.toStringAsFixed(0), 'Kcal')),
            ]),
            const SizedBox(height: 4),
            heading('YOUR PHYSIQUE GOAL'),
            banner(kRankPics[idx], 'Goal for ${kRanks[idx]}-Rank',
                'Tap to view full image',
                h: 260, onTap: () => showFull(context, kRankPics[idx])),
            heading('RANK LADDER'),
            ..._ladder(),
          ],
        );
      },
    );
  }

  Widget _stat(IconData i, String v, String l) {
    return panel(
      child: Column(children: [
        Icon(i, color: kGold),
        const SizedBox(height: 4),
        Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(l, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]),
    );
  }

  List<Widget> _ladder() {
    const ranges = [
      '1 - 12', '13 - 25', '26 - 40', '41 - 55', '56 - 70', '71 - 85', '86 - 95', '96 - 100'
    ];
    final out = <Widget>[];
    for (int i = 0; i < kRanks.length; i++) {
      final active = rankIndex(app.level) == i;
      out.add(Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? rankColor(i).withOpacity(0.2) : kCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? rankColor(i) : Colors.white12),
        ),
        child: Row(children: [
          Text('${kRanks[i]}-RANK',
              style: TextStyle(fontWeight: FontWeight.bold, color: rankColor(i))),
          const Spacer(),
          Text('Lv ${ranges[i]}'),
        ]),
      ));
    }
    return out;
  }
}
