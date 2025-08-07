import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';

import '../data/security_tips_data.dart';

class SecurityTipDetailScreen extends StatelessWidget {
  final String tipId;

  const SecurityTipDetailScreen({super.key, required this.tipId});

  @override
  Widget build(BuildContext context) {
    if (tipId.isEmpty) {
      return _buildErrorScreen(context);
    }

    final tip = SecurityTipsData.getTipById(tipId);
    final isFirst = SecurityTipsData.isFirstTip(tipId);
    final isLast = SecurityTipsData.isLastTip(tipId);
    final currentIndex = SecurityTipsData.getTipIndex(tipId) + 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.go(AppConstants.securityTipsRoute),
                      icon: Image.asset(
                        'assets/images/ic_arrow_back.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(
                                tip.imagePath ?? 'assets/images/img_tip_1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        tip.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: isFirst
                            ? null
                            : () {
                                final previousTip =
                                    SecurityTipsData.getPreviousTip(tipId);
                                if (previousTip != null) {
                                  context.go('/tips/${previousTip.id}');
                                }
                              },
                        icon: Icon(
                          CupertinoIcons.chevron_left,
                          color: isFirst
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.white,
                          size: 24,
                        ),
                      ),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$currentIndex',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: isLast
                            ? null
                            : () {
                                final nextTip =
                                    SecurityTipsData.getNextTip(tipId);
                                if (nextTip != null) {
                                  context.go('/tips/${nextTip.id}');
                                }
                              },
                        icon: Icon(
                          CupertinoIcons.chevron_right,
                          color: isLast
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tip not found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(AppConstants.securityTipsRoute),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Back to Tips'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
