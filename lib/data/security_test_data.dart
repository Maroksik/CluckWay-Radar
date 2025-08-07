import '../models/security_question.dart';

class SecurityTestData {
  static final List<SecurityQuestion> questions = [
    SecurityQuestion(
      id: '1',
      question: 'What is two-factor authentication?',
      options: [
        'Double internet speed',
        'Additional code after entering the password',
        'Connecting two devices',
        'Protection from viruses',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '2',
      question: 'Why is it important to regularly update the system and applications?',
      options: [
        'To make the interface more beautiful',
        'To eliminate security vulnerabilities',
        'To free up memory',
        'This is not necessary',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '3',
      question: 'Where is the safest place to download applications?',
      options: [
        'From official stores, such as the App Store or Google Play',
        'From any site',
        'From links in messengers',
        'From a flash drive',
      ],
      correctAnswerIndex: 0,
    ),
    SecurityQuestion(
      id: '4',
      question: 'Why is it worth checking application permissions?',
      options: [
        'To save battery',
        'So that they work better',
        'To prevent unnecessary access to personal data',
        'It does not matter',
      ],
      correctAnswerIndex: 2,
    ),
    SecurityQuestion(
      id: '5',
      question: 'What method of screen lock is considered safe?',
      options: [
        'Swipe',
        'PIN, pattern or fingerprint',
        'None',
        'Photo',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '6',
      question: 'What is the danger of open Wi-Fi?',
      options: [
        'Low speed',
        'Possibility of interception of your data',
        'Quick battery drain',
        'It requires a password',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '7',
      question: 'What does a VPN do?',
      options: [
        'Speeds up website loading',
        'Encrypts Internet traffic and hides IP',
        'Blocks ads',
        'Closes applications',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '8',
      question: 'What should you do with personal data on your phone before selling it?',
      options: [
        'Delete photos manually',
        'Transfer to the new owner',
        'Reset to factory settings and log out of all accounts',
        'Just remove the SIM card',
      ],
      correctAnswerIndex: 2,
    ),
    SecurityQuestion(
      id: '9',
      question: 'How often should you make backups?',
      options: [
        'Once a year',
        'Only when you change your phone',
        'Regularly, especially before updates or trips',
        'Never',
      ],
      correctAnswerIndex: 2,
    ),
    SecurityQuestion(
      id: '10',
      question: 'Why is it dangerous to leave your device unattended?',
      options: [
        'They can drain the battery',
        'Someone can access personal information',
        'They can call',
        'The device will break',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '11',
      question: 'What can be hidden behind a QR code?',
      options: [
        'Phishing link or malicious file',
        'Wi-Fi only',
        'Nothing dangerous',
        'Advertising',
      ],
      correctAnswerIndex: 0,
    ),
    SecurityQuestion(
      id: '12',
      question: 'Do you need an antivirus on your phone?',
      options: [
        'No, smartphones do not get infected',
        'Sometimes, especially on Android and when installing APK',
        'Only if there is no password',
        'Only on iPhone',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '13',
      question: 'What to do if you receive a strange message with a link?',
      options: [
        'Do not click and delete',
        'Click and view',
        'Reply',
        'Share with friends',
      ],
      correctAnswerIndex: 0,
    ),
    SecurityQuestion(
      id: '14',
      question: 'Why monitor account login activity?',
      options: [
        'To know how many times you have logged in',
        'To notice a hack and respond in time',
        'For statistics',
        'To improve your rating',
      ],
      correctAnswerIndex: 1,
    ),
    SecurityQuestion(
      id: '15',
      question: 'Why use a password manager?',
      options: [
        'To remember your Wi-Fi',
        'To store and create complex passwords securely',
        'To speed up your phone',
        'To share passwords with friends',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  static SecurityQuestion getQuestionById(String id) {
    return questions.firstWhere((question) => question.id == id);
  }

  static int getQuestionIndex(String id) {
    return questions.indexWhere((question) => question.id == id);
  }

  static bool isFirstQuestion(String id) {
    return getQuestionIndex(id) == 0;
  }

  static bool isLastQuestion(String id) {
    return getQuestionIndex(id) == questions.length - 1;
  }

  static SecurityQuestion? getPreviousQuestion(String currentId) {
    final currentIndex = getQuestionIndex(currentId);
    if (currentIndex > 0) {
      return questions[currentIndex - 1];
    }
    return null;
  }

  static SecurityQuestion? getNextQuestion(String currentId) {
    final currentIndex = getQuestionIndex(currentId);
    if (currentIndex < questions.length - 1) {
      return questions[currentIndex + 1];
    }
    return null;
  }
} 