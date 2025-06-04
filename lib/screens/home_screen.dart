import 'package:flutter/material.dart';
import 'camera.dart';
import '../main.dart';
import '../utils/user_data.dart';
import 'signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _navigateToCamera() {
    // Use height and weight from UserData or default values if not set
    final height = UserData.userHeight ?? 170.0;
    final weight = UserData.userWeight ?? 70.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CameraScreen(
              camera: cameras.first,
              userHeight: height,
              userWeight: weight,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with profile and settings
              Row(
                children: [
                  // Profile image and welcome text
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile');
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'lib/assets/images/kids-playing-soccer-stockcake.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Mohammed Ibrah..',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Settings button
                  IconButton(
                    icon: Image.asset(
                      'lib/assets/images/settings.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Main content cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Scan Your Size Card
                      _buildCard(
                        title: 'Scan Your Size',
                        subtitle: 'Measure with Your Camera',
                        color: const Color(0xFF7B68EE),
                        icon: 'diaphragm.png',
                        onTap: _navigateToCamera,
                      ),
                      const SizedBox(height: 16),
                      // My Measurements Card
                      _buildCard(
                        title: 'My Measurements',
                        subtitle: 'Track Your Fit',
                        color: const Color(0xFF00B4D8),
                        icon: 'maximize.png',
                        showArrow: true,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/measurements',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Measurement History Card
                      _buildCard(
                        title: 'Measurement History',
                        subtitle: 'Past Scans, Future Fits',
                        color: const Color(0xFF2FD67B),
                        icon: 'history.png',
                        showArrow: true,
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/history');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {
              Navigator.pushReplacementNamed(context, '/measurements');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/history');
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF7B68EE),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/home.png',
                width: 24,
                height: 24,
                color:
                    _selectedIndex == 0 ? const Color(0xFF7B68EE) : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/wide.png',
                width: 24,
                height: 24,
                color:
                    _selectedIndex == 1 ? const Color(0xFF7B68EE) : Colors.grey,
              ),
              label: 'Sizes',
            ),
            BottomNavigationBarItem(
              icon: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _navigateToCamera();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B68EE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      'lib/assets/images/scan.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/clock.png',
                width: 24,
                height: 24,
                color:
                    _selectedIndex == 3 ? const Color(0xFF7B68EE) : Colors.grey,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/user.png',
                width: 24,
                height: 24,
                color:
                    _selectedIndex == 4 ? const Color(0xFF7B68EE) : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Color color,
    required String icon,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Background icon
            Positioned(
              right: 20,
              bottom: -30,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'lib/assets/images/$icon',
                  width: 120,
                  height: 120,
                  color: Colors.white,
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                if (!showArrow)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Handle scan action
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'lib/assets/images/scan (1).png',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (showArrow)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Handle arrow action
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'lib/assets/images/arrow.png',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
