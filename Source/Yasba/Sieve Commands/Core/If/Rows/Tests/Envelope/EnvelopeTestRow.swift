import SwiftUI

/**
 View for editing an `EnvelopeSpec`.
 */
struct EnvelopeTestRow: View {
    @Bindable var spec: EnvelopeSpec
    
    var body: some View {
        SieveTestRow(title: "Envelope",
                     isNegated: $spec.isNegated) {
            PickerField(values: SieveTest.AddressPart.allCases,
                        selection: $spec.part)
            PickerField(values: SieveTest.MatchType.allCases,
                        selection: $spec.match)
            InputFieldList(items: $spec.names, placeholder: "Field")
            InputFieldList(items: $spec.keys, placeholder: "Value")
        }
    }
}

#Preview("Envelope – From contains") {
    @Previewable @State var spec = EnvelopeSpec(
        part: .all,
        names: ["from"],
        match: .contains,
        keys: ["noreply@example.com"]
    )
    
    EnvelopeTestRow(spec: spec)
        .padding()
}
