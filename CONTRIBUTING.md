# Contributing to Celestia Mobile

Thanks for your interest in improving the pack!

## How to contribute

1. **Fork** the repository.
2. Create a feature branch from `main`.
3. Make your changes (shaders live under `shaders/`).
4. Test on Iris + Sodium with Minecraft 1.21.11 if possible.
5. Open a Pull Request with a clear description of what you changed and why.

## Guidelines

- Keep the pack **lightweight** — this is intentionally mobile-friendly (no heavy shadow maps / deferred pipelines unless behind a clear opt-in and still performant).
- Prefer readable GLSL and small, focused changes.
- Update `shaders/lang/en_US.lang` and `shaders/shaders.properties` when adding new options.
- Document new features in the README.

## Reporting issues

Please include:

- Minecraft version
- Iris + Sodium versions
- Device / OS (especially if mobile)
- The exact error from `latest.log` if a shader fails to compile
- Screenshots when relevant

Thank you!
