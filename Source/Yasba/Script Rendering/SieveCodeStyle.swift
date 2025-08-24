enum SieveCodeStyle {
    static let newLine = "\n"
    static let ifKeyword = "if"
    static let indent = "  "
    static let lineBreak = ";"
    
    static func indent(for level: Int) -> String {
        String(repeating: indent, count: max(0, level))
    }

    /// Returns a Sieve-safe quoted string (escapes `\` and `"`).
    static func quote(_ string: String) -> String {
        var out = ""
        out.reserveCapacity(string.count + 2)
        for ch in string {
            if ch == "\\" || ch == "\"" { out.append("\\") }
            out.append(ch)
        }
        return "\"\(out)\""
    }

    /// Renders a Sieve list. Single item renders as a plain quoted string; multi-items as `["a", "b"]`.
    static func stringList(_ items: [String]) -> String {
        guard !items.isEmpty else { return "[]" }
        if items.count == 1 {
            return quote(items[0])
        }
        
        let joined = items.map { quote($0) }.joined(separator: ", ")
        return "[\(joined)]"
    }
}
