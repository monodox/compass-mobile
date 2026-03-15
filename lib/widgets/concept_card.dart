import 'package:flutter/material.dart';

class ConceptCard extends StatelessWidget {
  final String title;
  final String subject;
  final String? summary;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool saved;

  const ConceptCard({
    super.key,
    required this.title,
    required this.subject,
    this.summary,
    this.icon,
    this.onTap,
    this.saved = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon ?? Icons.lightbulb_outline, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    Text(subject,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    if (summary != null) ...[
                      const SizedBox(height: 4),
                      Text(summary!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              Icon(
                saved ? Icons.bookmark : Icons.bookmark_outline,
                color: saved ? cs.primary : cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
