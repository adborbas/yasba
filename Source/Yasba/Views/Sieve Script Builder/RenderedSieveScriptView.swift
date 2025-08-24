import SwiftUI

struct RenderedSieveScriptView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var scriptText: String
    @State private var copied = false
    
    var body: some View {
        VStack(alignment:.leading,
               spacing: 16) {
            
            header
            renderedScript
            footer
        }
       .padding(16)
       .frame(minWidth: 720, minHeight: 350)
    }
    
    @ViewBuilder
    private var header: some View {
        Text("Sieve Script")
            .font(.headline)
    }
    
    @ViewBuilder
    private var renderedScript: some View {
        ScrollView {
            Text(scriptText.isEmpty ? "∅ (empty script)" : scriptText)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(16)
                .fixedSize(horizontal: false, vertical: true)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(nsColor: .textBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
        .frame(maxHeight: 700)
    }
    
    @ViewBuilder
    private var footer: some View {
        HStack(spacing: 12) {

            Button { dismiss() }
            label: {
                Text("Cancel")
                    .frame(width: 100)
            }
                .buttonStyle(.bordered)
            
            Spacer()
            
            Button {
                let pb = NSPasteboard.general
                pb.clearContents()
                pb.setString(scriptText, forType: .string)
                withAnimation(.easeOut(duration: 0.2)) { copied = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeIn(duration: 0.2)) { copied = false }
                }
            } label: {
                Text(copied ? "Copied" : "Copy")
                    .frame(width: 100)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

fileprivate var script = """
addflag "\\Spam";
if anyof(
  header :contains "from" "noreply@sender.hu",
  exists "x-marked-spam"
) {
    addflag "\\Label 1";
    addflag "\\Label 2";
}
else {
    addflag "\\Tag 1";
}
fileinto "Social";
addflag "\\Tag 1";
addflag "\\Tag 2";
stop;
"""
#Preview("Short script") {
    RenderedSieveScriptView(scriptText: .constant(script))
}

#Preview("Long script") {
    RenderedSieveScriptView(scriptText: .constant(script + "\n\n" + script))
}
