import 'package:flutter/material.dart';
import '../utils/user_data.dart';
import 'camera.dart';
import '../main.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 3; // For the bottom navigation bar
  Map<int, bool> _expandedItems = {
    0: true,
    1: false,
    2: false,
  }; // Track expanded state of entries

  void _navigateToCamera() {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Text(
          'Measurement History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMeasurementEntry(
                index: 0,
                title: 'Measurement Entry 1',
                date: 'May 28, 2025',
                time: '09:15 AM',
                size: 'M',
              ),
              const SizedBox(height: 8),
              _buildMeasurementEntry(
                index: 1,
                title: 'Measurement Entry 2',
                date: 'May 28, 2025',
                time: '',
                size: '',
              ),
              const SizedBox(height: 8),
              _buildMeasurementEntry(
                index: 2,
                title: 'Measurement Entry 3',
                date: 'May 28, 2025',
                time: '',
                size: '',
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
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/measurements');
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

  Widget _buildMeasurementEntry({
    required int index,
    required String title,
    required String date,
    required String time,
    required String size,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _expandedItems[index] == true
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _expandedItems[index] =
                              !(_expandedItems[index] ?? false);
                        });
                      },
                    ),
                  ],
                ),
                if (_expandedItems[index] == true) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'General Size',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B68EE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/measurements');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F0FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Details',
                          style: TextStyle(
                            color: Color(0xFF7B68EE),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF7B68EE),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
