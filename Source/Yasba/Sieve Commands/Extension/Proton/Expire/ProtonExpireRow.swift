import SwiftUI

/**
 SwiftUI row for editing a `ProtonExpireCommand`.
 */
struct ProtonExpireRow: View {
    @Bindable var command: ProtonExpireCommand
    
    var body: some View {
        RowView(icon: "hourglass") {
            HStack(spacing: 0) {
                Text("Proton Expire in")
                NumberInputField(value: $command.days, range: 0...730)
                Text("days")
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var command = ProtonExpireCommand(days: 10)
    
    ProtonExpireRow(command: command)
        .padding()
}


