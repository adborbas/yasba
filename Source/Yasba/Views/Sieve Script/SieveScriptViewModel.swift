import Combine

final class SieveScriptViewModel: ObservableObject {
    
    private var script: [AnySieveCommand] = []

    private let mapper: RowTokenMapping
    private let editor: RowTokenEditing
    private let scriptRenderer: SieveScriptRenderer

    var rowTokens: [RowToken] {
        mapper.tokens(from: script)
    }

    init(script: [AnySieveCommand] = [],
         mapper: RowTokenMapping = RowTokenMapper(),
         editor: RowTokenEditing = RowTokenEditor(),
         scriptRenderer: SieveScriptRenderer = .default) {
        self.script = script
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
    
    func clear() {
        applyTokenEdit { tokens in
            tokens = []
        }
    }

    private func applyTokenEdit(_ transform: (inout [RowToken]) -> Void) {
        objectWillChange.send()
        var tokens = mapper.tokens(from: script)
        transform(&tokens)
        self.script = mapper.script(from: tokens)
    }
}
