import SwiftUI

struct PlaceholderRowView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 12
        static let height: CGFloat = 32
    }
    
    var body: some View {
        HStack { Spacer() }
            .frame(height: Constants.height)
            .padding(Constants.padding)
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(Color.clear).ignoresSafeArea()
            )
            .overlay(
                AnimatedDashedBorder(cornerRadius: Constants.cornerRadius, stroke: Color.gray.opacity(0.4))
            )
    }
}

#Preview {
    PlaceholderRowView()
        .padding(12)
}
