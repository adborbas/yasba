import SwiftUI

struct CommandImage: View {
    let systemName: String
    
    fileprivate enum Constants {
        static let iconSize: CGFloat = 18
        static let iconCornerRadius: CGFloat = 8
        static let iconPadding: CGFloat = 6
    }
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: Constants.iconSize, height: Constants.iconSize)
            .padding(Constants.iconPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.iconCornerRadius)
                    .fill(Color.gray)
            )
    }
}

#Preview {
    HStack {
        CommandImage(systemName: "folder")
        CommandImage(systemName: "tag.fill")
        CommandImage(systemName: "trash")
    }
    .padding()
}
