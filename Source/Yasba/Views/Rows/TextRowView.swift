import SwiftUI

struct TextRowView: View {
    let icon: String
    let title: String
    
    var body: some View {
        RowView(icon: icon) {
            Text(title)
                .frame(height: 30)
        }
    }
}

#Preview {
    TextRowView(icon: "trash", title: "Move to Trash")
        .padding(12)
}
