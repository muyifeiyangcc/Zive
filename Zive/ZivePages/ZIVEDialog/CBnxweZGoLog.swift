import SwiftUI
import Combine

final class CBnxweZGoLogCenter: ObservableObject {
    @Published var CBnxweZGoLogIsPresented = false

    func CBnxweZGoLogPresent() {
        CBnxweZGoLogIsPresented = true
    }

    func CBnxweZGoLogRequireLogin(_ action: () -> Void) {
        if QeixbgBriwyState.qeixbgBriwyIsGuestUser() {
            CBnxweZGoLogPresent()
            return
        }

        action()
    }
}

struct CBnxweZGoLog: View {
    @Binding var CBnxweZIsPresented: Bool
    var CBnxweZOnLogin: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    CBnxweZIsPresented = false
                }

            VStack(spacing: 0) {
                Text("Please log in")
                    .font(ZiveStyle.FontBook.boldItalic(20))
                    .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)
                    .padding(.top, 24)
                Text("To ensure the normal operation of \nthe function, please log in to your \naccount first.")
                    .font(ZiveStyle.FontBook.regular(17))
                    .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1)
                    .padding(.top, 24)
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
                    Text("Log In")
                        .font(ZiveStyle.FontBook.boldItalic(20))
                        .foregroundStyle(Color(red: 1, green: 235/255, blue: 235/255))
                }.frame(height: 53)
                    .onTapGesture {
                        CBnxweZIsPresented = false
                        CBnxweZOnLogin()
                    }
                .padding(.top, 22)
                .padding(.horizontal, 16)

                Button("Cancel") {
                    CBnxweZIsPresented = false
                }
                .buttonStyle(.plain)
                .font(ZiveStyle.FontBook.regular(17))
                .foregroundStyle(ZiveStyle.ColorPalette.textPrimary.opacity(0.52))
                .padding(.top, 18)
                .padding(.bottom, 23)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
            .padding(.horizontal, 23)
        }
        .transition(.opacity)
    }
}
