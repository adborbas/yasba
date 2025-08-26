import Foundation
import Testing
@testable import Yasba

private struct StubCommandRendering: CommandRendering {
    func render(command: AnySieveCommand, indent: Int) -> String {
        let pad = SieveCodeStyle.indent(for: indent)
        if let leaf = command as? DummyLeaf { return "\(pad)\(leaf.text);" }
        return "\(pad)<unrenderable>\n"
    }
}

struct IfCommandRendererTests {
    @Test func singleTest_thenOnly() {
        let command = IfCommand(
            quantifier: .any,
            tests: [ .exists(["X"]) ],
            thenChildren: [ DummyLeaf("do1"), DummyLeaf("do2") ],
            elseChildren: []
        )
        let renderer = IfCommandRenderer(commandRenderer: StubCommandRendering(), testRenderer: SieveTestRenderer())
        let rendered = renderer.render(command: command, atIndent: 0)
        let expected = """
        if exists "X" {
            do1;
            do2;
        }
        """
        assertEqualLines(rendered, expected)
    }

    @Test func multipleTests_anyof_withElse() {
        let command = IfCommand(
            quantifier: .any,
            tests: [ .header(["Subject"], match: .contains, keys: ["urgent"]), .exists(["X-Flag"]) ],
            thenChildren: [ DummyLeaf("do-then") ],
            elseChildren: [ DummyLeaf("do-else") ]
        )
        let renderer = IfCommandRenderer(commandRenderer: StubCommandRendering(), testRenderer: SieveTestRenderer())
        let rendered = renderer.render(command: command, atIndent: 0)
        let expected = """
        if anyof(
          header :contains "Subject" "urgent",
          exists "X-Flag"
        ) {
            do-then;
        } else {
            do-else;
        }
        """
        assertEqualLines(rendered, expected)
    }

    @Test func allof_quantifier() {
        let command = IfCommand(
            quantifier: .all,
            tests: [ .size(.over, bytes: 1024), SieveTest(isNegated: true, primitive: .boolean(false)) ],
            thenChildren: [ DummyLeaf("then-action") ],
            elseChildren: []
        )
        let renderer = IfCommandRenderer(commandRenderer: StubCommandRendering(), testRenderer: SieveTestRenderer())
        let rendered = renderer.render(command: command, atIndent: 0)
        let expected = """
        if allof(
          size :over 1024,
          not (false)
        ) {
            then-action;
        }
        """
        assertEqualLines(rendered, expected)
    }

    @Test func noTests_defaultsToTrue() {
        let command = IfCommand(quantifier: .any, tests: [], thenChildren: [ DummyLeaf("action") ], elseChildren: [])
        let renderer = IfCommandRenderer(commandRenderer: StubCommandRendering(), testRenderer: SieveTestRenderer())
        let rendered = renderer.render(command: command, atIndent: 0)
        let expected = """
        if true {
            action;
        }
        """
        assertEqualLines(rendered, expected)
    }
}
