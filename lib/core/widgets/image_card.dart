import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String? imagePath;
  final String fallbackEmoji;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ImageCard({
    super.key,
    this.imagePath,
    required this.fallbackEmoji,
    required this.label,
    required this.color,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text(
                  fallbackEmoji,
                  style: const TextStyle(fontSize: 60),
                ),
              )
            else
              Text(fallbackEmoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
