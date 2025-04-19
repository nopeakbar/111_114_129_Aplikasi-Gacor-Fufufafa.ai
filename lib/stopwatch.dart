import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  final List<Duration> _lapDurations = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 30), _updateTime);
  }

  String _formattedTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return "${twoDigits(d.inHours)}:$minutes:$seconds.$milliseconds";
  }

  String _currentTime = "00:00:00.00";

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _currentTime = _formattedTime(_stopwatch.elapsed);
      });
    }
  }

  void _start() {
    setState(() {
      _stopwatch.start();
    });
  }

  void _stop() {
    setState(() {
      _stopwatch.stop();
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.reset();
      _currentTime = "00:00:00.00";
      _lapDurations.clear();
    });
  }

  void _lap() {
    setState(() {
      _lapDurations.insert(0, _stopwatch.elapsed);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasLap = _lapDurations.isNotEmpty;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Stopwatch")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (!hasLap)
                Expanded(
                  child: Center(
                    child: Text(
                      _currentTime,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else ...[
                Center(
                  child: Text(
                    _currentTime,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _stopwatch.isRunning ? null : _start,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.orange, // teks warna oranye
                    ),
                    child: const Text("Start"),
                  ),
                  ElevatedButton(
                    onPressed: _stopwatch.isRunning ? _stop : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                    child: const Text("Stop"),
                  ),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _stopwatch.isRunning ? _lap : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                    child: const Text("Lap"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              if (hasLap) ...[
                const Text(
                  "Lap Times",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Lap",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Lap Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Overall Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Expanded(
                  child: ListView.builder(
                    itemCount: _lapDurations.length,
                    itemBuilder: (context, index) {
                      final current = _lapDurations[index];
                      final next =
                          index == _lapDurations.length - 1
                              ? Duration.zero
                              : _lapDurations[index + 1];
                      final lapTime = current - next;

                      return Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text("${_lapDurations.length - index}"),
                            ),
                          ),
                          Expanded(
                            child: Center(child: Text(_formattedTime(lapTime))),
                          ),
                          Expanded(
                            child: Center(child: Text(_formattedTime(current))),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
