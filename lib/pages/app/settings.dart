import 'package:flutter/material.dart';
import '../legal/terms.dart';
import '../legal/privacy.dart';
import '../legal/cookies.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Voice
  bool _voiceEnabled = true;
  bool _continuousListening = false;
  double _speechRate = 1.0;
  String _voiceGender = 'Female';

  // Language
  String _language = 'English';

  // Account
  bool _notifications = true;

  // API
  final _aiKeyCtrl = TextEditingController();
  final _voiceKeyCtrl = TextEditingController();
  final _visionKeyCtrl = TextEditingController();
  bool _showKeys = false;

  @override
  void dispose() {
    _aiKeyCtrl.dispose();
    _voiceKeyCtrl.dispose();
    _visionKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Voice'),
          SwitchListTile(
            title: const Text('Enable Voice'),
            subtitle: const Text('Allow AI tutor to speak responses'),
            value: _voiceEnabled,
            onChanged: (v) => setState(() => _voiceEnabled = v),
          ),
          SwitchListTile(
            title: const Text('Continuous Listening'),
            subtitle: const Text('Stay active between responses'),
            value: _continuousListening,
            onChanged: _voiceEnabled ? (v) => setState(() => _continuousListening = v) : null,
          ),
          ListTile(
            title: const Text('Speech Rate'),
            subtitle: Slider(
              value: _speechRate,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              label: '${_speechRate.toStringAsFixed(1)}x',
              onChanged: _voiceEnabled ? (v) => setState(() => _speechRate = v) : null,
            ),
            trailing: Text('${_speechRate.toStringAsFixed(1)}x'),
          ),
          ListTile(
            title: const Text('Voice Gender'),
            trailing: DropdownButton<String>(
              value: _voiceGender,
              underline: const SizedBox(),
              items: ['Female', 'Male', 'Neutral']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: _voiceEnabled ? (v) => setState(() => _voiceGender = v!) : null,
            ),
          ),
          _SectionHeader('Language'),
          ListTile(
            title: const Text('App Language'),
            subtitle: const Text('Language for UI and AI responses'),
            trailing: DropdownButton<String>(
              value: _language,
              underline: const SizedBox(),
              items: ['English', 'Spanish', 'French', 'Arabic', 'German']
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => setState(() => _language = v!),
            ),
          ),
          _SectionHeader('Account'),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Learning reminders and updates'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          _SectionHeader('API Configuration'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('API Keys', style: Theme.of(context).textTheme.bodySmall),
                TextButton.icon(
                  onPressed: () => setState(() => _showKeys = !_showKeys),
                  icon: Icon(_showKeys ? Icons.visibility_off : Icons.visibility, size: 16),
                  label: Text(_showKeys ? 'Hide' : 'Show'),
                ),
              ],
            ),
          ),
          _ApiKeyTile(label: 'AI Tutor API Key', controller: _aiKeyCtrl, obscure: !_showKeys),
          _ApiKeyTile(label: 'Voice API Key', controller: _voiceKeyCtrl, obscure: !_showKeys),
          _ApiKeyTile(label: 'Vision API Key', controller: _visionKeyCtrl, obscure: !_showKeys),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: () {},
              child: const Text('Save API Keys'),
            ),
          ),
          _SectionHeader('About'),
          const ListTile(title: Text('Version'), trailing: Text('1.0.0')),
          const ListTile(title: Text('Platform'), trailing: Text('Compass')),
          _SectionHeader('Legal'),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage())),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPage())),
          ),
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: const Text('Cookie Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CookiesPage())),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ApiKeyTile extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  const _ApiKeyTile({required this.label, required this.controller, required this.obscure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
