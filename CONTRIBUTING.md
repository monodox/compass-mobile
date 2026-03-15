# Contributing to Compass

Thanks for your interest in contributing. Here's how to get started.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/compass.git`
3. Install dependencies: `flutter pub get`
4. Copy the env file: `cp .env.example .env.local` and fill in your values
5. Run the app: `flutter run`

## Workflow

- Create a branch from `main`: `git checkout -b feat/your-feature`
- Keep commits small and focused
- Follow the existing code style (Dart/Flutter conventions)
- Run `flutter analyze` before submitting

## Pull Requests

- Reference any related issue in the PR description
- Describe what changed and why
- Keep PRs focused — one feature or fix per PR
- PRs require at least one review before merging

## Reporting Issues

Use GitHub Issues. Include:
- Flutter/Dart version (`flutter --version`)
- Platform (Android / iOS / Web)
- Steps to reproduce
- Expected vs actual behavior

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `const` constructors where possible
- Keep widgets small and composable

## Questions

Open a discussion on GitHub or email **dev@compass.app**.
