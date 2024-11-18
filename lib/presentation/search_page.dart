import 'package:flutter/material.dart';
import './course_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Modern JavaScript From The Beginning 2.0 (2024)',
      'author': 'Yoeurn Yan',
      'rating': 4.5,
      'reviews': '1,090',
      'price': '\$99.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Advanced Flutter Development',
      'author': 'John Doe',
      'rating': 4.8,
      'reviews': '2,500',
      'price': '\$149.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'React Native for Beginners',
      'author': 'Jane Smith',
      'rating': 4.2,
      'reviews': '800',
      'price': '\$79.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Modern JavaScript From The Beginning (2024)',
      'author': 'Yoeurn Yan',
      'rating': 4.5,
      'reviews': '1,090',
      'price': '\$99.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Advanced Flutter Developmen',
      'author': 'John Doe',
      'rating': 4.8,
      'reviews': '2,500',
      'price': '\$149.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'React Native for Beginne',
      'author': 'Jane Smith',
      'rating': 4.2,
      'reviews': '800',
      'price': '\$79.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Modern JavaScript (2024)',
      'author': 'Yoeurn Yan',
      'rating': 4.5,
      'reviews': '1,090',
      'price': '\$99.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Advanced Flutter',
      'author': 'John Doe',
      'rating': 4.8,
      'reviews': '2,500',
      'price': '\$149.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'React Native',
      'author': 'Jane Smith',
      'rating': 4.2,
      'reviews': '800',
      'price': '\$79.99',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  List<Map<String, dynamic>> _searchResults = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchResults = _products;
  }

  // Search Function
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _searchResults = query.isEmpty
          ? []
          : _products
              .where((product) =>
                  product['title'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(onChanged: _onSearchChanged),
            const SizedBox(height: 16),
            _searchQuery.isEmpty
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        PopularTags(),
                        SizedBox(height: 16),
                        Expanded(child: CategoriesList()),
                      ],
                    ),
                  )
                : Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  // Build Search Results
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _buildProductCard(product);
      },
    );
  }

  // Product Card Widget
  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Course Detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/course.png',
              width: 100,
              height: 90,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['author'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star_half,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '(${product['reviews']})',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Bar Widget
class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 238, 238, 238),
      ),
    );
  }
}

// Popular Tags Widget
class PopularTags extends StatelessWidget {
  const PopularTags({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tags = [
      'Python',
      'Development',
      'Business',
      'Design',
      'Marketing',
      'Music',
      'Lifestyle',
      'Health',
      'Finance',
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((tag) => TagChip(label: tag)).toList(),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );
  }
}

// Categories List Widget
class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Development',
      'IT & Software',
      'Business',
      'Finance & Accounting',
      'Office Productivity',
      'Personal Development',
      'Design',
      'Lifestyle',
      'Marketing',
      'Photography & Video',
      'Health & Fitness',
      'Music',
      'Teaching & Academics',
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            categories[index],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
