import 'package:flutter/material.dart';
import 'common.dart';

// ------------------------- GALLERY -------------------------
class HeroInfo {
  final String name;
  final String goal;
  final String routine;
  final List<int> pics;
  const HeroInfo(this.name, this.goal, this.routine, this.pics);
}

const List<HeroInfo> kHeroes = [
  HeroInfo(
    'GAROU',
    'Lean, flexible, fight-ready physique',
    'Focus: abs, back, shoulders, flexibility.\n'
        '| 100 push-ups, 100 sit-ups, 100 squats daily\n'
        '| Hanging leg raises, L-sit, dragon flags\n'
        '| Handstand work and mobility drills',
    [20, 15],
  ),
  HeroInfo(
    'METAL BAT',
    'Dense, powerful athletic physique',
    'Focus: chest, arms, legs, explosiveness.\n'
        '| Clap push-ups, dips, archer push-ups\n'
        '| Jump squats, pistol squats, sprints\n'
        '| Core circuits and agility ladder work',
    [18, 1, 2],
  ),
];

const List<int> kInspiration = [4, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 19, 3, 5, 6];

class HeroesPage extends StatelessWidget {
  const HeroesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        heading('HERO TARGETS'),
        ...kHeroes.map((h) => panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 340,
                  child: PageView(
                    children: h.pics
                        .map((n) => GestureDetector(
                              onTap: () => showFull(context, n),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: pic(n, width: double.infinity),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                    child: Text('Swipe for more | tap to zoom',
                        style: TextStyle(color: Colors.white38, fontSize: 11))),
                const SizedBox(height: 6),
                Text(h.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: kGold)),
                Text(h.goal, style: const TextStyle(color: kBlue)),
                const SizedBox(height: 8),
                Text(h.routine),
              ]),
            )),
        heading('INSPIRATION'),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: kInspiration
              .map((n) => GestureDetector(
                    onTap: () => showFull(context, n),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: pic(n),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
