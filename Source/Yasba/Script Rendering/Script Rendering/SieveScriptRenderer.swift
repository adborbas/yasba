/**
 Responsible for rendering a full Sieve script from a sequence of commands.
 
 Collects and renders script requirements (e.g., capabilities) before rendering
 each individual command using a provided `CommandRendering` service.
 Provides a `default` instance preconfigured with built-in command renderers.
 */
struct SieveScriptRenderer {
    let commandRenderer: CommandRendering
    
    func render(commands: [AnySieveCommand]) -> String {
        var requirements = SieveScriptRequirements()
        var result = ""
        
        let script = commands.map {
            requirements.add($0.requirements)
            return commandRenderer.render(command: $0, indent: 0)
        }.joined(separator: SieveCodeStyle.newLine)
        
        let renderedRequirements = requirements.render()
        result.append(renderedRequirements)
        result.append(SieveCodeStyle.newLine)
        result.append(SieveCodeStyle.newLine)
        
        result.append(script)
        
        return result
    }
    
    static var `default`: SieveScriptRenderer {
        let registry = SieveCommandRenderRegistry()
        let commandRenderer = SieveCommandRenderingService(registry: registry)
        let testRenderer = SieveTestRenderer()

        registry.register(AddFlagCommand.self, renderer: AddFlagCommandRenderer())
        registry.register(FileIntoCommand.self, renderer: FileIntoCommandRenderer())
        registry.register(StopCommand.self, renderer: StopCommandRenderer())
        registry.register(IfCommand.self, renderer: IfCommandRenderer(commandRenderer: commandRenderer, testRenderer: testRenderer))
        registry.register(ProtonSpamCommand.self, renderer: ProtonSpamCommandRenderer())
        registry.register(ProtonMarkAsReadCommand.self, renderer: ProtonMarkAsReadRenderer())
        registry.register(ProtonExpireCommand.self, renderer: ProtonExpireCommandRenderer())

        return SieveScriptRenderer(commandRenderer: commandRenderer)
    }
}
