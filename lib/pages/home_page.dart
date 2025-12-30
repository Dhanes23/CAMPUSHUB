import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'landing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LandingPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Login Berhasil!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Selamat datang,',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
