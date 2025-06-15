import 'package:go_router/go_router.dart';
import 'package:skill_sharing_platform/presentation/screens/course_detail_screen.dart';
import 'package:skill_sharing_platform/presentation/screens/course_list_screen.dart';
import 'package:skill_sharing_platform/presentation/screens/course_search_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CourseListScreen(),
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) => const CourseSearchScreen(),
        ),
        GoRoute(
          path: 'course/:id',
          builder: (context, state) {
            final id = int.parse(state.params['id']!);
            return CourseDetailScreen(courseId: id);
          },
        ),
      ],
    ),
  ],
);