class SecurityTip {
  final String id;
  final String title;
  final String preview;
  final String content;
  final String? imagePath;

  SecurityTip({
    required this.id,
    required this.title,
    required this.preview,
    required this.content,
    this.imagePath,
  });
} 