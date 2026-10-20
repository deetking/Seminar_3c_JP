import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hod kockou',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DiceHomePage(),
    );
  }
}

class DiceHomePage extends StatefulWidget {
  const DiceHomePage({super.key});

  @override
  State<DiceHomePage> createState() => _DiceHomePageState();
}

class _DiceHomePageState extends State<DiceHomePage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  late final AnimationController _rollController;
  int _diceValue = 1;
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  Future<void> _rollDice() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    await _rollController.forward(from: 0);
    if (!mounted) return;

    setState(() {
      _diceValue = _random.nextInt(6) + 1;
      _isRolling = false;
    });
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Hod kockou')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ťukni na tlačidlo a hoď kockou',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _rollController,
                child: Image.asset(
                  'assets/images/dice-$_diceValue.png',
                  width: 220,
                  height: 220,
                ),
                builder: (context, child) {
                  final progress = _rollController.value;
                  return Transform.translate(
                    offset: Offset(0, -18 * sin(pi * progress)),
                    child: Transform.rotate(
                      angle: 4 * pi * progress,
                      child: Transform.scale(
                        scale: 1 - 0.15 * sin(pi * progress),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isRolling ? null : _rollDice,
                icon: const Icon(Icons.casino),
                label: Text(_isRolling ? 'Hádžem...' : 'Hodiť'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
