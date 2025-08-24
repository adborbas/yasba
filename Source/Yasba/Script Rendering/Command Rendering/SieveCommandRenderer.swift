/**
 Define a service capable of rendering any `SieveCommand` into its textual
 representation with indentation.
 */
protocol CommandRendering {
    func render(command: AnySieveCommand, indent: Int) -> String
}

/**
 Default implementation of `CommandRenderingService` that uses a
 `SieveCommandRenderRegistry` to look up and delegate rendering
 to the appropriate command renderer.
 */
final class SieveCommandRenderingService: CommandRendering {
    private let registry: SieveCommandRenderRegistry

    init(registry: SieveCommandRenderRegistry) {
        self.registry = registry
    }

    func render(command: AnySieveCommand, indent: Int) -> String {
        guard let renderer = registry.handler(for: command) else {
            fatalError("Unsupported command \(type(of: command)). Register a renderer in SieveCommandRenderRegistry.")
        }
        return renderer.render(command, indent: indent)
    }
}
