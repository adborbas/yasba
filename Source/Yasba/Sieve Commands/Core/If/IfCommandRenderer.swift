/**
 Renders an `IfCommand` into Sieve source code..
 */
struct IfCommandRenderer: SieveCommandRenderer {
    typealias Command = IfCommand

    let commandRenderer: CommandRendering
    let testRenderer: SieveTestRenderer

    func render(command: IfCommand, atIndent indent: Int) -> String {
        
        let tests = command.tests
        var writer = IndentedTextWriter()
        
        let cond = renderCondition(tests: tests,
                                   quantifier: command.quantifier,
                                   baseIndent: writer.indentLevel)
        
        writer.openBlock("if \(cond)")
        for command in command.thenChildren {
            writer.write(commandRenderer.render(command: command, indent: writer.indentLevel))
        }
        writer.closeBlock()
        
        if !command.elseChildren.isEmpty {
            writer.openBlock(" else", shouldAppendAsNewLine: false)
            for command in command.elseChildren {
                writer.write(commandRenderer.render(command: command, indent: writer.indentLevel))
            }
            writer.closeBlock()
        }
        return writer.build()
    }

    private func renderCondition(tests: [SieveTest],
                                 quantifier: IfQuantifier,
                                 baseIndent: Int) -> String {
        guard !tests.isEmpty else { return "true" }
        
        if tests.count == 1 {
            return testRenderer.render(test: tests[0])
        }
        
        let keyword: String = {
            switch quantifier {
            case .all: return "allof"
            case .any: return "anyof"
            }
        }()
        
        let base = SieveCodeStyle.indent(for: baseIndent)
        let inner = SieveCodeStyle.indent(for: baseIndent + 1)
        
        let rendered = tests.enumerated().map { index, test in
            let tail = (index == tests.count - 1) ? "" : ","
            return "\(inner)\(testRenderer.render(test: test))\(tail)"
        }.joined(separator: "\n")
        
        return """
        \(keyword)(
        \(rendered)
        \(base))
        """
    }
}
