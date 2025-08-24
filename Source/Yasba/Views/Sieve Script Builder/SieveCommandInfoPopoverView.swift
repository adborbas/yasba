import SwiftUI

struct SieveCommandInfoPopoverView: View {
    fileprivate enum Constants {
        static let iconSize: CGFloat = 18
        static let iconCornerRadius: CGFloat = 8
        static let iconPadding: CGFloat = 6
    }
    
    let icon: String
    let title: String
    let info: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
                    .padding(Constants.iconPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.iconCornerRadius)
                            .fill(Color.gray)
                    )
                
                Text(title)
                    .font(.title2)
            }
            Text(info)
        }.padding()
    }
}

#Preview {
    SieveCommandInfoPopoverView(icon: "stop",
                                title: "Stop",
                                info: "The \"stop\" action ends all processing.")
}
