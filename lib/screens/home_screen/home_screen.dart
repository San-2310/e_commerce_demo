import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_demo/components/scratch_card.dart';
//import 'package:e_commerce_demo/screens/home_screen/view_more_categories.dart';
import 'package:e_commerce_demo/screens/popular_items/view_all_popluar.dart';
import 'package:e_commerce_demo/screens/view_more_categoories_screen/view_more_categories.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    //_controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final w = MediaQuery.of(context).size.width;
    //final h = MediaQuery.of(context).size.height;
    bool isFavorites =
        false; // Replace with actual logic to check if user has favorites
    // Function to get alternating colors
    Color getCardColor(int index) {
      return index % 2 == 0
          ? Theme.of(context).colorScheme.primaryContainer
          : Colors.grey[200]!;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('Categories', style: TextStyle(fontSize: 24)),
          ),
          Container(
            height: 200, // Adjust the height as needed
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No categories available.'));
                }

                final categories = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length < 4 ? categories.length : 4,
                  itemBuilder: (context, index) {
                    final categoryData =
                        categories[index].data() as Map<String, dynamic>;
                    return Container(
                      width: 160, // Adjust the width as needed
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.network(
                                  categoryData['imageUrl'] ?? '',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/images/logo.png'); // Fallback image
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                categoryData['name'] ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewMoreCategoriesScreen(),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('View All'),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
          // If PopularItemsWidget is also using Column or ListView, ensure it's properly constrained.
          //PopularItemsWidget(),
          //SizedBox(height: h / 20),
          MyScratchCard(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('Popular Items', style: TextStyle(fontSize: 24)),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .where('popularity', isGreaterThan: 50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No popular items available.'));
                  }

                  final items = snapshot.data!.docs;

                  return Wrap(
                    spacing: 8.0, // Horizontal space between items
                    runSpacing: 8.0, // Vertical space between items
                    children: List.generate(
                      items.length < 8 ? items.length : 8,
                      (index) {
                        final itemData =
                            items[index].data() as Map<String, dynamic>;

                        return Center(
                          child: Container(
                            width: 384,
                            height: 180, // Adjust height as needed
                            child: Card(
                              color:
                                  getCardColor(index), // Set background color
                              child: Row(
                                children: [
                                  // Image on the left
                                  Container(
                                    // Adjust height to make it square
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/item.png',
                                        width: 135,
                                        height: 135,
                                      ),
                                    ),
                                  ),
                                  // Content on the right
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              itemData['name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '\$${itemData['price']}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              itemData['description'] ??
                                                  'No description available',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800]),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (isFavorites == false) {
                                                    isFavorites = true;
                                                    _controller.forward();
                                                  } else {
                                                    isFavorites = false;
                                                    _controller.reverse();
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  child: Lottie.network(
                                                    'https://lottie.host/c595e8b9-dcfb-4ff9-a21e-6f044d4c3335/5rlpPjtDey.json',
                                                    controller: _controller,
                                                  ),
                                                  //child: Icon(Icons.favorite),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PopularItemsPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View More'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
