import SwiftUI
import WebKit

struct SedivaoBeiwWeb: View {
    let sedivaoBeiwWebUrlString: String

    var body: some View {
        VStack(spacing: 0) {
            GrooveStreakTopNavigationBar(title: nil)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

            if let sedivaoBeiwWebUrl = sedivaoBeiwWebResolvedUrl {
                SedivaoBeiwWebContainer(sedivaoBeiwWebUrl: sedivaoBeiwWebUrl)
                    .background(
                        Color.white
                    )
            } else {
                VStack(spacing: 12) {
                    Text("Invalid URL")
                        .font(ZiveStyle.FontBook.boldItalic(20))
                        .foregroundStyle(ZiveStyle.ColorPalette.white)

                    Text(sedivaoBeiwWebUrlString)
                        .font(ZiveStyle.FontBook.regular(14))
                        .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ziveScreenBackground()
        .navigationBarHidden(true)
    }

    private var sedivaoBeiwWebResolvedUrl: URL? {
        if let sedivaoBeiwWebDirectUrl = URL(string: sedivaoBeiwWebUrlString),
           sedivaoBeiwWebDirectUrl.scheme != nil {
            return sedivaoBeiwWebDirectUrl
        }

        return URL(string: sedivaoBeiwWebUrlString)
    }
}

struct SedivaoBeiwWebContainer: UIViewRepresentable {
    let sedivaoBeiwWebUrl: URL

    func makeUIView(context: Context) -> WKWebView {
        let sedivaoBeiwWebView = WKWebView()
        sedivaoBeiwWebView.backgroundColor = .clear
        sedivaoBeiwWebView.isOpaque = false
        sedivaoBeiwWebView.scrollView.backgroundColor = .clear
        sedivaoBeiwWebView.load(URLRequest(url: sedivaoBeiwWebUrl))
        return sedivaoBeiwWebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard uiView.url != sedivaoBeiwWebUrl else { return }
        uiView.load(URLRequest(url: sedivaoBeiwWebUrl))
    }
}
