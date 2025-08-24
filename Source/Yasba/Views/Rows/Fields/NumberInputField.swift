import SwiftUI

struct NumberInputField: View {
    @Binding var value: Int
    var range: ClosedRange<Int>? = nil

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.allowsFloats = false
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        HStack(spacing: 6) {
            TextField("", value: $value, formatter: formatter)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .onChange(of: value) { _, newValue in
                    if let range { value = min(max(newValue, range.lowerBound), range.upperBound) }
                }

            Stepper("", value: $value, in: range ?? (Int(-1_000_000)...Int(1_000_000)))
                .labelsHidden()
                .fixedSize()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentColor.opacity(0.15))
        )
        .padding(.horizontal, 8).padding(.vertical, 4)
    }
}

#Preview {
    @Previewable @State var value: Int = 12
    
    NumberInputField(value: $value)
        .padding()
}
