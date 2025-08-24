import SwiftUI
/**
 View for editing a `BooleanSpec`.
 */
struct BooleanTestRow: View {
    @Bindable var spec: BooleanSpec

    var body: some View {
        SieveTestRow(title: "Boolean",
                     isNegated: $spec.isNegated) {
            Toggle("enabled", isOn: $spec.value)
        }
    }
}

#Preview {
    @Previewable @State var spec = BooleanSpec()
    BooleanTestRow(spec: spec)
        .padding()
}
