# Agent instructions

Dogpee is a network watchdog. Keep probe behavior and recovery actions predictable, and avoid embedding private network targets in shared examples.

## Working and validation

- Follow the existing shell script conventions and inspect side effects before changing recovery behavior.
- Validate shell syntax and use mocked or isolated targets; do not run recovery actions against a live network as a test.
- Before changing GitHub Actions, check whether [pschmitt/ci-workflows](https://github.com/pschmitt/ci-workflows) provides a reusable workflow or action. Preserve current behavior and check coverage, and use `@main` for shared workflow or action references.
