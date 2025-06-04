import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  Future<void> _sendEmail(BuildContext context) async {
    const email = 'michealprojectteam@gmail.com';
    const subject = 'Help Request - Tafsila App';

    final Uri gmailUrl = Uri.parse(
      'googlegmail://compose?to=$email&subject=$subject',
    );
    final Uri emailUrl = Uri.parse('mailto:$email?subject=$subject');

    try {
      // Try to launch Gmail app first
      if (await canLaunchUrl(gmailUrl)) {
        await launchUrl(gmailUrl);
      }
      // If Gmail app is not available, try default email app
      else if (await canLaunchUrl(emailUrl)) {
        await launchUrl(emailUrl);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please install Gmail app to contact support.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open Gmail. Please make sure Gmail is installed.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

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
          'Help Centre',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildHelpSection(
              'Taking Measurements',
              'To get accurate measurements, wear tight-fitting clothes and stand straight. Follow the on-screen instructions carefully. Make sure you\'re in a well-lit area and have someone help you if possible.',
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              'Size Recommendations',
              'Our app uses advanced algorithms to calculate your perfect size. The recommendations are based on your measurements and standard size charts. For best results, keep your measurements up to date.',
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              'Account & Data',
              'Your data is securely stored and encrypted. You can update your profile information anytime. To delete your data, use the option in your profile settings.',
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              'Technical Issues',
              'If you experience any technical issues, try restarting the app. Make sure you have the latest version installed and your device meets the minimum requirements.',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7B68EE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        color: Color(0xFF7B68EE),
                        size: 32,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Still need help?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Our support team is here to help you',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _sendEmail(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B68EE),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
