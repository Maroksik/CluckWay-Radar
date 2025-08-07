import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openPrivacyPolicy() async {
    const url = 'file://assets/html/privacy_policy.html';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go(AppConstants.menuRoute),
                      icon: Image.asset(
                        'assets/images/ic_arrow_back.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                Expanded(
                  child: Column(
                    children: [
                      _buildSettingsButton(
                        context,
                        title: 'Search for devices',
                        onTap: () => context.go(AppConstants.searchRoute),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildSettingsButton(
                        context,
                        title: 'Device security tips',
                        onTap: () => context.go(AppConstants.securityTipsRoute),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildSettingsButton(
                        context,
                        title: 'Security test',
                        onTap: () => context.go(AppConstants.securityTestRoute),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildSettingsButton(
                        context,
                        title: 'Privacy Policy',
                        onTap: _openPrivacyPolicy,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildSettingsButton(
                        context,
                        title: 'Exit',
                        onTap: _exitApp,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
} 