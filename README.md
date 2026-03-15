# ThinkLab

ThinkLab is an interactive AI learning platform that helps users understand complex scientific topics through natural voice conversation and visual explanations. The platform allows learners to speak directly with an AI tutor that can answer questions, explain difficult concepts in simple language, and generate visual examples to improve understanding. ThinkLab focuses on making advanced subjects accessible by transforming traditional learning into an interactive, conversational experience.

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
├── main.dart         # App entry, navigation shell
└── pages/
    ├── home.dart     # Dashboard
    ├── learn.dart    # Learning area
    ├── voice.dart    # Voice conversation
    ├── visual.dart   # Image explanations
    ├── memory.dart   # History & saved concepts
    ├── agents.dart   # System agents
    └── settings.dart # Preferences
```
