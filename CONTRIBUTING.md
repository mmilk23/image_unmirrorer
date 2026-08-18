# Contributing to Image Unmirrorer

## Branch model

This repository uses a lightweight development workflow with two long-lived branches:

- `main`: stable, releasable code.
- `development`: integration branch for ongoing development.

Regular development must not be committed directly to either long-lived branch.

## Working branches

Create short-lived branches from `development` using one of these prefixes:

- `feature/` for new functionality
- `fix/` for bug fixes
- `refactor/` for internal code improvements
- `chore/` for maintenance and tooling
- `docs/` for documentation changes
- `test/` for test-only changes

Example:

```bash
git switch development
git pull
git switch -c feature/add-image-validation
```

## Pull requests

Normal changes follow this path:

```text
feature/*, fix/*, refactor/*, chore/*, docs/*, test/*
                         |
                         v
                    development
                         |
                         v
                       main
```

1. Open regular pull requests against `development`.
2. CI must pass before merging.
3. When `development` is ready for release, open a pull request from `development` to `main`.
4. `main` should always represent a stable and releasable state.

## Commits

Use concise Conventional Commit messages when practical:

```text
feat: add image validation
fix: handle unsupported image format
refactor: simplify image processing
chore: update dependencies
docs: document API usage
test: add image processing tests
```

## Local validation

Before opening a pull request, run:

```bash
mix format --check-formatted
mix compile --warnings-as-errors
mix test
```

## Dependency updates

Dependabot pull requests target `development` and follow the same CI and merge rules as other changes.
