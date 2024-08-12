import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart'; // Import the confetti package
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:uuid/uuid.dart';

class MyScratchCard extends StatefulWidget {
  @override
  State<MyScratchCard> createState() => _MyScratchCardState();
}

class _MyScratchCardState extends State<MyScratchCard> {
  double _opacity = 0.0;
  final GlobalKey<ScratcherState> scratchKey = GlobalKey<ScratcherState>();

  late ConfettiController _confettiController; // Confetti controller

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
        duration: const Duration(
            milliseconds: 1000)); // Initialize confetti controller
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Dispose the confetti controller
    super.dispose();
  }

  Future<void> scratchCardDialog(BuildContext context) async {
    final categories = await _getCategoriesFromFirebase();
    final random = Random();
    final selectedCategory = categories[random.nextInt(categories.length)];
    final discount =
        10 + random.nextInt(6); // Random discount between 10% and 15%

    final bgImageNumber =
        random.nextInt(11) + 1; // Random number between 1 and 11
    final bgImagePath =
        "assets/images/scratch_card_bgs/scratch$bgImageNumber.png";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'You\'ve won a scratch card',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            var uuid = const Uuid();
            return Stack(
              children: [
                Scratcher(
                  key: scratchKey,
                  accuracy: ScratchAccuracy.low,
                  threshold: 40,
                  brushSize: 40,
                  image: Image.asset(
                    bgImagePath,
                    fit: BoxFit.cover,
                  ),
                  onThreshold: () {
                    setState(
                      () {
                        _opacity = 1;
                        scratchKey.currentState
                            ?.reveal(duration: Duration(seconds: 1));
                        _confettiController
                            .play(); // Play confetti animation on reveal
                      },
                    );
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 250),
                    opacity: _opacity,
                    child: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            selectedCategory['imageUrl'],
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "$discount% off on ${selectedCategory['name']} products!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Use coupon code: ${uuid.v4().substring(0, 8).toUpperCase()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 300,
                  right: 150,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                    createParticlePath: (size) {
                      // You can customize the shape of the confetti particles here.
                      return Path()
                        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getCategoriesFromFirebase() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs
        .map((doc) => {
              'name': doc['name'],
              'imageUrl': doc['imageUrl'],
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    //final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => scratchCardDialog(context),
              child: Container(
                width: 400,
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/reward1.png'), // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Get Your Daily Reward",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
