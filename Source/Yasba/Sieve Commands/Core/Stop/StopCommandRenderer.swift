/**
 Renders an `StopCommand` into Sieve source code..
 */
struct StopCommandRenderer: SieveCommandRenderer {
    func render(command: StopCommand, atIndent indent: Int) -> String {
        SieveCodeStyle.indent(for: indent) + "stop\(SieveCodeStyle.lineBreak)"
    }
}
