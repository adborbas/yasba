/**
 A utility for building multi-line, indented text representations.
 
 `IndentedTextWriter` helps construct formatted output such as Sieve scripts
 by managing indentation levels and block structures. It ensures consistent
 indentation and supports opening/closing code blocks while collecting
 lines into a final string.
 */
struct IndentedTextWriter {
    private(set) var lines: [String] = []
    private(set) var indentLevel: Int = 0
    
    mutating func write(_ line: String, indent offset: Int = 0, shouldAppendAsNewLine: Bool = true) {
        let prefix = SieveCodeStyle.indent(for: indentLevel + offset)
        if shouldAppendAsNewLine {
            lines.append(prefix + line)
        } else {
            lines[lines.count - 1] += prefix + line
        }
    }
    
    mutating func openBlock(_ header: String, shouldAppendAsNewLine: Bool = true) {
        write("\(header) {", shouldAppendAsNewLine: shouldAppendAsNewLine)
        indentLevel += 1
    }
    
    mutating func closeBlock() {
        indentLevel = max(0, indentLevel - 1)
        write("}")
    }
    
    func build() -> String { lines.joined(separator: SieveCodeStyle.newLine) }
}
