import SwiftUI

struct PickerField<Item>: View where Item: Identifiable, Item: CustomStringConvertible {
    let values: [Item]
    @Binding var selection: Item
    
    init(values: [Item], selection: Binding<Item>) {
        self.values = values
        self._selection = selection
    }
    
    var body: some View {
        Menu {
            ForEach(values) { value in
                Button {
                    selection = value
                } label: {
                    Text(value.description)
                }
            }
        } label: {
            Text(selection.description)
                .foregroundStyle(Color.accentColor)
        }
        .padding(.horizontal, 4).padding(.vertical, 4)
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.1))
        )
        .fixedSize()
    }
}

#Preview {
    @Previewable @State var selection: Example = .one
    
    PickerField(values: Example.allCases, selection: $selection)
        .padding()
}

fileprivate enum Example: String, CaseIterable, Identifiable, CustomStringConvertible {
    case one
    case two
    case three
    
    var id: String { rawValue }
    var description: String { rawValue }
}
