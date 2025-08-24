/**
 Renders an `ProtonExpireCommand` into Sieve source code..
 */
struct ProtonExpireCommandRenderer: SieveCommandRenderer {
    func render(command: ProtonExpireCommand, atIndent indent: Int) -> String {
        return SieveCodeStyle.indent(for: indent) + "expire \"days\" \"\(command.days)\";"
    }
}
