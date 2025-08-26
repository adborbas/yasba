import SwiftUI

/**
 SwiftUI row for the header of the `IfCommand`.
 */
struct IfHeaderRowView: View {
    @Bindable var command: IfCommand
    
    @State private var specs: [AnyTestSpec] = []
    
    var body: some View {
        RowView(icon: "arrow.triangle.branch") {
            VStack(alignment: .leading, spacing: 8) {
                header
                Divider()
                conditionsList
            }
        }
        .onAppear { syncFromCommandIfNeeded() }
        .onChange(of: command.tests) { _, _ in syncFromCommandIfNeeded() }
        .onChange(of: specs.map { $0.toDomain() }) { _, _ in
            pushToCommandIfNeeded()
        }
    }

    @ViewBuilder
    private var header: some View {
        HStack(spacing: 8) {
            Text("If")
            PickerField(values: IfQuantifier.allCases,
                        selection: $command.quantifier)
            
            Text(command.quantifier.hint)
                .foregroundStyle(.secondary)
        }
        .font(.headline)
    }
    
    @ViewBuilder
    private var conditionsList: some View {
        if specs.isEmpty {
            emptyConditionList
        }
        
        VStack {
            ForEach(Array(specs.enumerated()), id: \.element.id) { index, spec in
                HStack(spacing: 32) {
                    TestRowFactory.make(for: spec)
                    HStack(spacing: 2) {
                        menuForInserting(at: index) {
                            Image(systemName: "plus.circle")
                        }
                        showContextMenu(at: index)
                    }
                    .fixedSize()
                }
            }
        }
    }
    
    private var emptyConditionList: some View {
        menuForInserting(at: 0) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add condition")
            }
        }
        .fixedSize()
    }
    
    private func menuForInserting(at index: Int, _ label: (() -> some View)) -> some View {
        Menu {
            ForEach(TestTemplate.allCases) { template in
                Button(template.title) {
                    insertBelow(index, kind: template)
                }
            }
        } label: {
            label()
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }
    
    private func showContextMenu(at index: Int) -> some View {
        Menu {
            Button(specs[index].isNegated ? "Don't negate" : "Negate") {
                withAnimation {
                    specs[index].isNegated.toggle()
                }
            }
            Button("Remove") {
                remove(at: index)
            }
            
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }
    
    private func syncFromCommandIfNeeded() {
        let domainIDs = command.tests.map { $0.id }
        let specIDs   = specs.map { $0.id }
        guard domainIDs != specIDs || domainIDs.count != specIDs.count else { return }
        
        specs = command.tests.map { EditableTestSpecFactory.wrap($0) }
    }
    
    private func pushToCommandIfNeeded() {
        let projected = specs.map { $0.toDomain() }
        guard projected != command.tests else { return }
        command.tests = projected
    }
    
    private func insertBelow(_ index: Int, kind: TestTemplate) {
        let insertAt = max(0, min(index + 1, specs.count))
        let domain = kind.makeDefault()
        let spec = EditableTestSpecFactory.wrap(domain)
        specs.insert(spec, at: insertAt)
    }
    
    private func remove(at index: Int) {
        guard specs.indices.contains(index) else { return }
        specs.remove(at: index)
    }
}

fileprivate enum TestTemplate: String, CaseIterable, Identifiable {
    case header
    case address
    case envelope
    case size
    case exists
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .header:   return "Header"
        case .address:  return "Address"
        case .envelope: return "Envelope"
        case .size:     return "Size"
        case .exists:   return "Exists"
        }
    }
    
    func makeDefault() -> SieveTest {
        switch self {
        case .header:
            return .header(["Subject"], match: .contains, keys: [""])
        case .address:
            return .address(part: .all, names: ["From"], match: .contains, keys: [""])
        case .envelope:
            return .envelope(part: .all, names: ["from"], match: .contains, keys: [""])
        case .size:
            return .size(.over, bytes: 1024)
        case .exists:
            return .exists(["Subject"])
        }
    }
}

#Preview("Non empty") {
    @Previewable @State var command = IfCommand(
        quantifier: IfQuantifier.all,
        tests: [
            SieveTest.header(["Subject"], match: .contains, keys: ["urgent"]),
            SieveTest.address(part: .all, names: ["From"], match: .is, keys: ["boss@example.com"])
        ],
        thenChildren: []
    )
    
    IfHeaderRowView(command: command)
        .padding(12)
        .frame(width: 820)
}

#Preview("Empty") {
    @Previewable @State var command = IfCommand(
        tests: [],
        thenChildren: []
    )
    
    IfHeaderRowView(command: command)
        .padding(12)
        .frame(width: 820)
}
