import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
            const SearchBar(),
            const SizedBox(height: 16),
            const PopularTags(),
            const SizedBox(height: 16),
            Expanded(child: CategoriesList()),
          ],
        ),
      ),
    );
  }
}

// Search Bar Widget
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 245, 248, 248),
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
