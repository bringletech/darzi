import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:flutter/material.dart';
import 'package:darzi/colors.dart';

class InfoCard extends StatelessWidget {
  final String path;
  final String title;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.path,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive scaling
    final cardWidth = screenWidth * 0.4; // 40% of screen width
    final cardHeight = screenHeight * 0.18; // 18% of screen height
    final imageSize = cardWidth * 0.7; // 70% of card width

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: AppColors.textColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackTextColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                path,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.012),
          TextResPopp(
            FontWeight.w600,
            title,
            screenWidth * 0.035, // Responsive font size
            color: AppColors.ratingBarColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
