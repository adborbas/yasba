import SwiftUI

final class SieveCommandViewRegistry {
    private typealias Builder = (AnySieveCommand) -> AnyView
    private var map: [ObjectIdentifier: Builder] = [:]

    func register<Command: SieveCommand>(_ type: Command.Type, builder: @escaping (Command) -> AnyView) {
        map[ObjectIdentifier(type)] = { command in
            guard let typed = command as? Command else { return AnyView(EmptyView()) }
            return builder(typed)
        }
    }

    func makeView(for command: AnySieveCommand) -> AnyView {
        let key = ObjectIdentifier(type(of: command))
        guard let view = map[key]?(command) else {
            fatalError("Unsuitable command for row view: \(String(describing: type(of: command))). Have you registered it in SieveCommandViewRegistry?")
        }
        
        return view
    }

    static func `default`() -> SieveCommandViewRegistry {
        
        // IfCommand is handled by tokens
        let registry = SieveCommandViewRegistry()
        registry.register(AddFlagCommand.self) { AnyView(AddFlagRow(command: $0)) }
        registry.register(FileIntoCommand.self){ AnyView(FileIntoRow(command: $0)) }
        registry.register(StopCommand.self) { _ in AnyView(TextRowView(icon: "stop.fill", title: "Stop processing")) }
        registry.register(ProtonSpamCommand.self) { _ in AnyView(TextRowView(icon: "flame.fill", title: "Proton Spam Filter")) }
        registry.register(ProtonMarkAsReadCommand.self) { _ in AnyView(TextRowView(icon: "envelope.open.fill", title: "Proton Mark As Read")) }
        registry.register(ProtonExpireCommand.self) { AnyView(ProtonExpireRow(command: $0)) }
        
        return registry
    }
}
