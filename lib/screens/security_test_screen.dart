import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../models/security_question.dart';
import '../data/security_test_data.dart';

class SecurityTestScreen extends StatefulWidget {
  const SecurityTestScreen({super.key});

  @override
  State<SecurityTestScreen> createState() => _SecurityTestScreenState();
}

class _SecurityTestScreenState extends State<SecurityTestScreen> {
  final Map<String, int> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[SecurityTestData.questions[_currentQuestionIndex].id] =
          answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < SecurityTestData.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitTest() {
    int correctAnswers = 0;
    for (int i = 0; i < SecurityTestData.questions.length; i++) {
      final question = SecurityTestData.questions[i];
      if (_answers[question.id] == question.correctAnswerIndex) {
        correctAnswers++;
      }
    }

    final score =
        (correctAnswers / SecurityTestData.questions.length * 100).round();
    final result = SecurityTestResult.fromScore(score);

    context.go(
        '${AppConstants.securityTestResultRoute}?score=$score&category=${result.category}&recommendation=${Uri.encodeComponent(result.recommendation)}');
  }

  SecurityQuestion get _currentQuestion =>
      SecurityTestData.questions[_currentQuestionIndex];

  bool get _isFirstQuestion => _currentQuestionIndex == 0;

  bool get _isLastQuestion =>
      _currentQuestionIndex == SecurityTestData.questions.length - 1;

  bool get _hasAnswer => _answers.containsKey(_currentQuestion.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                      const Expanded(
                        child: Text(
                          'Security test',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Image.asset(
                    'assets/images/img_test.png',
                    fit: BoxFit.contain,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: (_currentQuestionIndex + 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3C69FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: SecurityTestData.questions.length -
                              (_currentQuestionIndex + 1),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '${_currentQuestion.id}. ${_currentQuestion.question}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children:
                    _currentQuestion.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected =
                          _answers[_currentQuestion.id] == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(index),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? CupertinoIcons.checkmark_square_fill
                                    : CupertinoIcons.square,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${String.fromCharCode(65 + index)}. $option',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.9),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      if (!_isFirstQuestion)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _previousQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.buttonRadius),
                                side: const BorderSide(
                                    color: Colors.white, width: 1),
                              ),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      if (!_isFirstQuestion) const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hasAnswer
                              ? (_isLastQuestion ? _submitTest : _nextQuestion)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _hasAnswer
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            foregroundColor:
                                _hasAnswer ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.buttonRadius),
                            ),
                          ),
                          child: Text(
                            _isLastQuestion ? 'Send' : 'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
