import 'package:flutter/material.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      body: const Center(
        child: Text('Stores Screen'),
      ),
    );
  }
}