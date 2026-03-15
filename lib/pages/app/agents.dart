import 'package:flutter/material.dart';

class AgentsPage extends StatelessWidget {
  const AgentsPage({super.key});

  static const _agents = [
    _Agent(
      name: 'Core',
      description: 'Orchestrates all agent requests and manages the overall conversation flow.',
      icon: Icons.hub,
      color: Colors.deepPurple,
      status: _AgentStatus.active,
    ),
    _Agent(
      name: 'Tutor',
      description: 'Explains complex concepts in simple language and answers follow-up questions.',
      icon: Icons.school,
      color: Colors.blue,
      status: _AgentStatus.active,
    ),
    _Agent(
      name: 'Vision',
      description: 'Interprets uploaded images, diagrams, and charts to generate explanations.',
      icon: Icons.visibility,
      color: Colors.teal,
      status: _AgentStatus.active,
    ),
    _Agent(
      name: 'Voice',
      description: 'Handles real-time speech input and text-to-speech output for voice sessions.',
      icon: Icons.record_voice_over,
      color: Colors.orange,
      status: _AgentStatus.idle,
    ),
    _Agent(
      name: 'Memory',
      description: 'Stores learning history and retrieved concepts to personalize future sessions.',
      icon: Icons.memory,
      color: Colors.green,
      status: _AgentStatus.active,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agents')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AgentDiagram(agents: _agents),
          const SizedBox(height: 24),
          Text('Agent Details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ..._agents.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AgentCard(agent: a),
              )),
        ],
      ),
    );
  }
}

enum _AgentStatus { active, idle }

class _Agent {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final _AgentStatus status;
  const _Agent({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.status,
  });
}

class _AgentDiagram extends StatelessWidget {
  final List<_Agent> agents;
  const _AgentDiagram({required this.agents});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('System Architecture', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          // Core agent at center
          _DiagramNode(agent: agents[0], isCore: true),
          const SizedBox(height: 8),
          Icon(Icons.arrow_downward, color: cs.onSurfaceVariant, size: 18),
          const SizedBox(height: 8),
          // Other agents in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: agents.skip(1).map((a) => _DiagramNode(agent: a)).toList(),
          ),
        ],
      ),
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final _Agent agent;
  final bool isCore;
  const _DiagramNode({required this.agent, this.isCore = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: agent.color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: agent.color, width: isCore ? 2 : 1),
          ),
          child: Icon(agent.icon, color: agent.color, size: isCore ? 28 : 20),
        ),
        const SizedBox(height: 4),
        Text(agent.name, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _AgentCard extends StatelessWidget {
  final _Agent agent;
  const _AgentCard({required this.agent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = agent.status == _AgentStatus.active;
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: agent.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(agent.icon, color: agent.color),
        ),
        title: Text(agent.name),
        subtitle: Text(agent.description, style: Theme.of(context).textTheme.bodySmall),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? cs.primaryContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isActive ? 'Active' : 'Idle',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? cs.primary : cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
