import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/user_data.dart';
import 'camera.dart';
import '../main.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  int _selectedIndex = 1;

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.copy, color: Color(0xFF7B68EE)),
                  title: const Text('Copy Measurements'),
                  onTap: () {
                    _copyMeasurements();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Clear Measurements'),
                  onTap: () {
                    Navigator.pop(context);
                    _clearMeasurements();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _copyMeasurements() {
    if (UserData.measurements != null) {
      final measurementsText = '''
Body Measurements:
Bust: ${UserData.measurements!['chestCircumference']?.toStringAsFixed(1)} cm
Waist: ${UserData.measurements!['waistCircumference']?.toStringAsFixed(1)} cm
Hips: ${UserData.measurements!['hipCircumference']?.toStringAsFixed(1)} cm
Shoulders: ${UserData.measurements!['shoulderWidth']?.toStringAsFixed(1)} cm
Arm Length: ${UserData.measurements!['armLength']?.toStringAsFixed(1)} cm
Inseam: ${UserData.measurements!['inseam']?.toStringAsFixed(1)} cm

Recommended Sizes:
T-shirt: ${UserData.clothingSizes?['t_shirt']?['size']} (${UserData.clothingSizes?['t_shirt']?['fit']})
Shirt: ${UserData.clothingSizes?['shirt']?['size']} (${UserData.clothingSizes?['shirt']?['fit']})
Jacket: ${UserData.clothingSizes?['jacket']?['size']} (${UserData.clothingSizes?['jacket']?['fit']})
Pants: ${UserData.clothingSizes?['pants']?['size']} (${UserData.clothingSizes?['pants']?['fit']})
''';
      Clipboard.setData(ClipboardData(text: measurementsText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Measurements copied to clipboard')),
      );
    }
  }

  void _clearMeasurements() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Measurements'),
            content: const Text(
              'Are you sure you want to clear all measurements?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  UserData.clearMeasurements();
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

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
            onPressed: _navigateToCamera,
          ),
          if (UserData.measurements != null)
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () => _showOptionsMenu(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (UserData.measurements == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(
                      'lib/assets/images/measurement.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No measurements yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Take your first measurement',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _navigateToCamera,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B68EE),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Scan Your Size',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              const Text(
                'Body Measurements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildMeasurementCard([
                _buildMeasurement(
                  'Bust',
                  UserData.measurements!['chestCircumference'],
                ),
                _buildMeasurement(
                  'Waist',
                  UserData.measurements!['waistCircumference'],
                ),
                _buildMeasurement(
                  'Hips',
                  UserData.measurements!['hipCircumference'],
                ),
                _buildMeasurement(
                  'Shoulders',
                  UserData.measurements!['shoulderWidth'],
                ),
                _buildMeasurement(
                  'Arm Length',
                  UserData.measurements!['armLength'],
                ),
                _buildMeasurement('Inseam', UserData.measurements!['inseam']),
              ]),
              const SizedBox(height: 24),
              const Text(
                'Recommended Sizes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSizesGrid(),
              const SizedBox(height: 16), // Add bottom padding
            ],
          ],
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
            } else if (index == 2) {
              _navigateToCamera();
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

  Widget _buildMeasurementCard(List<Widget> measurements) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: measurements),
    );
  }

  Widget _buildMeasurement(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value != null ? '${value.toStringAsFixed(1)} cm' : '-- cm',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSizesGrid() {
    if (UserData.clothingSizes == null) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 16) / 2;
        final cardHeight = 120.0;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildSizeCard(
              'T-shirt',
              UserData.clothingSizes!['t_shirt'],
              cardWidth,
              cardHeight,
            ),
            _buildSizeCard(
              'Shirt',
              UserData.clothingSizes!['shirt'],
              cardWidth,
              cardHeight,
            ),
            _buildSizeCard(
              'Jacket',
              UserData.clothingSizes!['jacket'],
              cardWidth,
              cardHeight,
            ),
            _buildSizeCard(
              'Pants',
              UserData.clothingSizes!['pants'],
              cardWidth,
              cardHeight,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSizeCard(
    String type,
    Map<String, String>? sizeInfo,
    double width,
    double height,
  ) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const Spacer(),
          Text(
            sizeInfo?['size'] ?? '--',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            sizeInfo?['fit'] ?? '--',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
