import SwiftUI

struct GrooveStreakButton: View {
    let title: String
    var width: CGFloat? = nil
    var height: CGFloat = 58
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(ZiveStyle.FontBook.boldItalic(18))
                .foregroundStyle(ZiveStyle.ColorPalette.white)
                .frame(width: width, height: height)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.23))
                        LinearGradient(
                            colors: [
                                ZiveStyle.ColorPalette.brandPink,
                                ZiveStyle.ColorPalette.brandOrange
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .blur(radius: 8)
                    }
                    
                )
                
        }
        .buttonStyle(.plain)
    }
}
