import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../utils/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'FIND LOST DEVICE',
      imagePath: 'assets/images/img_onboarding_1.png',
    ),
    OnboardingPage(
      title: 'PRECISE DISTANCE',
      imagePath: 'assets/images/img_onboarding_2.png',
    ),
    OnboardingPage(
      title: 'NEVER LOSE AGAIN',
      imagePath: 'assets/images/img_onboarding_3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryGradientStart,
              AppConstants.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _buildPage(_pages[i]),
                ),
              ),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Text(
          page.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Image.asset(
            page.imagePath,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_currentPage < _pages.length - 1) {
              _pageController.nextPage(
                duration: AppConstants.animationDuration,
                curve: Curves.easeInOut,
              );
            } else {
              await StorageService.setOnboardingSeen(true);
              if (mounted) context.go(AppConstants.menuRoute);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.buttonColor,
            foregroundColor: AppConstants.buttonTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
          ),
          child: Text(
            _currentPage < _pages.length - 1 ? 'Next' : 'Start',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String imagePath;

  OnboardingPage({required this.title, required this.imagePath});
}