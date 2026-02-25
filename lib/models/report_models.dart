class ReportPoint {
  final double x;
  final double y;

  const ReportPoint(this.x, this.y);
}

class ReportSummary {
  final String title;
  final String value;
  final String subtitle;

  const ReportSummary({
    required this.title,
    required this.value,
    required this.subtitle,
  });
}
