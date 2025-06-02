import 'package:flutter/material.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  int _selectedIndex = 1; // For the bottom navigation bar
  bool _showOptions = false;

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
          'My Measurements',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'lib/assets/images/scan (1).png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Handle scan action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Key Measurements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  // Handle menu item selection
                                },
                                itemBuilder:
                                    (context) => [
                                      const PopupMenuItem(
                                        value: 'copy',
                                        child: Row(
                                          children: [
                                            Icon(Icons.copy, size: 20),
                                            SizedBox(width: 8),
                                            Text('Copy'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        'Last Updated: May 28, 2023',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementRow('Bust', '[XX cm/in]'),
                      _buildMeasurementRow('Waist', '[XX cm/in]'),
                      _buildMeasurementRow('Hips', '[XX cm/in]'),
                      _buildMeasurementRow('Inseam', '[XX cm/in]'),
                      _buildMeasurementRow('Shoulders', '[XX cm/in]'),
                      _buildMeasurementRow('Arm Length', '[XX cm/in]'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Recommended Sizes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildSizeCard('Fit scan size', 'M'),
              const SizedBox(height: 8),
              _buildSizeCard('relaxed fit', 'L'),
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
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/profile');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/history');
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
                    // Handle scan action
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

  Widget _buildMeasurementRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSizeCard(String label, String size) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
