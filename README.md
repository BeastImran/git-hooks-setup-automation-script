# 🚀 Git-Init-Hook

A powerful tool to automate pre-commit hook setup for your Git repositories with style!

![GitHub License](https://img.shields.io/github/license/BeastImran/git-hooks-setup-automation-script)
![GitHub Stars](https://img.shields.io/github/stars/BeastImran/git-hooks-setup-automation-script?style=social)
![GitHub Forks](https://img.shields.io/github/forks/BeastImran/git-hooks-setup-automation-script?style=social)
![GitHub Action Status](https://img.shields.io/github/actions/workflow/status/BeastImran/git-hooks-setup-automation-script/.github%2Fworkflows%2Fsuper-linter.yml)

![Git-Init-Hook in action](https://github.com/BeastImran/git-hooks-setup-automation-script/blob/3cf53147427597ab8c47a3872924fd578d0684a0/assets/Git%20Hook%20Automation%20Tool%20in%20Action%20Screen%20Cap.gif)

## ✨ Features

- **One-Command Setup**: Initialize Git repositories with pre-commit hooks in a single command

- **Comprehensive Hook Collection**: Includes essential basic hooks for code quality and security to get you started

- **Automatic Tool Installation**: Handles dependency installation via Homebrew

## 🔧 Usage

Instead of using `git init` to start new local repositories, use:

```bash
git custom-init
```

This will:

1. Initialize a Git repository
2. Create a pre-commit configuration file
3. Install required tools if they do not exists already (with your permission)
4. Set up pre-commit hooks
5. Run an initial check on all files

## 🖥️ Example Output

``` text
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 Git Init Hook - Pre-commit Automation Tool 🚀        ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

====== 🚀 Creating Pre-commit Configuration ======

✅ Created .pre-commit-config.yaml in /path/to/your/repo 📄

====== 🚀 Setting Up Pre-commit Hooks ======

ℹ️  Installing common tools required using brew package manager for MacOS... 🔄
ℹ️  Installing pre-commit hooks into this local repository... 🔄
ℹ️  Running pre-commit on all files... 🔍
✅ Pre-commit setup completed successfully! 🎉

✨ All done! Your repository is now setup with pre-commit hooks! ✨
Happy coding! 😊
```

## 📋 Pre-commit Hooks Included

Git-Init-Hook configures your repository with several powerful pre-commit hooks:

- **Code Quality**
  - Trailing whitespace elimination
  - End-of-file fixing
  - YAML syntax checking
  - JSON formatting
  - Executable shebang validation

- **Security**
  - Gitleaks for secret detection
  - Talisman for sensitive data protection
  - AWS credential detection
  - Private key detection
  - TruffleHog for deep secret scanning

- **Syntax & Linting**
  - ShellCheck for shell script analysis
  - Biome for JavaScript/TypeScript linting

## 🚀 Installation

### Prerequisites

- Git
- Bash environment
- Homebrew (for macOS users)

### Quick Install

Copy the bellow command and run in your favourite terminal

```bash
curl https://raw.githubusercontent.com/BeastImran/git-hooks-setup-automation-script/main/git-init-hook.sh \
-o ~/.git-init-hook.sh && \
chmod +x ~/.git-init-hook.sh &&  ~/.git-init-hook.sh
```

## 🔍 What's Included in the Pre-commit Configuration

The script creates a `.pre-commit-config.yaml` file with the following hooks:

- **pre-commit-hooks**: Basic code quality checks
- **gitleaks**: Secret detection
- **talisman**: Sensitive data protection
- **shellcheck**: Shell script analysis
- **biome**: JavaScript/TypeScript linting
- **trufflehog**: Deep secret scanning

## 🧩 Customization

You can modify the `.pre-commit-config.yaml` file after installation to:

- Add more hooks
- Remove hooks you don't need
- Adjust hook configurations

## 📚 Why Use Pre-commit Hooks?

Pre-commit hooks help maintain code quality and security by:

- Enforcing consistent formatting
- Preventing accidental commits of sensitive data
- Catching syntax errors before they reach your repository
- Ensuring your codebase follows best practices

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgements

- [pre-commit](https://pre-commit.com/) for the amazing framework
- All the hook maintainers for their excellent tools
- [Homebrew](https://brew.sh/) for making package management simple

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/BeastImran">BeastImran</a>
</p
c
