import Foundation

protocol RowTokenEditing {
    func indentation(for tokens: [RowToken]) -> [Int]
    func dragSpan(at index: Int, in tokens: [RowToken]) -> Range<Int>
    func move(tokens: [RowToken], span: Range<Int>, toGap gap: Int) -> [RowToken]
    func remove(tokens: [RowToken], at index: Int) -> [RowToken]
}

/**
 A concrete editor for linearized `RowToken` sequences.

 This type provides the default behavior for:
 - Computing visual indentation for a flat token stream that encodes nested `if` blocks.
 - Determining the contiguous drag span at a given index (single leaf vs. whole `if` block).
 - Moving a span to a target “gap” index with correct index adjustment after removal.
 - Removing a row (or entire `if` block when the header is targeted).

 The editor is deterministic and side‑effect free: all operations return new arrays and do
 not mutate inputs. It assumes the token list is well‑formed (balanced `beginIf`/`endIf`)
 and treats `elseMarker` as a structural row that does not change depth.
 */
class RowTokenEditor: RowTokenEditing {

    func indentation(for tokens: [RowToken]) -> [Int] {
        var depth = 0
        var out: [Int] = []
        for token in tokens {
            switch token {
            case .endIf:
                depth = max(0, depth - 1)
                out.append(depth)
            case .beginIf:
                out.append(depth)
                depth += 1
            case .elseMarker:
                out.append(max(0, depth - 1))
            case .leaf:
                out.append(depth)
            }
        }
        return out
    }

    func dragSpan(at index: Int, in tokens: [RowToken]) -> Range<Int> {
        switch tokens[index] {
        case .leaf:
            return index..<(index + 1)
        case .beginIf:
            var depth = 0
            for j in index..<tokens.count {
                switch tokens[j] {
                case .beginIf: depth += 1
                case .endIf:
                    depth -= 1
                    if depth == 0 { return index..<(j + 1) }
                default: break
                }
            }
            return index..<(index + 1)
        case .elseMarker, .endIf:
            return index..<(index + 1)
        }
    }

    func move(tokens: [RowToken], span: Range<Int>, toGap gap: Int) -> [RowToken] {
        var copy = tokens
        let moving = Array(copy[span])
        copy.removeSubrange(span)
        let adjusted = gap > span.lowerBound ? gap - span.count : gap
        copy.insert(contentsOf: moving, at: max(0, min(adjusted, copy.count)))
        return copy
    }

    func remove(tokens: [RowToken], at index: Int) -> [RowToken] {
        guard tokens.indices.contains(index) else { return tokens }
        let span = dragSpan(at: index, in: tokens)
        var copy = tokens
        copy.removeSubrange(span)
        return copy
    }
}
