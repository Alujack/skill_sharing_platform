import 'package:flutter/material.dart';
import 'api_service.dart';
import './presentation/initial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService('https://fakestoreapi.com/products');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Core(),
    );
  }
}
