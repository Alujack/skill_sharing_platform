import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/services/categories_service.dart';
import './course_detail.dart';
// Import your course service here
import 'package:skill_sharing_platform/services/course_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allCourses =
      []; // Store all courses for filtering
  String _searchQuery = '';
  String? _selectedCategory; // Track selected category
  bool _isLoading = false;
  bool _hasSearched = false;

  // Debounce timer to avoid too many API calls
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchAllCourses(); // Load all courses when screen initializes
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Fetch all courses for filtering
  Future<void> _fetchAllCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await CoursesService.getAllCourses();

      // Convert API response to the format expected by your UI
      final formattedResults = results.map((course) {
        return {
          'id': course['id'],
          'title': course['title'] ?? 'No Title',
          'author': course['instructor']?['name'] ??
              course['instructorName'] ??
              'Unknown Author',
          'rating': course['rating']?.toDouble() ?? 0.0,
          'reviews': course['reviewCount']?.toString() ?? '0',
          'price': course['price'] != null ? '\$${course['price']}' : 'Free',
          'imageUrl': course['thumbnail'] ??
              course['image'] ??
              'assets/images/course.png',
          'description': course['description'] ?? '',
          'category':
              course['category']?['name'] ?? course['categoryName'] ?? '',
        };
      }).toList();

      setState(() {
        _allCourses = List<Map<String, dynamic>>.from(formattedResults);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading courses: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Search Function with API call or local filtering
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.isEmpty && _selectedCategory == null) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    // Set up debounce timer to delay filtering
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _filterCourses();
    });
  }

  // Filter courses based on search query and selected category
  void _filterCourses() {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    List<Map<String, dynamic>> filteredCourses = List.from(_allCourses);

    // Apply category filter if selected
    if (_selectedCategory != null) {
      filteredCourses = filteredCourses
          .where((course) =>
              course['category'].toLowerCase() ==
              _selectedCategory!.toLowerCase())
          .toList();
    }

    // Apply search query filter if not empty
    if (_searchQuery.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((course) =>
              course['title']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              course['description']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              course['category']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              course['author']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _searchResults = filteredCourses;
      _isLoading = false;
    });
  }

  // Handle category selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
      _hasSearched = true;
    });
    _filterCourses();
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _searchQuery = '';
      _searchResults = [];
      _hasSearched = false;
    });
    // Clear the search field if you have a reference to it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.1),
        child: AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(onChanged: _onSearchChanged),
            const SizedBox(height: 16),
            if (_hasSearched || _selectedCategory != null) _buildFilterChips(),
            const SizedBox(height: 16),
            _searchQuery.isEmpty && _selectedCategory == null
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoriesList(
                          onCategorySelected: _onCategorySelected,
                          selectedCategory: _selectedCategory,
                        ),
                      ],
                    ),
                  )
                : Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  // Build filter chips for active filters
  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      children: [
        if (_selectedCategory != null)
          InputChip(
            label: Text(_selectedCategory!),
            onDeleted: () {
              _onCategorySelected(_selectedCategory!);
            },
            deleteIcon: const Icon(Icons.close, size: 16),
          ),
        if (_searchQuery.isNotEmpty)
          InputChip(
            label: Text('"$_searchQuery"'),
            onDeleted: () {
              _onSearchChanged('');
            },
            deleteIcon: const Icon(Icons.close, size: 16),
          ),
        if (_hasSearched || _selectedCategory != null)
          GestureDetector(
            onTap: _clearFilters,
            child: const Chip(
              label: Text(
                'Clear all',
                style: TextStyle(color: Colors.blue),
              ),
              backgroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  // Build Search Results
  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasSearched && _searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No courses found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
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
        // Navigate to the Course Detail page with actual course ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              courseId: product['id'], // Use actual course ID
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Course Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product['imageUrl'].startsWith('http')
                  ? Image.network(
                      product['imageUrl'],
                      width: 100,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/course.png',
                          width: 100,
                          height: 90,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/course.png',
                      width: 100,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
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
                  if (product['category'].isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      product['category'],
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  // Rating and Reviews
                  Row(
                    children: [
                      _buildStarRating(product['rating']),
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
                      color: Colors.green,
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

  // Build star rating dynamically based on rating value
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars && i < 5; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
    }

    // Add half star if needed
    if (hasHalfStar && fullStars < 5) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
    }

    // Add empty stars to complete 5 stars
    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
    }

    return Row(children: stars);
  }
}

// Search Bar Widget (unchanged)
class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search courses...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 238, 238, 238),
      ),
    );
  }
}

class CategoriesList extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String? selectedCategory;

  const CategoriesList({
    required this.onCategorySelected,
    this.selectedCategory,
    super.key,
  });

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await CategoriesService.getAllCategories();
      setState(() {
        categories = List<String>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.map((category) {
            final isSelected = widget.selectedCategory == category;
            return CategoryChip(
              label: category,
              isSelected: isSelected,
              onSelected: () => widget.onCategorySelected(category),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Update CategoryChip to be selectable
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    required this.label,
    this.isSelected = false,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Chip(
        label: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.black,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        backgroundColor:
            isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
      ),
    );
  }
}
