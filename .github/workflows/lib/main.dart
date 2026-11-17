import 'package:flutter/material.dart';
import 'common.dart';
import 'status_page.dart';
import 'quest_page.dart';
import 'train_page.dart';
import 'run_page.dart';
import 'gallery_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HunterApp());
}

// ------------------------- ROOT -------------------------
class HunterApp extends StatelessWidget {
  const HunterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunter Fit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(backgroundColor: kBg, elevation: 0),
        colorScheme: const ColorScheme.dark(primary: kBlue, secondary: kGold),
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({Key? key}) : super(key: key);
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    app.load();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const StatusPage(),
      const QuestPage(),
      const TrainPage(),
      const RunPage(),
      const HeroesPage(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: kCard,
        selectedItemColor: kBlue,
        unselectedItemColor: Colors.white54,
        onTap: (i) => setState(() => tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Train'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Run'),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'Gallery'),
        ],
      ),
    );
  }
}
