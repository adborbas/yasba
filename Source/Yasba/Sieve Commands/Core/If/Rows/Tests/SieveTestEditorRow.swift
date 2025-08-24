import SwiftUI

/**
 Generic row container for editing a Sieve test.

 Hosts a title, an optional negation affordance, and custom content supplied by
 specific test rows.
 */
struct SieveTestRow<Content: View>: View {
    let title: String
    @Binding var isNegated: Bool
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            if isNegated {
                Button {
                    isNegated.toggle()
                } label: {
                    Image(systemName: "exclamationmark")
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
            }
            content()
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        SieveTestRow(title: "Header",
                     isNegated: Binding.constant(false)) {
            Text("Input items here...")
        }
        
        SieveTestRow(title: "Header",
                     isNegated: Binding.constant(true)) {
            Text("{negated} Input items here...")
        }
    }
    .padding()
}
