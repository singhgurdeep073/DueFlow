import 'package:flutter/material.dart';

// Entry point
void main() {
  runApp(const MyApp());
}


// Root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart to Flutter',
      home: const HomePage(),
    );
  }
}

// Home Screen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables
    int age = 21;
    double height = 5.9;
    String name = 'Gurdeep';
    bool isDeveloper = true;

    List<String> skills = ['Flutter', 'Dart', 'API'];

    Map<String, dynamic> profile = {
      'name': name,
      'age': age,
      'skills': skills,
    };

    // Console prints (same as Dart)
    print('Hello, Dart!');
    print('Profile: $profile');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Basics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Height: $height'),
            Text('Developer: $isDeveloper'),
            const SizedBox(height: 10),
            Text('Skills: ${skills.join(', ')}'),
            const SizedBox(height: 10),
            Text(
              age >= 18 ? 'You are an adult' : 'You are under 18',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                greet(name);
              },
              child: const Text('Greet'),
            ),
          ],
        ),
      ),
    );
  }
}

// Function
void greet(String name) {
  print('Welcome, $name 👋');
}
