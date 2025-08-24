import SwiftUI

/**
 View for editing an `HeaderSpec`.
 */
struct HeaderTestRow: View {
    @Bindable var spec: HeaderSpec

    var body: some View {
        SieveTestRow(title: "Header",
                     isNegated: $spec.isNegated) {
            InputFieldList(items: $spec.names, placeholder: "Header name")
            PickerField(values: SieveTest.MatchType.allCases,
                        selection: $spec.match)
            InputFieldList(items: $spec.keys, placeholder: "Value")
        }
    }
}
