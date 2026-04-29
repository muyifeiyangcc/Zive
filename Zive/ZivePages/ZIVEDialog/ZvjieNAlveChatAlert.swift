import SwiftUI

struct ZvjieNAlveChatAlert: View {
    @Binding var zvjieNAlveIsPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    zvjieNAlveIsPresented = false
                }

            VStack(spacing: 0) {
                Text("You can only chat with each other after following each other.")
                    .font(ZiveStyle.FontBook.regular(16))
                    .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1)
                    .padding(.top, 24)
                    .padding(.horizontal, 40)
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [
                            Color(red: 1, green: 244/255, blue: 235/255),
                            Color(red: 1, green: 199/255, blue: 220/255)
                        ], startPoint: .trailing, endPoint: .leading))
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [
                            ZiveStyle.ColorPalette.brandOrange,
                            ZiveStyle.ColorPalette.brandPink
                        ], startPoint: .trailing, endPoint: .leading))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .blur(radius: 4)
                    Text("Sure")
                        .font(ZiveStyle.FontBook.boldItalic(20))
                        .foregroundStyle(Color(red: 1, green: 235/255, blue: 235/255))
                }.frame(height: 53)
                    .onTapGesture {
                        zvjieNAlveIsPresented = false
                    }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)

                
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
            .padding(.horizontal, 23)
        }
        .transition(.opacity)
    }
}
