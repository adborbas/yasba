# How to Add a New Command

This guide walks you through adding a new command step-by-step.


## 1. Setup
Decide where the command lives:
- Core commands → `Sieve Commands/Core`
- Provider-specific commands → `Sieve Commands/Extension/...`

## 2. Implement the Command
Every command needs:

1. **Command** (`<Awesome>Command`)  
   Conforms to `SieveCommand` + `SieveCommandValueEquatable`.  
   ```swift
   struct AwesomeCommand: SieveCommand, SieveCommandValueEquatable {
       let id = UUID()
       // properties...
   }
   ```

2. **Renderer** (`<Awesome>CommandRenderer`)  
   Conforms to `SieveCommandRenderer`.  
   Responsible for turning the command into Sieve source code.

3. **Blueprint** (`<Awesome>CommandBlueprint`)  
   Conforms to `SieveCommandBlueprint`.  
   Describes how the command appears in the palette (metadata + initial token(s)).

4. **Row View (optional)** (`<Awesome>Row`)  
   A SwiftUI view that defines how the command is shown in `SieveScriptView`.  
   If your command has no custom UI, use a `TextRowView` like `StopCommand`.

## 3. Register the Command
- In `SieveScriptRenderer.default` → register your `CommandRenderer`.
- In `SieveCommandViewRegistry.default` → register your SwiftUI row view.
- In `BlueprintRegistry.registerDefaults` → register your blueprint.

## 4. Expose in the Sidebar
Update `SidebarViewModel` so the command appears in the sidebar for drag-and-drop into the editor.

## See Examples
- `StopCommand` → simplest example (uses `TextRowView`).
- `AddFlagCommand` → example with custom row view.
