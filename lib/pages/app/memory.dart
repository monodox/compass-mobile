import 'package:flutter/material.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Saved'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _SessionHistoryTab(),
          _SavedConceptsTab(),
          _ProgressTab(),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _SessionHistoryTab extends StatelessWidget {
  const _SessionHistoryTab();

  @override
  Widget build(BuildContext context) {
    return const _EmptyState(
      icon: Icons.history,
      message: 'No sessions yet. Start learning to build your history.',
    );
  }
}

class _SavedConceptsTab extends StatelessWidget {
  const _SavedConceptsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchBar(
            hintText: 'Search saved concepts...',
            leading: const Icon(Icons.search),
            onChanged: (_) {},
          ),
        ),
        const Expanded(
          child: _EmptyState(
            icon: Icons.bookmark_outline,
            message: 'No saved concepts yet. Bookmark concepts during sessions.',
          ),
        ),
      ],
    );
  }
}

class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topics = [
      ('Quantum Science', 0.0),
      ('Quantum Computing', 0.0),
      ('Physics Fundamentals', 0.0),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Topic Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        ...topics.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.$1),
                      Text('${(t.$2 * 100).toInt()}%',
                          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: t.$2,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Icon(Icons.star_outline, color: cs.primary),
            title: const Text('Favorite Explanations'),
            subtitle: const Text('None saved yet'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
