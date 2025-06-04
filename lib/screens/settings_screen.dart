import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: const Text(
          'Setting',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      'Privacy Policy',
                      () => Navigator.pushNamed(context, '/privacy-policy'),
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      context,
                      'Terms of Service',
                      () => Navigator.pushNamed(context, '/terms'),
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      context,
                      'About app',
                      () => Navigator.pushNamed(context, '/about'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      'Help centre',
                      () => Navigator.pushNamed(context, '/help'),
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      context,
                      'Suggestions',
                      () => Navigator.pushNamed(context, '/suggestions'),
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

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
