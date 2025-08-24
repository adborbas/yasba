/**
 Registry for mapping command types to renderer closures.
 Mirrors the approach used by `SieveCommandViewRegistry` for views.
 */
final class SieveCommandRenderRegistry {
    private var map: [ObjectIdentifier: AnyCommandRenderer] = [:]

    func register<Command: SieveCommand, Renderable: SieveCommandRenderer>(
        _ type: Command.Type,
        renderer: Renderable
    ) where Renderable.Command == Command {
        map[ObjectIdentifier(type)] = AnyCommandRenderer(renderer)
    }

    func handler(for command: AnySieveCommand) -> AnyCommandRenderer? {
        map[ObjectIdentifier(type(of: command))]
    }
}
