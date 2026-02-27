import '../../utils/fetus_image_map.dart' as fetus_map;

/// Helper functions for constructing pregnancy image asset paths
class ImagePathHelper {
  static const String _baseImagePath = 'assets/pregnancy/images';
  static const String _defaultImage = 'default';

  /// Constructs full asset path from image name
  /// 
  /// Example:
  /// ```dart
  /// pregnancyImage('fetus_m1') // returns 'assets/pregnancy/images/fetus_m1.png'
  /// pregnancyImage(null) // returns 'assets/pregnancy/images/default.png'
  /// ```
  static String pregnancyImage(String? name) {
    final imageName = (name != null && name.isNotEmpty) ? name : _defaultImage;
    return '$_baseImagePath/$imageName.png';
  }

  /// Constructs full asset path for fetus image by month
  /// 
  /// Example:
  /// ```dart
  /// fetusImage(1) // returns 'assets/images/fetus_m1.png'
  /// ```
  static String fetusImage(int month) {
    final clampedMonth = month.clamp(1, 9);
    // Use the fetus image map for correct paths
    return fetus_map.getFetusImage(clampedMonth);
  }

  /// Constructs full asset path for logo
  static String get logo => '$_baseImagePath/logo.jpeg';

  /// Default fallback image path
  static String get defaultImage => pregnancyImage(_defaultImage);
}
