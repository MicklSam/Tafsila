import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: March 15, 2024',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 24),
            Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Body measurements\n• Height and weight\n• Camera data during measurement process',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• To provide accurate size recommendations\n• To improve our measurement algorithms\n• To enhance user experience',
              style: TextStyle(fontSize: 16),
            ),
            // Add more privacy policy content as needed
          ],
        ),
      ),
    );
  }
}
