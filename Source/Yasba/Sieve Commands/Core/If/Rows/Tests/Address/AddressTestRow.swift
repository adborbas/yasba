import SwiftUI

/**
 View for editing an `AddressSpec`.
 */
struct AddressTestRow: View {
    @Bindable var spec: AddressSpec
    
    var body: some View {
        SieveTestRow(title: "Address",
                     isNegated: $spec.isNegated) {
            PickerField(values: SieveTest.MatchType.allCases,
                        selection: $spec.match)
            PickerField(values: SieveTest.AddressPart.allCases,
                        selection: $spec.part)
            InputFieldList(items: $spec.names, placeholder: "Header")
            InputFieldList(items: $spec.keys, placeholder: "Key")
        }
    }
}

#Preview {
    @Previewable @State var spec = AddressSpec(part: .all, names: ["name1", "name2"], match: .is, keys: ["key1"])
    
    AddressTestRow(spec: spec)
        .padding()
}
