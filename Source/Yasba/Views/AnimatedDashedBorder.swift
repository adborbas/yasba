import SwiftUI

struct AnimatedDashedBorder: View {
    let cornerRadius: CGFloat
    let stroke: Color
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                stroke,
                style: StrokeStyle(
                    lineWidth: 2,
                    dash: [6, 4],
                    dashPhase: phase
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    phase -= 10
                }
            }
    }
}
