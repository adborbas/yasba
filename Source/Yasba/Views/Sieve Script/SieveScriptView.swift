import SwiftUI
import UniformTypeIdentifiers

struct SieveScriptView: View {
    @ObservedObject private var viewModel: SieveScriptViewModel
    @State private var draggedRange: Range<Int>? = nil
    @State private var dropGapIndex: Int? = nil
    @State private var rowHeights: [Int: CGFloat] = [:]
    @State private var hoveredRow: Int? = nil
    
    
    var tokens: [RowToken] { viewModel.rowTokens }
    var indents: [Int] { viewModel.indentation(for: tokens) }
    
    init(viewModel: SieveScriptViewModel) {
        self.viewModel = viewModel
    }
    
    var filteredIndices: [Int] {
        if let span = draggedRange { return Array(tokens.indices).filter { !span.contains($0) } }
        return Array(tokens.indices)
    }

    var placeholderInsertPosition: Int? {
        guard let gap = dropGapIndex else { return nil }
        if let pos = filteredIndices.firstIndex(where: { $0 >= gap }) { return pos }
        return filteredIndices.count
    }

    var placeholderLeading: CGFloat {
        guard let gap = dropGapIndex else { return 0 }
        if let index = tokens.indices.first(where: { $0 >= gap }) { return CGFloat(indents[index]) * 24 }
        return CGFloat(indents.last ?? 0) * 24
    }

    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Spacer()
                if viewModel.rowTokens.isEmpty {
                    emptyDropArea
                        .frame(maxWidth: 1000)
                } else {
                    scriptList
                        .frame(maxWidth: 1000)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
        private var emptyDropArea: some View {
            VStack(spacing: 12) {
                if dropGapIndex != nil || draggedRange != nil {
                    PlaceholderRowView()
                        .padding(.leading, 0)
                        .transition(.opacity)
                } else {
                    Text("Drag a command from the sidebar to start writing your script.")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .contentShape(Rectangle())
            .onDrop(
                of: [UTType.utf8PlainText],
                delegate: UnifiedDropDelegate(
                    target: .fixedGap(0),
                    draggedRange: $draggedRange,
                    dropGapIndex: $dropGapIndex,
                    rowHeights: $rowHeights,
                    viewModel: viewModel
                )
            )
        }

    @ViewBuilder
    var scriptList: some View {
        List {
            ForEach(Array(filteredIndices.enumerated()), id: \.element) { displayPos, index in
                rowOrPlaceholder(displayPos: displayPos, index: index)
            }
            if let insertPos = placeholderInsertPosition, insertPos == filteredIndices.count {
                placeholderRow(target: .fixedGap(tokens.count))
                    .listRowSeparator(.hidden)
            }
            HStack { Spacer() }
                .frame(height: 28)
                .contentShape(Rectangle())
                .onDrop(of: [UTType.utf8PlainText],
                        delegate: UnifiedDropDelegate(target: .row(max(0, tokens.count - 1)),
                                                      draggedRange: $draggedRange,
                                                      dropGapIndex: $dropGapIndex,
                                                      rowHeights: $rowHeights,
                                                      viewModel: viewModel))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    func rowOrPlaceholder(displayPos: Int, index: Int) -> some View {
        let token = tokens[index]
        if let insertPos = placeholderInsertPosition, insertPos == displayPos {
            placeholderRow(target: .fixedGap(dropGapIndex ?? (index + 1)))
        }
        if let range = draggedRange, range.contains(index) {
            EmptyView()
        } else {
            tokenRow(index: index, token: token)
        }
    }

    @ViewBuilder
    func placeholderRow(target: UnifiedDropDelegate.Target) -> some View {
        PlaceholderRowView()
            .padding(.leading, placeholderLeading)
            .contentShape(Rectangle())
            .onDrop(of: [UTType.utf8PlainText],
                    delegate: UnifiedDropDelegate(target: target,
                                                  draggedRange: $draggedRange,
                                                  dropGapIndex: $dropGapIndex,
                                                  rowHeights: $rowHeights,
                                                  viewModel: viewModel))
    }

    @ViewBuilder
    func tokenRow(index: Int, token: RowToken) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                RowTokenToViewMapper.row(for: token)
                Spacer(minLength: 0)
            }
            if hoveredRow == index && token.canRemove {
                Button {
                    viewModel.remove(at: index)
                    hoveredRow = nil
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 8, height: 8)
                }
                .buttonStyle(.plain)
                .padding(.top, 21)
                .padding(.trailing, 12)
                .zIndex(1)
            }
        }
        .listRowSeparator(.hidden)
        .padding(.leading, CGFloat(indents[index]) * 24)
        .contentShape(Rectangle())
        .onHover { hovering in hoveredRow = hovering ? index : nil }
        .applyIf(token.canDrag) { view in
            view.onDrag {
                let span = viewModel.dragSpan(at: index, in: tokens)
                draggedRange = span
                dropGapIndex = span.lowerBound
                return NSItemProvider(object: token.id.uuidString as NSString)
            }
        }
        .onDrop(of: [UTType.utf8PlainText],
                delegate: UnifiedDropDelegate(target: .row(index),
                                              draggedRange: $draggedRange,
                                              dropGapIndex: $dropGapIndex,
                                              rowHeights: $rowHeights,
                                              viewModel: viewModel))
        .background(rowHeightReader(for: index))
    }

    @ViewBuilder
    func rowHeightReader(for index: Int) -> some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { rowHeights[index] = geo.size.height }
                .onChange(of: geo.size.height, { _, newValue in
                    rowHeights[index] = newValue
                })
        }
    }
}

#Preview("Not empty") {
    @Previewable @State var viewModel = SieveScriptViewModel(script: [
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
    ])
    SieveScriptView(viewModel: viewModel)
}

#Preview("Empty") {
    @Previewable @State var viewModel = SieveScriptViewModel()
    SieveScriptView(viewModel: viewModel)
}
