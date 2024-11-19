import 'package:flutter/material.dart';
import 'course_detail.dart';

class FeaturedPage extends StatelessWidget {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserProfile(),
              Image.asset('assets/images/banner.png'),
              const Text(
                'Learning that fits',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Skill for your present (and future)',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recommendation for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              const SizedBox(height: 20),
              const Text(
                'Your skill related',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              const SizedBox(height: 20),
              const Text(
                'Because you search for "JavaScript"',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              const SizedBox(height: 20),
              const Text(
                'Recommendation for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              const SizedBox(height: 20),
              const Text(
                'Recommendation for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              CategoriesSection(),
              const SizedBox(height: 20),
              const Text(
                'Best selller in YTDevs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
              const SizedBox(height: 20),
              const Text(
                'New trending course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CourseRecommendation(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Yoeurn Yan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Manager, Software Development',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Edit occupation and interests',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }
}

class CourseRecommendation extends StatelessWidget {
  const CourseRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CourseCard(),
          SizedBox(width: 10), // Add spacing between cards
          CourseCard(),
          SizedBox(width: 10), // Add spacing between cards
          CourseCard(),
          SizedBox(width: 10), // Add more CourseCards as needed
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to the detail page when the image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CourseDetailPage()),
                );
              },
              child: Image.asset(
                'assets/images/course.png', // Replace with your course image asset
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // // Navigate to the detail page when the title is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CourseDetailPage()),
                      );
                    },
                    child: const Text(
                      'Modern JavaScript From The Beginning 2.0 (2024)',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Yoeurn Yan',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text('5.0 (1,090)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '\$99.99',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class CategoriesSection extends StatelessWidget {
  final List<String> categories = [
    'Development',
    'Business',
    'Design',
    'Marketing',
    'IT & Software',
    'Personal Development',
    'Photography',
    'Music',
  ];

  CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Handle "see all" action
                },
                child: const Text(
                  'see all',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle category click
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(category),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
