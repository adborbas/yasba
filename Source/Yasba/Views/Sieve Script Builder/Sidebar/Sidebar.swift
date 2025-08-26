import SwiftUI
import UniformTypeIdentifiers

struct Sidebar: View {
    let viewModel = SidebarViewModel()
    
    @State private var hoveredItemID: UUID?
    @State private var isPopover = false

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewModel.sections) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items) { item in
                            sidebarItemRow(item)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onHover { inside in
                if !inside { hoveredItemID = nil }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    fileprivate func sidebarItemRow(_ item: SidebarItem) -> some View {
        HStack {
            CommandImage(systemName: item.icon)
            
            Text(item.title)
                
            Spacer()
            
            if hoveredItemID == item.id {
                Button(action: { self.isPopover.toggle() }) {
                    Image(systemName: "info.circle")
                }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                    SieveCommandInfoPopoverView(
                        icon: item.icon,
                        title: item.title,
                        info: item.info
                    )
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .contentShape(Rectangle())
        .onHover(perform: { inside in
            hoveredItemID = inside ? item.id : (hoveredItemID == item.id ? nil : hoveredItemID)
        })
        .onDrag { makeDragProvider(for: item.blueprint) }
    }
}

private func makeDragProvider(for blueprint: any SieveCommandBlueprint) -> NSItemProvider {
    let data: Data
    do {
        data = try JSONEncoder().encode(BlueprintEnvelope(blueprint))
    } catch {
        assertionFailure("Encoding blueprint failed: \(error)")
        data = Data()
    }

    let provider = NSItemProvider()
    provider.registerDataRepresentation(forTypeIdentifier: UTType.utf8PlainText.identifier, visibility: .all) { completion in
        completion(data, nil)
        return nil
    }
    return provider
}

#Preview {
    Sidebar()
        .frame(width: 320, height: 600)
}
