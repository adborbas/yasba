import SwiftUI

/**
 SwiftUI row for editing an `AddFlagCommand`.
 */
struct AddFlagRow: View {
    @Bindable var command: AddFlagCommand
    
    var body: some View {
        RowView(icon: "flag.fill") {
            HStack(spacing: 0) {
                Text("Add flag")
                InputField(placeholder: "Flag", text: $command.tag)
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var command = AddFlagCommand(tag: "")
    
    AddFlagRow(command: command)
        .padding()
}
