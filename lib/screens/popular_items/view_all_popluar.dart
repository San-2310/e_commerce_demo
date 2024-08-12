import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PopularItemsPage extends StatefulWidget {
  const PopularItemsPage({super.key});

  @override
  _PopularItemsPageState createState() => _PopularItemsPageState();
}

class _PopularItemsPageState extends State<PopularItemsPage>
    with SingleTickerProviderStateMixin {
  bool isFavorites = false;
  late AnimationController _controller;
  String selectedCategory = 'All';
  String sortBy = 'popularity';
  List<String> categories = ['All'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    fetchCategories(); // Fetch categories on init
  }

  Future<void> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final fetchedCategories =
        snapshot.docs.map((doc) => doc['name'] as String).toList();
    setState(() {
      categories.addAll(fetchedCategories);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getCardColor(int index) {
    return index % 2 == 0
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular Items',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('Popular Items', style: TextStyle(fontSize: 24)),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: getFilteredAndSortedItems(),
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
                            color: getCardColor(index), // Set background color
                            child: Row(
                              children: [
                                // Image on the left
                                Container(
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
                                              setState(() {
                                                isFavorites = !isFavorites;
                                                if (isFavorites) {
                                                  _controller.forward();
                                                } else {
                                                  _controller.reverse();
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              child: Lottie.network(
                                                'https://lottie.host/c595e8b9-dcfb-4ff9-a21e-6f044d4c3335/5rlpPjtDey.json',
                                                controller: _controller,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getFilteredAndSortedItems() {
    Query itemsQuery = FirebaseFirestore.instance
        .collection('items')
        .where('popularity', isGreaterThan: 50);

    if (selectedCategory != 'All') {
      itemsQuery = itemsQuery.where('category', isEqualTo: selectedCategory);
    }

    if (sortBy == 'price') {
      itemsQuery = itemsQuery.orderBy('price', descending: true);
    } else {
      itemsQuery = itemsQuery.orderBy('popularity', descending: true);
    }

    return itemsQuery.snapshots();
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Sort by Popularity'),
              onTap: () {
                setState(() {
                  sortBy = 'popularity';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sort by Price'),
              onTap: () {
                setState(() {
                  sortBy = 'price';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
