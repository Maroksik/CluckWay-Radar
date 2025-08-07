import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';

class SecurityTestResultScreen extends StatelessWidget {
  const SecurityTestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final params = GoRouterState.of(context).uri.queryParameters;
    final score = int.tryParse(params['score'] ?? '0') ?? 0;
    final category = params['category'] ?? 'unknown';
    final recommendation =
    Uri.decodeComponent(params['recommendation'] ?? '');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(_getCategoryIcon(category)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          '$score%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _getCategoryTitle(category),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getCategoryDescription(category),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: const [
                      Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Recommendation:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recommendation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/ic_bluetooth.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.go(AppConstants.securityTestRoute),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.buttonRadius),
                        ),
                      ),
                      child: const Text(
                        'Try again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppConstants.menuRoute),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.buttonRadius),
                        ),
                      ),
                      child: const Text(
                        'Return to main',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryTitle(String category) {
    switch (category.toLowerCase()) {
      case 'low':
        return 'Low level of security';
      case 'average':
        return 'Average level of security';
      case 'high':
        return 'Excellent level of security';
      default:
        return 'Unknown level';
    }
  }

  String _getCategoryDescription(String category) {
    switch (category.toLowerCase()) {
      case 'low':
        return 'Your knowledge of device security is not yet sufficient. You may accidentally become a victim of hacking, viruses, or data theft.';
      case 'average':
        return 'You understand the importance of digital hygiene, but you skip some important steps. This can leave loopholes for threats.';
      case 'high':
        return 'Your knowledge is at a high level, and you clearly care about your digital safety.';
      default:
        return 'Unable to determine your security level.';
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'low':
        return 'assets/images/ic_low_result.png';
      case 'average':
        return 'assets/images/ic_mid_result.png';
      case 'high':
        return 'assets/images/ic_high_result.png';
      default:
        return 'assets/images/ic_low_result.png';
    }
  }
}