import SwiftUI

struct InputField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.roundedBorder)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor.opacity(0.15))
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
    }
}

#Preview {
    InputField(placeholder: "Enter text", text: .constant(""))
        .padding()
}
