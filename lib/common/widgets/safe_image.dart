import 'package:flutter/material.dart';

/// Safe image loading widget that never crashes
/// Handles null paths, missing files, and format errors gracefully
Widget safeImage(
  String? path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  Key? key,
}) {
  // Debug print to track image path
  print("DEBUG IMAGE PATH => $path");

  // Handle null or empty paths
  if (path == null || path.isEmpty) {
    print("DEBUG IMAGE: Path is null or empty, showing placeholder");
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Attempt to load the image with error handling
  return Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    key: key,
    errorBuilder: (context, error, stackTrace) {
      print("DEBUG IMAGE: Failed to load $path - Error: $error");
      return SizedBox(
        width: width,
        height: height,
        child: Container(
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.broken_image,
            size: 80,
            color: Colors.grey,
          ),
        ),
      );
    },
  );
}

/// Safe decoration image helper for use in Box decorations
/// Returns AssetImage only if path is valid, otherwise returns a fallback
ImageProvider<Object> safeDecorationImage(String? path) {
  print("DEBUG DECORATION IMAGE PATH => $path");

  if (path == null || path.isEmpty) {
    print("DEBUG DECORATION IMAGE: Path is null or empty, using default");
    return const AssetImage("assets/pregnancy/images/default.png");
  }

  return AssetImage(path);
}
