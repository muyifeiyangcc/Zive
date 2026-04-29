import SwiftUI

struct GrooveStreakTopNavigationBar: View {

    let title: String?
    var showsBackButton: Bool = true
    var onBack: (() -> Void)? = nil
    @EnvironmentObject var grooveStrekNaviGator: WeioZwivbeNavigator

    var body: some View {
        HStack(spacing: 14) {
            if showsBackButton {
                Button {
                    if let onBack {
                        onBack()
                    } else {
                        grooveStrekNaviGator.weioZwivbePop()
                    }
                } label: {
                    Image("ZIVEBack")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }

            if let title, !title.isEmpty {
                Text(title)
                    .font(ZiveStyle.FontBook.boldItalic(18))
                    .foregroundStyle(ZiveStyle.ColorPalette.white)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if showsBackButton {
                SwixoanAliwSwipeBack()
                    .allowsHitTesting(false)
            }
        }
    }
}
