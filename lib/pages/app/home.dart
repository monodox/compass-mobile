import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _WelcomeHeader(cs: cs),
            const SizedBox(height: 24),
            _StartVoiceButton(),
            const SizedBox(height: 28),
            _QuickActions(),
            const SizedBox(height: 28),
            _RecommendedTopics(cs: cs),
            const SizedBox(height: 28),
            _RecentSessions(cs: cs),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final ColorScheme cs;
  const _WelcomeHeader({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.science, color: cs.primary, size: 32),
            const SizedBox(width: 10),
            Text('ThinkLab',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Your interactive AI learning platform. Ask anything, learn everything.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StartVoiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        // Navigate to Voice Lab
        DefaultTabController.of(context);
      },
      icon: const Icon(Icons.mic, size: 22),
      label: const Text('Start Voice Session'),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.school_outlined, 'Start Learning'),
      (Icons.image_outlined, 'Upload Diagram'),
      (Icons.history, 'Review History'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: actions
              .map((a) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _QuickActionCard(icon: a.$1, label: a.$2),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickActionCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: cs.primary),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedTopics extends StatelessWidget {
  final ColorScheme cs;
  const _RecommendedTopics({required this.cs});

  @override
  Widget build(BuildContext context) {
    final topics = [
      (Icons.blur_on, 'Quantum Science'),
      (Icons.bolt, 'Physics Fundamentals'),
      (Icons.computer, 'Quantum Computing'),
      (Icons.biotech, 'Biology'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended Topics', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics
              .map((t) => ActionChip(
                    avatar: Icon(t.$1, size: 16, color: cs.primary),
                    label: Text(t.$2),
                    onPressed: () {},
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _RecentSessions extends StatelessWidget {
  final ColorScheme cs;
  const _RecentSessions({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Sessions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _SessionTile(
          icon: Icons.history,
          title: 'No sessions yet',
          subtitle: 'Start a voice session to begin learning',
          cs: cs,
          isEmpty: true,
        ),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme cs;
  final bool isEmpty;
  const _SessionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cs,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: isEmpty ? cs.onSurfaceVariant : cs.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isEmpty ? null : const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: isEmpty ? null : () {},
      ),
    );
  }
}
