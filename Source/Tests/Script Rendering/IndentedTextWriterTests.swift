import Testing
@testable import Yasba

struct IndentedTextWriterTests {
    @Test func build_whenEmpty_returnsEmptyString() async throws {
        let writer = IndentedTextWriter()
        #expect(writer.build().isEmpty)
        #expect(writer.indentLevel == 0)
        #expect(writer.lines.isEmpty)
    }

    @Test func write_appendsLineWithCurrentIndent() async throws {
        var writer = IndentedTextWriter()
        writer.write("stop;")
        #expect(writer.lines.count == 1)
        #expect(writer.lines[0] == expectedLine("stop;", indent: 0))
        #expect(writer.build() == expectedLine("stop;", indent: 0))
    }

    @Test func openBlock_increasesIndentAndWritesHeaderBrace() async throws {
        var writer = IndentedTextWriter()
        writer.openBlock("if allof(false)")
        #expect(writer.indentLevel == 1)
        #expect(writer.lines.count == 1)
        #expect(writer.lines[0] == expectedLine("if allof(false) {", indent: 0))
        writer.write("stop;")
        #expect(writer.lines[1] == expectedLine("stop;", indent: 1))
    }

    @Test func closeBlock_decreasesIndentAndWritesClosingBrace() async throws {
        var writer = IndentedTextWriter()
        writer.openBlock("if anyof(true)")
        writer.write("stop;")
        writer.closeBlock()
        #expect(writer.indentLevel == 0)
        #expect(writer.lines.count == 3)
        let expected = expectedBlock(header: "if anyof(true)", body: ["stop;"])
        #expect(writer.build() == expected)
    }

    @Test func nestedBlocks_renderWithProperIndentation() async throws {
        var writer = IndentedTextWriter()
        writer.openBlock("if anyof(condition)")
        writer.openBlock("if allof(other)")
        writer.write("stop;")
        writer.closeBlock()
        writer.closeBlock()

        let body = expectedBlock(header: "if allof(other)", body: ["stop;"], baseIndent: 1)
        let top = [
            expectedLine("if anyof(condition) {", indent: 0),
            body,
            expectedLine("}", indent: 0)
        ].joined(separator: SieveCodeStyle.newLine)

        #expect(writer.build() == top)
    }
}

private func expectedLine(_ text: String, indent level: Int) -> String {
    SieveCodeStyle.indent(for: level) + text
}

private func expectedBlock(header: String, body: [String], baseIndent: Int = 0) -> String {
    var lines: [String] = []
    lines.append(expectedLine("\(header) {", indent: baseIndent))
    for line in body {
        lines.append(expectedLine(line, indent: baseIndent + 1))
    }
    lines.append(expectedLine("}", indent: baseIndent))
    return lines.joined(separator: SieveCodeStyle.newLine)
}
