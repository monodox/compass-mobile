import 'package:flutter/material.dart';
import 'legal_widgets.dart';

class CookiesPage extends StatefulWidget {
  const CookiesPage({super.key});

  @override
  State<CookiesPage> createState() => _CookiesPageState();
}

class _CookiesPageState extends State<CookiesPage> {
  bool _analytics = true;
  bool _preferences = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LegalSection('What Are Cookies',
              'Cookies and similar local storage mechanisms help Compass remember your preferences and improve your experience.'),
          LegalSection('Essential',
              'Required for the app to function. These cannot be disabled. They store session state and authentication tokens.'),
          LegalSection('Analytics',
              'Help us understand how users interact with Compass so we can improve the platform.'),
          LegalSection('Preference',
              'Remember your settings such as language, voice preferences, and UI configuration.'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Preferences',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.primary)),
                const SizedBox(height: 10),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Analytics Cookies'),
                  value: _analytics,
                  onChanged: (v) => setState(() => _analytics = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Preference Cookies'),
                  value: _preferences,
                  onChanged: (v) => setState(() => _preferences = v),
                ),
                const SizedBox(height: 8),
                FilledButton(onPressed: () {}, child: const Text('Save Preferences')),
              ],
            ),
          ),
          LegalSection('Contact', 'Cookie questions: privacy@compass.app'),
          LegalLastUpdated('March 2026'),
        ],
      ),
    );
  }
}
