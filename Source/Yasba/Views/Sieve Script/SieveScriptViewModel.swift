import Combine

final class SieveScriptViewModel: ObservableObject {
    
    private var script: [AnySieveCommand] = [
        AddFlagCommand(tag: "Spam"),
        IfCommand(
            quantifier: .any,
            tests: [
                .header(["from"], match: .contains, keys: ["noreply@dpd.hu"]),
                .exists(["x-marked-spam"])
            ],
            thenChildren: [
                AddFlagCommand(tag: "Label 1"),
                AddFlagCommand(tag: "Label 2")
            ],
            elseChildren: [
                AddFlagCommand(tag: "Tag 1")
            ]
        ),
        FileIntoCommand(mailbox: "Social"),
        AddFlagCommand(tag: "Tag 1"),
        AddFlagCommand(tag: "Tag 2"),
        StopCommand()
    ]

    private let mapper: RowTokenMapping
    private let editor: RowTokenEditing
    private let scriptRenderer: SieveScriptRenderer

    var rowTokens: [RowToken] {
        mapper.tokens(from: script)
    }

    init(mapper: RowTokenMapping = RowTokenMapper(),
         editor: RowTokenEditing = RowTokenEditor(),
         scriptRenderer: SieveScriptRenderer = .default) {
        self.mapper = mapper
        self.editor = editor
        self.scriptRenderer = scriptRenderer
    }
    
    func indentation(for tokens: [RowToken]) -> [Int] {
        editor.indentation(for: tokens)
    }

    func dragSpan(at index: Int, in tokens: [RowToken]) -> Range<Int> {
        editor.dragSpan(at: index, in: tokens)
    }

    func moveSpanInRows(from span: Range<Int>, toGap gap: Int) {
        applyTokenEdit { tokens in
            tokens = editor.move(tokens: tokens, span: span, toGap: gap)
        }
    }

    func insertRowTokens(_ newRows: [RowToken], atGap gap: Int) {
        applyTokenEdit { tokens in
            let g = max(0, min(gap, tokens.count))
            tokens.insert(contentsOf: newRows, at: g)
        }
    }

    func remove(at index: Int) {
        applyTokenEdit { tokens in
            tokens = editor.remove(tokens: tokens, at: index)
        }
    }

    func render() -> String {
        return scriptRenderer.render(commands: script)
    }

    private func applyTokenEdit(_ transform: (inout [RowToken]) -> Void) {
        var tokens = mapper.tokens(from: script)
        transform(&tokens)
        self.script = mapper.script(from: tokens)
    }
}
