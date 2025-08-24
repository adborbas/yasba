import SwiftUI

/**
 View for editing an `SizeSpec`.
 */
struct SizeTestRow: View {
    @Bindable var spec: SizeSpec

    var body: some View {
        SieveTestRow(title: "Size",
                     isNegated: $spec.isNegated) {
            PickerField(values: SieveTest.Comparison.allCases,
                        selection: $spec.comparison)
            InputField(placeholder: "Bytes", text: Binding(
                get: { String(spec.bytes) },
                set: { spec.bytes = Int($0) ?? 0 }
            ))
            Text("bytes")
        }
    }
}

#Preview {
    @Previewable @State var spec = SizeSpec()
    
    SizeTestRow(spec: spec)
        .padding()
}
