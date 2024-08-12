import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewMoreCategoriesScreen extends StatefulWidget {
  @override
  _ViewMoreCategoriesScreenState createState() =>
      _ViewMoreCategoriesScreenState();
}

class _ViewMoreCategoriesScreenState extends State<ViewMoreCategoriesScreen> {
  String selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Categories'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('All'),
                    selected: selectedType == 'all',
                    onSelected: (selected) {
                      setState(() {
                        selectedType = 'all';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Cars'),
                    selected: selectedType == 'car',
                    onSelected: (selected) {
                      setState(() {
                        selectedType = 'car';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Bikes'),
                    selected: selectedType == 'bike',
                    onSelected: (selected) {
                      setState(() {
                        selectedType = 'bike';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .where('type',
                      isEqualTo: selectedType == 'all' ? null : selectedType)
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

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryData =
                        categories[index].data() as Map<String, dynamic>;
                    return Card(
                      child: Column(
                        children: [
                          Image.network(
                            categoryData['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
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
                          Text(categoryData['name'] ?? ''),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
