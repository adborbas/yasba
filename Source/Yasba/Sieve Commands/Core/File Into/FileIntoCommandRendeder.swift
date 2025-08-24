/**
 Renders an `AddFlagCommand` into Sieve source code.
 */
struct FileIntoCommandRenderer: SieveCommandRenderer {
    func render(command: FileIntoCommand, atIndent indent: Int) -> String {
        return SieveCodeStyle.indent(for: indent) + "fileinto \"\(command.mailbox)\"\(SieveCodeStyle.lineBreak)"
    }
}
