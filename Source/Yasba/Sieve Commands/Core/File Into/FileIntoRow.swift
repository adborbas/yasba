import SwiftUI

/**
 SwiftUI row for editing an `FileIntoCommand`.
 */
struct FileIntoRow: View {
    @Bindable var command: FileIntoCommand
    
    var body: some View {
        RowView(icon: "folder.fill") {
            HStack(spacing: 0) {
                Text("Move to")
                InputField(placeholder: "Mailbox", text: $command.mailbox)
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var command = FileIntoCommand(mailbox: "")
    
    FileIntoRow(command: command)
        .padding()
}
