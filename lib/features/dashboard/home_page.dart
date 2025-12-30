import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/landing_page.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String role;

  const HomePage({super.key, required this.name, required this.role});

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
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: role == 'admin' ? Colors.red[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: role == 'admin' ? Colors.red : Colors.blue,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      role == 'admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      size: 18,
                      color: role == 'admin' ? Colors.red : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      role == 'admin' ? 'Admin' : 'User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: role == 'admin' ? Colors.red : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
