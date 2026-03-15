import 'package:flutter/material.dart';
import 'legal_widgets.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LegalSection('1. Information We Collect',
              'We collect data you provide directly (e.g. voice input, uploaded images) and usage data (e.g. session history, topics explored).'),
          LegalSection('2. How We Use Your Data',
              'Your data is used to power the AI tutor, personalize learning sessions, and improve the platform. We do not sell your data to third parties.'),
          LegalSection('3. Voice & Audio',
              'Voice input is processed in real time to generate AI responses. Audio is not stored permanently unless you explicitly save a session.'),
          LegalSection('4. Images',
              'Images uploaded to Visual Lab are sent to our Vision API for analysis and are not stored after the session ends.'),
          LegalSection('5. Data Retention',
              'Session history and saved concepts are stored locally on your device. Cloud sync, if enabled, is encrypted in transit.'),
          LegalSection('6. Third-Party Services',
              'ThinkLab uses third-party APIs (AI, Voice, Vision). These services have their own privacy policies which we encourage you to review.'),
          LegalSection('7. Your Rights',
              'You may delete your learning history and saved data at any time from the Memory page. Contact us to request full data deletion.'),
          LegalSection('8. Contact', 'Privacy questions: privacy@thinklab.app'),
          LegalLastUpdated('March 2026'),
        ],
      ),
    );
  }
}
