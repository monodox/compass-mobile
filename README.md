# Compass

Compass is an interactive AI learning platform that helps users understand complex scientific topics through natural voice conversation and visual explanations. The platform allows learners to speak directly with an AI tutor that can answer questions, explain difficult concepts in simple language, and generate visual examples to improve understanding. Compass focuses on making advanced subjects accessible by transforming traditional learning into an interactive, conversational experience.

## Features

- **Dashboard** — Recent sessions and suggested topics
- **Learn** — Explore subjects starting with quantum science
- **Voice** — Real-time voice conversation with the AI tutor
- **Visual** — Upload diagrams/images and get AI explanations
- **Memory** — Learning history and saved concepts
- **Agents** — System agents: Core, Tutor, Vision, Voice, Memory
- **Settings** — App preferences, voice settings, language

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- Dart >= 3.0.0

### Run

```bash
flutter pub get
flutter run
```

### Platforms

| Platform | Status |
|----------|--------|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |

## Project Structure

```
lib/
├── main.dart              # App entry, navigation shell
├── models/
│   ├── conversation.dart
│   ├── message.dart
│   └── session.dart
├── pages/
│   ├── app/
│   │   ├── agents.dart
│   │   ├── home.dart      # Dashboard
│   │   ├── learn.dart     # Learning area
│   │   ├── memory.dart    # History & saved concepts
│   │   ├── settings.dart  # Preferences
│   │   ├── visual.dart    # Image explanations
│   │   └── voice/
│   │       ├── transcript_panel.dart
│   │       ├── voice_controls.dart
│   │       └── voice_page.dart  # Voice conversation
│   ├── auth/
│   │   ├── forgot.dart
│   │   ├── login.dart
│   │   ├── reset.dart
│   │   └── signup.dart
│   └── legal/
│       ├── cookies.dart
│       ├── legal_widgets.dart
│       ├── privacy.dart
│       └── terms.dart
├── services/
│   ├── agent_api_service.dart
│   ├── audio_recorder_service.dart
│   ├── gemini_live_service.dart
│   └── supabase_service.dart
└── widgets/
    ├── agent_status.dart
    ├── concept_card.dart
    ├── transcript_view.dart
    └── voice_button.dart

agents/
└── src/
    ├── agents/
    │   ├── core.agent.ts
    │   ├── memory.agent.ts
    │   ├── tutor.agent.ts
    │   ├── vision.agent.ts
    │   └── voice.agent.ts
    ├── api/
    │   ├── tutor.route.ts
    │   ├── vision.route.ts
    │   └── voice.route.ts
    ├── orchestrator/
    │   └── agent_router.ts
    ├── services/
    │   └── gemini.service.ts
    └── index.ts
```
