import 'package:flutter/material.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // الصفحة الأولى (من اليسار)
              WelcomePage(
                title: 'Your Perfect\nFit, Every Time',
                image: 'measurement.png',
                currentPage: 0,
                totalPages: 3,
                buttonText: 'Next',
                showSkip: true,
                showBack: false,
                onNextPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              // الصفحة الثانية (في الوسط)
              WelcomePage(
                title: 'Scan for\naccurate size',
                image: 'body-check.png',
                currentPage: 1,
                totalPages: 3,
                buttonText: 'Next',
                showSkip: true,
                showBack: true,
                onNextPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                onBackPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              // الصفحة الثالثة (من اليمين)
              WelcomePage(
                title: 'For the Best\nResults',
                image: 't-shirt.png',
                currentPage: 2,
                totalPages: 3,
                buttonText: 'Get started',
                showSkip: false,
                showBack: true,
                onNextPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                onBackPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String title;
  final String image;
  final String buttonText;
  final VoidCallback onNextPressed;
  final VoidCallback? onBackPressed;
  final int currentPage;
  final int totalPages;
  final bool showSkip;
  final bool showBack;

  const WelcomePage({
    Key? key,
    required this.title,
    required this.image,
    required this.buttonText,
    required this.onNextPressed,
    this.onBackPressed,
    required this.currentPage,
    required this.totalPages,
    required this.showSkip,
    required this.showBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back and skip buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: onBackPressed,
                  )
                else
                  const SizedBox(width: 48),
                if (showSkip)
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Text(
                          'skip',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          'lib/assets/images/fast-forward.png',
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            // Image
            Expanded(
              child: Center(
                child: Image.asset(
                  'lib/assets/images/$image',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalPages,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentPage == index
                            ? const Color(0xFF7B68EE)
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Next/Get Started button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B68EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
