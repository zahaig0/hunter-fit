import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pedometer/pedometer.dart';
import 'common.dart';

// ------------------------- RUN / GPS / PEDOMETER -------------------------
class RunPage extends StatefulWidget {
  const RunPage({Key? key}) : super(key: key);
  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  final MapController mapController = MapController();
  final List<LatLng> route = [];
  StreamSubscription<Position>? posSub;
  StreamSubscription<StepCount>? stepSub;
  Timer? timer;
  bool running = false;
  int secs = 0;
  double meters = 0;
  int steps = 0;
  int stepBase = -1;
  String msg = '';
  LatLng center = const LatLng(51.5074, -0.1278);

  static const double weightKg = 70;

  double get kcal {
    if (meters > 0) return (meters / 1000) * weightKg;
    return steps * 0.04;
  }

  String get pace {
    if (meters < 20) return '--:--';
    final spk = secs / (meters / 1000);
    final m = spk ~/ 60;
    final s = (spk % 60).toInt();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get clock {
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = secs % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> start() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        setState(() => msg = 'Turn on location services.');
        return;
      }
      LocationPermission p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
        setState(() => msg = 'Location permission denied.');
        return;
      }
    } catch (e) {
      setState(() => msg = 'GPS unavailable here (use a real phone).');
      return;
    }

    route.clear();
    meters = 0;
    secs = 0;
    steps = 0;
    stepBase = -1;
    msg = '';
    setState(() => running = true);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => secs++);
    });

    try {
      posSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        ),
      ).listen((pos) {
        final pt = LatLng(pos.latitude, pos.longitude);
        if (route.isNotEmpty) {
          meters += Geolocator.distanceBetween(
              route.last.latitude, route.last.longitude, pt.latitude, pt.longitude);
        }
        route.add(pt);
        center = pt;
        if (mounted) setState(() {});
        try {
          mapController.move(pt, 16);
        } catch (_) {}
      }, onError: (_) {});
    } catch (_) {
      setState(() => msg = 'Could not start GPS stream.');
    }

    try {
      stepSub = Pedometer.stepCountStream.listen((s) {
        if (stepBase < 0) stepBase = s.steps;
        if (mounted) setState(() => steps = s.steps - stepBase);
      }, onError: (_) {});
    } catch (_) {}
  }

  void stop() {
    posSub?.cancel();
    stepSub?.cancel();
    timer?.cancel();
    final km = meters / 1000;
    final k = kcal;
    final doneSecs = secs;
    final doneSteps = steps;
    setState(() => running = false);
    if (km > 0.01 || doneSteps > 10) {
      app.totalSteps += doneSteps;
      app.addRun(km, doneSecs, k);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: kCard,
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: pic(15, height: 200, width: double.infinity),
              ),
              const SizedBox(height: 12),
              const Text('QUEST COMPLETE',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: kGold)),
              const SizedBox(height: 6),
              Text('${km.toStringAsFixed(2)} km  |  ${k.toStringAsFixed(0)} kcal'),
              Text('$doneSteps steps  |  +${(km * 40).round() + 10} XP'),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    posSub?.cancel();
    stepSub?.cancel();
    timer?.cancel();
    super.dispose();
  }

  Widget _metric(String v, String l) {
    return Expanded(
      child: Column(children: [
        Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(l, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final km = (meters / 1000).toStringAsFixed(2);
    return Column(children: [
      Expanded(
        flex: 4,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(initialCenter: center, initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hunter_fit',
            ),
            PolylineLayer(polylines: [
              Polyline(
                  points: List<LatLng>.from(route),
                  strokeWidth: 5,
                  color: Colors.deepOrange),
            ]),
            if (route.isNotEmpty)
              MarkerLayer(markers: [
                Marker(
                  point: route.last,
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.my_location, color: kBlue),
                ),
              ]),
          ],
        ),
      ),
      Container(
        color: kCard,
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 70,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(fit: StackFit.expand, children: [
                pic(running ? 2 : 17, align: Alignment.center),
                Container(color: Colors.black54),
                Center(
                  child: Text(
                      running ? 'HUNT IN PROGRESS' : 'READY TO HUNT',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 3, color: kGold)),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            _metric(km, 'KM'),
            _metric(clock, 'TIME'),
            _metric(pace, 'PACE /km'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _metric('$steps', 'STEPS'),
            _metric(kcal.toStringAsFixed(0), 'KCAL'),
            _metric('${route.length}', 'GPS PTS'),
          ]),
          if (msg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(msg, style: const TextStyle(color: Colors.redAccent)),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: running ? Colors.redAccent : Colors.deepOrange),
              onPressed: running ? stop : start,
              icon: Icon(running ? Icons.stop : Icons.play_arrow),
              label: Text(running ? 'FINISH' : 'START ACTIVITY'),
            ),
          ),
          if (app.runs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Last: ${_fmtRun(app.runs.first)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ),
        ]),
      ),
    ]);
  }

  String _fmtRun(String r) {
    final p = r.split('|');
    if (p.length < 4) return r;
    return '${p[0]} km | ${p[2]} kcal | ${p[3]}';
  }
}
