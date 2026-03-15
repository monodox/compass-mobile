import 'package:flutter/material.dart';

class LegalSection extends StatelessWidget {
  final String title;
  final String body;
  const LegalSection(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.primary)),
          const SizedBox(height: 6),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class LegalLastUpdated extends StatelessWidget {
  final String date;
  const LegalLastUpdated(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text('Last updated: $date',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
    );
  }
}
