/**
 A type‑erased renderer for Sieve commands.

 `AnyCommandRenderer` hides the concrete renderer type so heterogeneous
 renderers can be stored in collections or registries and passed through
 APIs that expect a single uniform type. It forwards all behavior to an
 internally held concrete renderer..
 */
struct AnyCommandRenderer {
    private let typeID: ObjectIdentifier
    private let _render: (AnySieveCommand, Int) -> String

    init<Renderable: SieveCommandRenderer>(_ renderer: Renderable) {
        self.typeID = ObjectIdentifier(Renderable.Command.self)
        self._render = { command, indent in
            guard let typed = command as? Renderable.Command else {
                fatalError("Renderer expected \(Renderable.Command.self), got \(type(of: command))")
            }
            return renderer.render(command: typed, atIndent: indent)
        }
    }

    func canHandle(_ command: AnySieveCommand) -> Bool {
        ObjectIdentifier(type(of: command)) == typeID
    }

    func render(_ command: AnySieveCommand, indent: Int) -> String {
        _render(command, indent)
    }
}
