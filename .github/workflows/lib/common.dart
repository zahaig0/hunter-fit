import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ------------------------- THEME -------------------------
const Color kBg = Color(0xFF0A0E1A);
const Color kCard = Color(0xFF131A2E);
const Color kBlue = Color(0xFF3FA9FF);
const Color kGold = Color(0xFFFFC857);

// ------------------------- IMAGES -------------------------
// Image files are assets/images/p01.jpg ... p20.jpg (same order you sent them).
String img(int n) => 'assets/images/p${n.toString().padLeft(2, '0')}.jpg';

Widget pic(int n,
    {double? height,
    double? width,
    Alignment align = Alignment.topCenter,
    BoxFit fit = BoxFit.cover}) {
  return Image.asset(
    img(n),
    height: height,
    width: width,
    fit: fit,
    alignment: align,
    errorBuilder: (context, error, stack) => Container(
      height: height,
      width: width,
      color: Colors.black26,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.white38),
    ),
  );
}

Widget banner(int n, String title, String sub,
    {double h = 150, Alignment align = Alignment.topCenter, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBlue.withOpacity(0.35)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(fit: StackFit.expand, children: [
          pic(n, align: align),
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
            bottom: 10,
            right: 14,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (sub.isNotEmpty)
                    Text(sub, style: const TextStyle(color: kGold, fontSize: 13)),
                ]),
          ),
        ]),
      ),
    ),
  );
}

void showFull(BuildContext context, int n) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(img(n),
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.image_not_supported, color: Colors.white38, size: 60)),
        ),
      ),
    ),
  ));
}

// ------------------------- RANKS -------------------------
const List<String> kRanks = ['E', 'D', 'C', 'B', 'A', 'S', 'SS', 'SSS'];
// physique goal image per rank (E..SSS)
const List<int> kRankPics = [12, 16, 13, 17, 18, 2, 15, 20];

int rankIndex(int lv) {
  if (lv <= 12) return 0;
  if (lv <= 25) return 1;
  if (lv <= 40) return 2;
  if (lv <= 55) return 3;
  if (lv <= 70) return 4;
  if (lv <= 85) return 5;
  if (lv <= 95) return 6;
  return 7;
}

Color rankColor(int idx) {
  const colors = [
    Color(0xFF9E9E9E), Color(0xFF4CAF50), Color(0xFF29B6F6), Color(0xFF7E57C2),
    Color(0xFFFF9800), Color(0xFFF44336), Color(0xFFE91E63), Color(0xFFFFD700),
  ];
  return colors[idx];
}

int xpNeeded(int lv) => 80 + lv * 20;

// ------------------------- APP STATE -------------------------
class AppState extends ChangeNotifier {
  int level = 1;
  int xp = 0;
  int totalSteps = 0;
  double totalKm = 0;
  double totalKcal = 0;
  Set<String> doneToday = {};
  List<String> runs = [];
  String dayKey = '';
  SharedPreferences? prefs;

  String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  Future<void> load() async {
    try {
      prefs = await SharedPreferences.getInstance();
      level = prefs!.getInt('level') ?? 1;
      xp = prefs!.getInt('xp') ?? 0;
      totalKm = prefs!.getDouble('km') ?? 0;
      totalKcal = prefs!.getDouble('kcal') ?? 0;
      totalSteps = prefs!.getInt('steps') ?? 0;
      runs = prefs!.getStringList('runs') ?? [];
      final saved = prefs!.getString('dayKey') ?? '';
      if (saved == _today()) {
        doneToday = (prefs!.getStringList('done') ?? []).toSet();
      } else {
        doneToday = {};
      }
    } catch (_) {}
    dayKey = _today();
    notifyListeners();
  }

  void save() {
    try {
      prefs?.setInt('level', level);
      prefs?.setInt('xp', xp);
      prefs?.setDouble('km', totalKm);
      prefs?.setDouble('kcal', totalKcal);
      prefs?.setInt('steps', totalSteps);
      prefs?.setStringList('runs', runs);
      prefs?.setString('dayKey', dayKey);
      prefs?.setStringList('done', doneToday.toList());
    } catch (_) {}
  }

  void addXp(int amount) {
    xp += amount;
    while (level < 100 && xp >= xpNeeded(level)) {
      xp -= xpNeeded(level);
      level++;
    }
    if (level >= 100) {
      level = 100;
      if (xp > xpNeeded(100)) xp = xpNeeded(100);
    }
    save();
    notifyListeners();
  }

  void completeOnce(String id, int amount) {
    if (doneToday.contains(id)) return;
    doneToday.add(id);
    addXp(amount);
  }

  void addRun(double km, int secs, double kcal) {
    totalKm += km;
    totalKcal += kcal;
    final n = DateTime.now();
    runs.insert(0,
        '${km.toStringAsFixed(2)}|$secs|${kcal.toStringAsFixed(0)}|${n.day}/${n.month}/${n.year}');
    if (runs.length > 50) runs.removeLast();
    addXp((km * 40).round() + 10);
  }
}

final AppState app = AppState();


Widget panel({required Widget child, Color? border}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border ?? kBlue.withOpacity(0.35)),
    ),
    child: child,
  );
}

Widget heading(String t) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(t, style: const TextStyle(fontSize: 13, letterSpacing: 4, color: kBlue)),
    );
