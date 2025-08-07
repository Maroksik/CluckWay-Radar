import '../models/security_tip.dart';

class SecurityTipsData {
  static final List<SecurityTip> tips = [
    SecurityTip(
      id: '1',
      title: 'Strong password and 2FA',
      preview: 'A password is the first line of defense for your device and all the data on it. However, millions of users still use simple combinations like \'123456\' or \'qwerty\'. This makes their devices an easy target for hackers.',
      content: '''A password is the first line of defense for your device and all the data on it. However, millions of users still use simple combinations like '123456' or 'qwerty'. This makes their devices an easy target for hackers.

What to do:
• Create a unique, long password that contains letters, numbers, and symbols.
• Don't use the same passwords for different services.
• Be sure to enable two-factor authentication (2FA), especially for banking, email, and cloud services. This means that you will need not only a password, but also a code from an SMS or an app like Google Authenticator to log in.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_1.png',
    ),
    SecurityTip(
      id: '2',
      title: 'Update your system and apps',
      preview: 'Many people put off updates, considering their inconvenience. However, updates often contain important security patches that protect against new threats.',
      content: '''Many people put off updates, considering their inconvenience. However, updates often contain important security patches that protect against new threats.

What to do:
• Enable automatic updates for your operating system and apps.
• Regularly check for updates manually if automatic updates are disabled.
• Don't ignore update notifications - they often contain critical security fixes.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_2.png',
    ),
    SecurityTip(
      id: '3',
      title: 'Download only from official sources',
      preview: 'Third-party sites and unofficial app stores are the main source of malicious software. They may offer free versions of paid apps, but the risk is not worth it.',
      content: '''Third-party sites and unofficial app stores are the main source of malicious software. They may offer free versions of paid apps, but the risk is not worth it.

What to do:
• Download apps only from official app stores (Google Play Store, Apple App Store).
• Avoid third-party app stores and unofficial websites.
• Be cautious of apps that promise free versions of paid software.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_3.png',
    ),
    SecurityTip(
      id: '4',
      title: 'Check app permissions',
      preview: 'Some apps ask for access to your microphone, camera, contacts, and other sensitive data. Always question whether the app really needs these permissions.',
      content: '''Some apps ask for access to your microphone, camera, contacts, and other sensitive data. Always question whether the app really needs these permissions.

What to do:
• Review app permissions before installing.
• Revoke unnecessary permissions for already installed apps.
• Be especially careful with apps that request access to contacts, camera, or microphone.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_4.png',
    ),
    SecurityTip(
      id: '5',
      title: 'Screen lock is a must',
      preview: 'Your device is a mini-computer with a bank, personal photos, messages, and other sensitive information. A screen lock is the simplest but most effective protection.',
      content: '''Your device is a mini-computer with a bank, personal photos, messages, and other sensitive information. A screen lock is the simplest but most effective protection.

What to do:
• Set up a strong PIN, password, or biometric lock (fingerprint/face recognition).
• Use a pattern lock only if it's complex and not easily guessable.
• Never leave your device unlocked in public places.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_5.png',
    ),
    SecurityTip(
      id: '6',
      title: 'Open Wi-Fi is a security threat',
      preview: 'Free Wi-Fi in cafes, hotels or shopping malls may seem convenient, but it\'s often unsecured and can be easily intercepted by hackers.',
      content: '''Free Wi-Fi in cafes, hotels or shopping malls may seem convenient, but it's often unsecured and can be easily intercepted by hackers.

What to do:
• Avoid accessing sensitive information (banking, email) on public Wi-Fi.
• Use a VPN when connecting to public networks.
• Turn off automatic Wi-Fi connection to avoid connecting to malicious networks.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_6.png',
    ),
    SecurityTip(
      id: '7',
      title: 'VPN: one-touch protection',
      preview: 'VPN (Virtual Private Network) is a secure "tunnel" through which your data travels, protecting it from interception and tracking.',
      content: '''VPN (Virtual Private Network) is a secure "tunnel" through which your data travels, protecting it from interception and tracking.

What to do:
• Use a reputable VPN service for sensitive activities.
• Enable VPN when using public Wi-Fi networks.
• Choose VPN providers that don't log your activity.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_7.png',
    ),
    SecurityTip(
      id: '8',
      title: 'Making backup copies of your data',
      preview: 'Imagine that your device is lost, stolen or no longer turns on. All photos, contacts, and important documents will disappear forever.',
      content: '''Imagine that your device is lost, stolen or no longer turns on. All photos, contacts, and important documents will disappear forever.

What to do:
• Regularly backup your data to cloud storage or external drives.
• Enable automatic backups for photos and important documents.
• Test your backups periodically to ensure they work.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_8.png',
    ),
    SecurityTip(
      id: '9',
      title: 'Don\'t leave your device unattended',
      preview: 'Many threats come not from the Internet, but from real life. Leaving your device unattended even for a minute can lead to data theft.',
      content: '''Many threats come not from the Internet, but from real life. Leaving your device unattended even for a minute can lead to data theft.

What to do:
• Never leave your device unattended in public places.
• Use a screen lock with a short timeout period.
• Be especially careful in cafes, libraries, and public transport.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_9.png',
    ),
    SecurityTip(
      id: '10',
      title: 'Be careful with QR codes',
      preview: 'QR codes have become part of everyday life: menus in cafes, links to websites, payment systems. But they can also be dangerous.',
      content: '''QR codes have become part of everyday life: menus in cafes, links to websites, payment systems. But they can also be dangerous.

What to do:
• Don't scan QR codes from unknown sources.
• Check the URL before opening links from QR codes.
• Be especially careful with QR codes that promise free services or prizes.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_10.png',
    ),
    SecurityTip(
      id: '11',
      title: 'Use encrypted messaging',
      preview: 'Regular SMS and some messaging apps can be intercepted. Use apps with end-to-end encryption for sensitive conversations.',
      content: '''Regular SMS and some messaging apps can be intercepted. Use apps with end-to-end encryption for sensitive conversations.

What to do:
• Use messaging apps with end-to-end encryption (Signal, WhatsApp, Telegram).
• Avoid sending sensitive information via regular SMS.
• Verify that encryption is enabled in your messaging app.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_11.png',
    ),
    SecurityTip(
      id: '12',
      title: 'Monitor your accounts regularly',
      preview: 'Regular monitoring helps you detect unauthorized activity early and prevent serious consequences.',
      content: '''Regular monitoring helps you detect unauthorized activity early and prevent serious consequences.

What to do:
• Check your bank statements and credit reports regularly.
• Monitor your email and social media accounts for suspicious activity.
• Set up alerts for unusual account activity.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_12.png',
    ),
    SecurityTip(
      id: '13',
      title: 'Be cautious with personal information',
      preview: 'Think twice before sharing personal information online. Even seemingly harmless details can be used by attackers.',
      content: '''Think twice before sharing personal information online. Even seemingly harmless details can be used by attackers.

What to do:
• Limit the personal information you share on social media.
• Be careful with online surveys and questionnaires.
• Don't share your full address, phone number, or birth date publicly.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_13.png',
    ),
    SecurityTip(
      id: '14',
      title: 'Use device encryption',
      preview: 'Device encryption protects your data even if your device is lost or stolen by making it unreadable without the correct password.',
      content: '''Device encryption protects your data even if your device is lost or stolen by making it unreadable without the correct password.

What to do:
• Enable device encryption on your smartphone and computer.
• Use strong passwords or biometric authentication.
• Keep your encryption keys secure and backed up.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_14.png',
    ),
    SecurityTip(
      id: '15',
      title: 'Stay informed about threats',
      preview: 'Cybersecurity threats are constantly evolving. Staying informed helps you recognize and avoid new dangers.',
      content: '''Cybersecurity threats are constantly evolving. Staying informed helps you recognize and avoid new dangers.

What to do:
• Follow reputable cybersecurity news sources.
• Learn about new types of attacks and scams.
• Share security knowledge with friends and family.

This approach significantly reduces the risk of hacking and protects your personal data even if your password is leaked.''',
      imagePath: 'assets/images/img_tip_15.png',
    ),
  ];

  static SecurityTip getTipById(String id) {
    return tips.firstWhere((tip) => tip.id == id);
  }

  static int getTipIndex(String id) {
    return tips.indexWhere((tip) => tip.id == id);
  }

  static bool isFirstTip(String id) {
    return getTipIndex(id) == 0;
  }

  static bool isLastTip(String id) {
    return getTipIndex(id) == tips.length - 1;
  }

  static SecurityTip? getPreviousTip(String currentId) {
    final currentIndex = getTipIndex(currentId);
    if (currentIndex > 0) {
      return tips[currentIndex - 1];
    }
    return null;
  }

  static SecurityTip? getNextTip(String currentId) {
    final currentIndex = getTipIndex(currentId);
    if (currentIndex < tips.length - 1) {
      return tips[currentIndex + 1];
    }
    return null;
  }
} 