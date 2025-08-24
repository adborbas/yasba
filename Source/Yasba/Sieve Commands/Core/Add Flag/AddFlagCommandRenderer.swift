/**
 Renders an `AddFlagCommand` into Sieve source code.
 */
struct AddFlagCommandRenderer: SieveCommandRenderer {
    func render(command: AddFlagCommand, atIndent indent: Int) -> String {
        let quotedTag = SieveCodeStyle.quote("\\\(command.tag)")
        return SieveCodeStyle.indent(for: indent) + "addflag \(quotedTag)\(SieveCodeStyle.lineBreak)"
    }
}
