import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample product data
    List<Map<String, dynamic>> products = List.generate(2     , (index) {
      return {
        'title': 'Course Title $index',
        'author': 'Author $index',
        'reviews': 20 + index,
        'price': '\$${index * 10 + 19.99}'
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
