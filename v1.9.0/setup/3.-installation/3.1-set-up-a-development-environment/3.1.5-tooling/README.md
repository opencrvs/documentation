# 4.1.5 Tooling

As part of the next step [3.2-set-up-your-own-country-configuration](../../../../../v1.8.0/setup/3.-installation/3.2-set-up-your-own-country-configuration "mention"), you are required to edit CSV, JSON, JS and Docker Compose files. Therefore, we strongly recommend that you install and use the free [VSCode](https://code.visualstudio.com/) IDE from Microsoft.

The following VSCode [Extensions](https://code.visualstudio.com/docs/editor/extension-marketplace) should be installed for the best developer experience:

* Color Highlight
* Docker
* Docker Compose
* EditorConfig for VSCode
* ESLint
* Git Blame
* Git History
* GitLens
* GraphQL
* Prettier
* Stylelint
* vscode-icons
* vscode-styled-components
* YAML
* WSL (if you're using Windows Subsystem for Linux)

The following settings.json in VSCode is also helpful:

```
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "eslint.autoFixOnSave": true,
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    { "language": "typescript", "autoFix": true },
    { "language": "typescriptreact", "autoFix": true }
  ],
  "typescript.updateImportsOnFileMove.enabled": "always",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
}
```

**Terminal helper**

[Ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) is a fantastic helper for Terminal
