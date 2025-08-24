# Yet Another Sieve Builder App (Yasba)

TEST

**Yasba** is a macOS SwiftUI application for visually building [Sieve](https://en.wikipedia.org/wiki/Sieve_(mail_filtering_language)) mail filter scripts.

It provides a user-friendly editor for creating complex email filtering rules without needing to manually write Sieve code.

## Features

- 🎨 Visual editor for building Sieve scripts
- 📚 Palette of commands, including core Sieve and provider-specific extensions
- 🖱️ Drag & drop support for reordering and nesting commands
- 🔄 Rendering of the visual script into valid Sieve source code
- 🛠️ Extensible architecture – easily add new commands (see [How To Add New Command](Source/Sieve%20Commands/HowToAddNewCommand.md))  

## Architecture Overview

Yasba is designed with extensibility in mind. The main architectural components are:

- **Domain Layer (AST)**: Defines the structure of Sieve commands and scripts as an Abstract Syntax Tree (AST). This is the canonical representation of the user's script.

- **Tokenization and UI Synchronization**: The UI presents scripts as a sequence of *row tokens*, each representing a command, block, or argument in the script. User actions (such as drag & drop, editing, or nesting) update these tokens. Changes in the UI are synchronized back into the AST, ensuring a single source of truth. Conversely, updates to the AST are immediately reflected in the tokenized UI, enabling real-time editing and preview.

- **Rendering Layer**: Converts the AST into valid Sieve source code. Each command or construct in the AST has a corresponding renderer that knows how to output its textual Sieve representation.

- **Extensibility (Blueprints & Registries)**: New Sieve commands can be added by defining a *blueprint* (describing its structure and arguments), a *renderer* (for code generation), and a *view* (for UI editing). These components are registered in centralized registries, which the app uses to map AST nodes to their UI and rendering logic. This modular approach allows contributors to extend the system without modifying core editor code.

- **UI Layer (SwiftUI)**: Implements the visual editor, palette, and live previews. The editor operates on row tokens, supports drag & drop for reordering/nesting, and uses the registry to dynamically render the correct UI for each command.

## Getting Started

1. Clone the repository  
2. Open the project in Xcode.  
3. Build and run the app on macOS.  

## Contributing

Contributions are welcome!  

Check out [How To Add New Command](HowToAddNewCommand.md) to learn how to extend Yasba with new Sieve commands.

## License

This project is licensed under the **MIT License** – a permissive license that allows for open collaboration and wide adoption.
