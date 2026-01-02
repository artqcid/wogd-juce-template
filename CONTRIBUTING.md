# Contributing to WOGD JUCE Template

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/wogd-juce-template.git
   cd wogd-juce-template
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Code Style

### C++ (JUCE Plugin)
- Follow JUCE coding conventions
- Use 4 spaces for indentation
- Use camelCase for variables and functions
- Use PascalCase for classes
- Keep lines under 120 characters

### JavaScript/TypeScript (GUI)
- Use 2 spaces for indentation
- Follow Vue.js style guide
- Use Prettier for formatting
- Use ESLint for linting

### CMake
- Use 4 spaces for indentation
- Keep CMake files organized and commented
- Follow existing patterns in the project

## 🔍 Before Submitting

### Testing
1. Build the plugin successfully:
   ```bash
   cmake --preset ninja-clang
   cmake --build build
   ```
2. Test in at least one DAW (if modifying plugin code)
3. Test GUI functionality in both development and production modes
4. Run tests if available:
   ```bash
   cd build
   ctest --output-on-failure
   ```

### Code Quality
- Ensure no compiler warnings
- Check for memory leaks (use Valgrind on Linux/macOS)
- Verify clangd has no errors in VS Code
- Format code according to `.editorconfig`

## 📋 Pull Request Process

1. **Update documentation** if needed:
   - Update README.md for user-facing changes
   - Update code comments for API changes
   - Add entry to CHANGELOG.md

2. **Commit messages** should be clear and descriptive:
   ```
   feat: Add parameter automation support
   fix: Resolve GUI rendering issue on Windows
   docs: Update build instructions for macOS
   refactor: Simplify audio processing loop
   ```

   Prefixes: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

3. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request** on GitHub:
   - Provide clear description of changes
   - Reference any related issues
   - Include screenshots/videos for UI changes
   - List breaking changes if any

## 🐛 Reporting Bugs

When reporting bugs, please include:

- **Environment:**
  - OS and version (Windows 10/11, macOS version, Linux distro)
  - VS Code version
  - CMake version
  - JUCE version (if using custom installation)
  - Node.js version

- **Steps to reproduce:**
  - Detailed steps to recreate the issue
  - Expected behavior
  - Actual behavior

- **Additional context:**
  - Error messages or logs
  - Screenshots if applicable
  - Relevant configuration files

## 💡 Feature Requests

We welcome feature requests! Please:

1. Check if the feature already exists or is planned
2. Describe the use case clearly
3. Explain why this would be valuable
4. Provide examples if possible

## 🎯 Areas for Contribution

Looking for ideas? Here are areas that could use help:

### High Priority
- Cross-platform testing (macOS, Linux)
- Documentation improvements
- Example plugins showcasing features
- CI/CD improvements

### Medium Priority
- Additional GUI components library
- Plugin preset management
- Performance optimizations
- Better error handling

### Nice to Have
- Additional plugin formats (AAX, LV2)
- Plugin validation tools
- Automated testing suite
- Docker build environment

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

## ❓ Questions?

If you have questions:
- Open a GitHub Discussion
- Check existing issues and PRs
- Review documentation in `/docs`

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to making audio plugin development more accessible!** 🎵
