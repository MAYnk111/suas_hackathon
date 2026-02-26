import 'package:flutter/material.dart';

class CrashSafeImage extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CrashSafeImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (path == null || path!.isEmpty) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported),
        );
      }

      return Image.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image),
          );
        },
      );
    } catch (_) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.error),
      );
    }
  }
}
