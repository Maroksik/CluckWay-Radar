class SecurityQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  SecurityQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class SecurityTestResult {
  final int score;
  final String category;
  final String recommendation;

  SecurityTestResult({
    required this.score,
    required this.category,
    required this.recommendation,
  });

  factory SecurityTestResult.fromScore(int score) {
    String category;
    String recommendation;

    if (score >= 80) {
      category = 'high';
      recommendation = 'Keep up the good work, share this knowledge with your loved ones - and you will help make the Internet a little safer for everyone!';
    } else if (score >= 40) {
      category = 'average';
      recommendation = 'Check if you use a VPN, monitor your account logins, and make backups. Even a few improvements will significantly increase your level of protection.';
    } else {
      category = 'low';
      recommendation = 'Review the tips from the \'Device Security Tips\' section and start with simple steps - a strong password, updates, and disabling unnecessary permissions.';
    }

    return SecurityTestResult(
      score: score,
      category: category,
      recommendation: recommendation,
    );
  }
} 