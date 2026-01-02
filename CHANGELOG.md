# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Multi-root VS Code workspace configuration
- Comprehensive task definitions for building and development
- Automatic Visual Studio detection via vswhere.exe
- JUCE hybrid dependency management (4 acquisition methods)
- Environment variable support for flexible paths
- WebView2 integration for Vue.js GUI
- CPM package manager integration
- Extensions recommendations (`.vscode/extensions.json`)
- EditorConfig for consistent code formatting (`.editorconfig`)
- Environment variables template (`.env.example`)
- Comprehensive troubleshooting section in README
- CONTRIBUTING.md with contribution guidelines
- This CHANGELOG file

### Changed
- Updated setup.ps1 with automatic VS detection and pause before exit
- Standardized task naming convention (PROJECT/PLUGIN/GUI prefixes)
- Modernized all README files with current project state
- Enhanced .gitignore for VS Code development
- Replaced hardcoded paths with environment variables

### Fixed
- Portable project configuration across different developer machines
- JUCE dependency resolution with multiple fallback options
- VS Code launch configuration using environment variables

### Removed
- Emoji characters from task labels for better readability
- GitHub workflow files (optional CI/CD)
- Hardcoded absolute paths throughout project

---

## How to Use This Changelog

### For Maintainers

When releasing a new version:

1. Move items from `[Unreleased]` to a new version section
2. Add release date in ISO format (YYYY-MM-DD)
3. Update version in `plugin/VERSION` file
4. Create git tag: `git tag -a v1.0.0 -m "Release 1.0.0"`

Example version entry:
```markdown
## [1.0.0] - 2024-01-15

### Added
- Initial public release
- Feature X, Y, Z

### Changed
- Improved performance of audio processing

### Fixed
- Bug in GUI rendering
```

### For Contributors

When making changes:

1. Add your changes to `[Unreleased]` section
2. Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
3. Write clear, user-facing descriptions
4. Link to relevant issues/PRs when applicable

### Category Guidelines

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

---

## Version History

<!-- Future versions will be listed here -->

[Unreleased]: https://github.com/artqcid/wogd-juce-template/compare/main...HEAD
