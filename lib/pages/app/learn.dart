import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int? _selectedTopic;
  int? _selectedConcept;

  final _topics = const [
    _Topic(
      icon: Icons.blur_on,
      title: 'Quantum Science',
      subtitle: 'Superposition, entanglement & wave functions',
      concepts: ['Superposition', 'Quantum Entanglement', 'Wave-Particle Duality', 'Schrödinger\'s Equation'],
    ),
    _Topic(
      icon: Icons.memory,
      title: 'Quantum Computing',
      subtitle: 'Qubits, gates & quantum algorithms',
      concepts: ['Qubits', 'Quantum Gates', 'Shor\'s Algorithm', 'Quantum Circuits'],
    ),
    _Topic(
      icon: Icons.bolt,
      title: 'Physics Fundamentals',
      subtitle: 'Mechanics, thermodynamics & relativity',
      concepts: ['Newton\'s Laws', 'Special Relativity', 'Thermodynamics', 'Electromagnetism'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: Row(
        children: [
          _TopicList(
            topics: _topics,
            selected: _selectedTopic,
            onSelect: (i) => setState(() {
              _selectedTopic = i;
              _selectedConcept = null;
            }),
          ),
          if (_selectedTopic != null)
            Expanded(
              flex: 2,
              child: _ConceptPanel(
                topic: _topics[_selectedTopic!],
                selectedConcept: _selectedConcept,
                onSelectConcept: (i) => setState(() => _selectedConcept = i),
              ),
            )
          else
            const Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Select a topic to begin', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Topic {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> concepts;
  const _Topic({required this.icon, required this.title, required this.subtitle, required this.concepts});
}

class _TopicList extends StatelessWidget {
  final List<_Topic> topics;
  final int? selected;
  final ValueChanged<int> onSelect;
  const _TopicList({required this.topics, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: cs.outlineVariant)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: topics.length,
        itemBuilder: (context, i) {
          final t = topics[i];
          final isSelected = selected == i;
          return ListTile(
            selected: isSelected,
            selectedTileColor: cs.primaryContainer,
            leading: Icon(t.icon, color: isSelected ? cs.primary : null),
            title: Text(t.title, style: const TextStyle(fontSize: 13)),
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _ConceptPanel extends StatelessWidget {
  final _Topic topic;
  final int? selectedConcept;
  final ValueChanged<int> onSelectConcept;
  const _ConceptPanel({required this.topic, required this.selectedConcept, required this.onSelectConcept});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(topic.icon, color: cs.primary),
              const SizedBox(width: 8),
              Text(topic.title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 4),
          Text(topic.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          Text('Key Concepts', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              topic.concepts.length,
              (i) => ChoiceChip(
                label: Text(topic.concepts[i]),
                selected: selectedConcept == i,
                onSelected: (_) => onSelectConcept(i),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (selectedConcept != null) ...[
            _ConceptSummaryPanel(concept: topic.concepts[selectedConcept!], cs: cs),
            const SizedBox(height: 16),
          ],
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mic),
            label: Text(selectedConcept != null
                ? 'Ask about ${topic.concepts[selectedConcept!]}'
                : 'Start Conversation'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }
}

class _ConceptSummaryPanel extends StatelessWidget {
  final String concept;
  final ColorScheme cs;
  const _ConceptSummaryPanel({required this.concept, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(concept, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            'Tap "Start Conversation" to have the AI tutor explain this concept through voice.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
