# Contributing to x-Nord OS

Thanks for your interest in contributing.

## How to Contribute

1. **Report bugs** — Open an issue with steps to reproduce
2. **Suggest features** — Open an issue with a clear description
3. **Submit patches** — Fork, branch, PR

## Development Setup

- Build host: Ubuntu 24.04 LTS
- Tools: Cubic, standard Linux utilities
- See [docs/BUILD.md](docs/BUILD.md) for full instructions

## Code Style

- Shell scripts: `set -e`, meaningful variable names
- Config files: follow existing formatting
- Commit messages: concise, present tense

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Make your changes
4. Run `./scripts/verify-iso.sh` if modifying ISO-related content
5. Commit with a clear message
6. Push and open a PR
7. Address review feedback

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
