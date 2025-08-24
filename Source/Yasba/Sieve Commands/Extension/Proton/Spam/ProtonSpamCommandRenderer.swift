/**
 Renders an `ProtonSpamCommand` into Sieve source code..
 */
struct ProtonSpamCommandRenderer: SieveCommandRenderer {
    func render(command: ProtonSpamCommand, atIndent indent: Int) -> String {
        return """
if allof (
  environment :matches "vnd.proton.spam-threshold" "*",
  spamtest :value "ge" :comparator "i;ascii-numeric" "${1}"
) {
    return;
}
"""
    }
}
