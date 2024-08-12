import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PopularItemCard extends StatelessWidget {
  final Map<String, dynamic> itemData;
  final bool isFavorites;
  final AnimationController controller;
  final Color cardColor;
  final Function() onTapFavorite;

  const PopularItemCard({
    Key? key,
    required this.itemData,
    required this.isFavorites,
    required this.controller,
    required this.cardColor,
    required this.onTapFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 384,
      height: 180, // Adjust height as needed
      child: Card(
        color: cardColor, // Set background color
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemData['name'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${itemData['price']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      itemData['description'] ?? 'No description available',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: onTapFavorite,
                        child: Container(
                          height: 50,
                          child: Lottie.network(
                            'https://lottie.host/c595e8b9-dcfb-4ff9-a21e-6f044d4c3335/5rlpPjtDey.json',
                            controller: controller,
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
    );
  }
}
