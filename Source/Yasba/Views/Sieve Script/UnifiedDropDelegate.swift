import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct UnifiedDropDelegate: DropDelegate {
    enum Target {
        case fixedGap(Int)
        case row(Int)
    }

    let target: Target
    @Binding var draggedRange: Range<Int>?
    @Binding var dropGapIndex: Int?
    @Binding var rowHeights: [Int: CGFloat]
    var viewModel: SieveScriptViewModel

    private func gap(for info: DropInfo) -> Int {
        switch target {
        case .fixedGap(let g):
            return g
        case .row(let rowIndex):
            let height = rowHeights[rowIndex] ?? 28
            let y = info.location.y
            return (y < height / 2) ? rowIndex : (rowIndex + 1)
        }
    }

    func validateDrop(info: DropInfo) -> Bool { true }

    func dropEntered(info: DropInfo) {
        let gap = gap(for: info)
        if dropGapIndex != gap { dropGapIndex = gap }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        let gap = gap(for: info)
        if dropGapIndex != gap { dropGapIndex = gap }
        let isInternal = (draggedRange != nil)
        return DropProposal(operation: isInternal ? .move : .copy)
    }

    func performDrop(info: DropInfo) -> Bool {
        let gap = gap(for: info)

        if let span = draggedRange {
            
            viewModel.moveSpanInRows(from: span, toGap: gap)
            dropGapIndex = nil
            draggedRange = nil
            return true
        }
        
        let providers = info.itemProviders(for: [UTType.utf8PlainText])
        guard let first = providers.first else { return false }
        first.loadItem(forTypeIdentifier: UTType.utf8PlainText.identifier, options: nil) { item, _ in
            handleExternalInsert(item: item, atGap: gap)
        }
        return true
    }

    private func handleExternalInsert(item: NSSecureCoding?, atGap gap: Int) {
        guard let data  = item as? Data else {
            return
        }

        guard let result = SieveCommandFactory.make(from: data) else {
            return
        }

        DispatchQueue.main.async {
            viewModel.insertRowTokens(result.tokens, atGap: gap)
            dropGapIndex = nil
            draggedRange = nil
        }
    }
}
