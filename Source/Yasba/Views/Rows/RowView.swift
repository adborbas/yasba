import SwiftUI

fileprivate enum Constants {
    static let cornerRadius: CGFloat = 12
    static let itemSpacing: CGFloat = 12
}

struct RowView<Content: View>: View {
    let icon: String
    let onRemove: () -> Void
    private let content: Content
    
    init(icon: String, onRemove: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.onRemove = onRemove ?? { }
        self.content = content()
    }


    var body: some View {
        HStack(alignment: .top, spacing: Constants.itemSpacing) {
            CommandImage(systemName: icon)
            content
            Spacer()
        }
        .padding(Constants.itemSpacing)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color(nsColor: .windowBackgroundColor))
                .ignoresSafeArea()
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        RowView(icon: "flame") { Text("Spam") }
        RowView(icon: "arrow.trianglehead.branch") {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 120)
        }
    }
    .padding()
}
