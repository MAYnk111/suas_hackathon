/// Fetus evolution month-wise image mapper
/// Maps pregnancy month (1-9) to fetus development image assets

const Map<int, String> fetusImageMap = {
  1: "assets/images/fetus_m1.png",
  2: "assets/images/fetus_m2.png",
  3: "assets/images/fetus_m3.png",
  4: "assets/images/fetus_m4.png",
  5: "assets/images/fetus_m5.png",
  6: "assets/images/fetus_m6.png",
  7: "assets/images/fetus_m7.png",
  8: "assets/images/fetus_m8.png",
  9: "assets/images/fetus_m9.png",
};

/// Get fetus image path for a specific pregnancy month
/// Returns default image if month is invalid or image not found
String getFetusImage(int month) {
  final imagePath = fetusImageMap[month] ?? "assets/images/default.png";
  // Debug log
  // ignore: avoid_print
  print("🔍 Fetus month => $month");
  // ignore: avoid_print
  print("📸 Image path => $imagePath");
  return imagePath;
}
