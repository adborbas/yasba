/**
 Renders an `ProtonMarkAsReadCommand` into Sieve source code..
 */
struct ProtonMarkAsReadRenderer: SieveCommandRenderer {
    func render(command: ProtonMarkAsReadCommand, atIndent indent: Int) -> String {
        return "addflag \"\\\\Seen\"";
    }
}
