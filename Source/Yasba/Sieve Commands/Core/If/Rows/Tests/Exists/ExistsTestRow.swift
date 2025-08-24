import SwiftUI

/**
 View for editing an `ExistsSpec`.
 */
struct ExistsTestRow: View {
    @Bindable var spec: ExistsSpec

    // MARK: - View
    var body: some View {
        SieveTestRow(title: "Exists",
                     isNegated: $spec.isNegated) {
            InputFieldList(items: $spec.fields, placeholder: "Header")
        }
    }
}

#Preview {
    @Previewable @State var spec = ExistsSpec()
    ExistsTestRow(spec: spec)
        .padding()
}
