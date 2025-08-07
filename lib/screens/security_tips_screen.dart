import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../models/security_tip.dart';
import '../data/security_tips_data.dart';

class SecurityTipsScreen extends StatelessWidget {
  const SecurityTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = SecurityTipsData.tips;

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
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
                    const Text(
                      'Device security tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return _buildTipCard(context, tip, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, SecurityTip tip, int index) {
    final isFirst = index == 0;
    final isLast = index == SecurityTipsData.tips.length - 1;
    
    return Container(
      margin: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: isLast ? 24.0 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: const Color(0xFF291693),
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
          topRight: isFirst ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/tips/${tip.id}'),
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
            topRight: isFirst ? const Radius.circular(12) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(tip.imagePath ?? 'assets/images/img_tip_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.preview,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 