import 'package:flutter/material.dart';
import '../utils/user_data.dart';
import 'camera.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // For the bottom navigation bar
  Map<String, TextEditingController> _controllers = {};
  Map<String, bool> _isEditing = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = {
      'Mohammed Ibrahim': 'Mohammed Ibrahim',
      'Mohammedibrahim22@gmail.com': 'Mohammedibrahim22@gmail.com',
      'M3325': 'M3325',
      'Password': 'Password',
      'Height': UserData.userHeight?.toString() ?? '170',
      'Weight': UserData.userWeight?.toString() ?? '70',
    };

    fields.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
      _isEditing[key] = false;
    });
  }

  void _saveField(String field, String value) {
    switch (field) {
      case 'Height':
        UserData.userHeight = double.tryParse(value);
        break;
      case 'Weight':
        UserData.userWeight = double.tryParse(value);
        break;
    }
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
  void dispose() {
    // Clean up controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getDisplayText(String key, String value) {
    if (key == 'Height') {
      return '${_controllers[key]?.text ?? value} cm';
    } else if (key == 'Weight') {
      return '${_controllers[key]?.text ?? value} kg';
    }
    return _controllers[key]?.text ?? value;
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
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'lib/assets/images/kids-playing-soccer-stockcake.jpg',
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mohammed Ibrahim',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Text(
              'M3325',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Personal Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Personal info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildEditableField('Mohammed Ibrahim'),
                  _buildEditableField('Mohammedibrahim22@gmail.com'),
                  _buildEditableField('M3325'),
                  _buildEditableField('Password', isPassword: true),
                  _buildEditableField('Height'),
                  _buildEditableField('Weight'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Delete Account Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/signup',
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Delete my account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/signin',
                    (Route<dynamic> route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/measurements');
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

  Widget _buildEditableField(String value, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                _isEditing[value] == true
                    ? SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _controllers[value],
                        obscureText: isPassword,
                        keyboardType:
                            value == 'Height' || value == 'Weight'
                                ? TextInputType.number
                                : TextInputType.text,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          suffixText:
                              value == 'Height'
                                  ? 'cm'
                                  : value == 'Weight'
                                  ? 'kg'
                                  : null,
                          suffixStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    : Text(
                      isPassword ? '••••••••' : _getDisplayText(value, value),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'lib/assets/images/pen.png',
              width: 20,
              height: 20,
              color: const Color(0xFF7B68EE),
            ),
            onPressed: () {
              setState(() {
                _isEditing[value] = !(_isEditing[value] ?? false);
                if (_isEditing[value] == false) {
                  // Save the value when done editing
                  _saveField(value, _controllers[value]?.text ?? '');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
