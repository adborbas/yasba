enum EditableTestSpecFactory {
    static func wrap(_ test: SieveTest) -> AnyTestSpec {
        switch test.primitive {
        case .boolean:
            return AnyTestSpec(BooleanSpec(from: test))

        case .header:
            return AnyTestSpec(HeaderSpec(from: test))

        case .exists:
            return AnyTestSpec(ExistsSpec(from: test))

        case .size:
            return AnyTestSpec(SizeSpec(from: test))

        case .address:
            return AnyTestSpec(AddressSpec(from: test))

        case .envelope:
            return AnyTestSpec(EnvelopeSpec(from: test))
        }
    }
}
