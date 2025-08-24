import SwiftUI

/**
 Builds the concrete SwiftUI row view for a given `AnyTestSpec`.
 */
enum TestRowFactory {
    @ViewBuilder
    static func make(for spec: AnyTestSpec) -> some View {
        if let boolean = spec.base(as: BooleanSpec.self) {
            BooleanTestRow(spec: boolean)
        } else if let header = spec.base(as: HeaderSpec.self) {
            HeaderTestRow(spec: header)
        } else if let exists = spec.base(as: ExistsSpec.self) {
            ExistsTestRow(spec: exists)
        } else if let size = spec.base(as: SizeSpec.self) {
            SizeTestRow(spec: size)
        } else if let address = spec.base(as: AddressSpec.self) {
            AddressTestRow(spec: address)
        } else if let envelope = spec.base(as: EnvelopeSpec.self) {
            EnvelopeTestRow(spec: envelope)
        } else {
            fatalError("Unsupported test spec: \(spec)")
        }
    }
}
