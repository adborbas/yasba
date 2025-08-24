import SwiftUI

struct InputFieldList: View {
    @Binding var items: [String]
    var placeholder: String = "Header"
    
    private func binding(at index: Int) -> Binding<String> {
        Binding<String>(
            get: {
                guard items.indices.contains(index) else { return "" }
                return items[index]
            },
            set: { newValue in
                if items.indices.contains(index) {
                    items[index] = newValue
                } else if index == items.endIndex {
                    items.append(newValue)
                }
            }
        )
    }
    
    private func appendItem() {
        items.append("")
    }
    
    private func removeItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        if items.isEmpty { items = [""] }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(items.indices), id: \.self) { index in
                inputField(for: index)
            }
            addButton
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    private func inputField(for index: Int) -> some View {
        InputField(placeholder: placeholder, text: binding(at: index))
            .overlay(alignment: .trailing) {
                if items.count > 1 {
                    Button {
                        withAnimation { removeItem(at: index) }
                    } label: {
                        Image(systemName: "xmark.circle.fill").imageScale(.small)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 16)
                }
            }
    }
    
    @ViewBuilder
    private var addButton: some View {
        Button {
            withAnimation { appendItem() }
        } label: {
            Text("Add")
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.accentColor)
    }
}

#Preview {
    @Previewable @State var items: [String] = ["Item1", "Item2"]
    
    InputFieldList(items: $items, placeholder: "Header")
        .padding()
}
