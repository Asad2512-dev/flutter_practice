# Architecture

## What this is

flutterpractice.

## Layout

- `android/`
- `ios/`
- `lib/` — `main.dart`, `tasks`
- `linux/`
- `macos/`
- `test/`
- `web/`
- `windows/`
- Tooling: `.gitignore`, `.metadata`
- Root files: `analysis_options.yaml`, `pubspec.lock`, `pubspec.yaml`, `README.md`

## How the pieces fit

Flutter app: `pubspec.yaml` plus `lib/` (main.dart, tasks). Platform folders: `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`. Entrypoint file `lib/main.dart` is present. Pub dependencies include `get`.

## How to run

This repository does not document a run procedure.

## External services named in the repo

- Firebase — `firebase_core` in `pubspec.yaml`
