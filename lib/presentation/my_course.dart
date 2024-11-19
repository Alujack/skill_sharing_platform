import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/my_course_learning.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: AppBar(),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),

          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterButton(label: 'All'),
                FilterButton(label: 'Downloads'),
                FilterButton(label: 'Favourite'),
                FilterButton(label: 'Archived'),
              ],
            ),
          ),

          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Adjust the count as needed
              itemBuilder: (context, index) {
                return CourseItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;

  const FilterButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(label),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  const CourseItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Image.asset(
          'assets/images/course.png', // Placeholder image URL
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          'Modern JavaScript From The Beginning 2.0 (2024)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yeourn Yan'),
            SizedBox(height: 4),
            Text(
              'Start course',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCourseLearning()),
          );
        },
      ),
    );
  }
}
