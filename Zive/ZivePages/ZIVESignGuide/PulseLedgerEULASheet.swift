import SwiftUI

struct PulseLedgerEULASheet: View {
    @AppStorage("qeixbgBriwyAgreeEULA") var qeixbgBriwyAgreeEULA = false
    @Binding var pulseLedgerEULAIsPresented: Bool
    @State private var pulseLedgerEULAHasRead = false

    var body: some View {
        GeometryReader { pulseLedgerEULAGeometry in
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        pulseLedgerEULAIsPresented = false
                    }

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            Text("This End User License Agreement (EULA) governs your use of the Zive Application (the \"App\").")
                                .font(ZiveStyle.FontBook.regular(19))
                                .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("""
Zive is a dance video sharing platform. By downloading, accessing or using the App, you agree to be bound by this Agreement. If you do not agree to these terms, you may not use this application.

1. Qualifications

By using the Zive App, you confirm that you are at least 18 years of age. You agree to provide true and accurate age information. If you are under 18, you need the express consent of a parent or legal guardian to use the App.

2. User Generated Content

This app allows users to shoot, edit and share dance-related content (such as dance videos, tutorials, photos, etc.).By Posting content, you agree to the following terms:

2.1 Prohibited Content
You may not post any content that is offensive, harmful or illegal, including but not limited to:- Hate speech, abuse, harassment or personal attacks;- Pornographic, explicit or vulgar content;- Content that promotes violence, discrimination, illegal activities or violations of the rights of others;- Content that infringes on the copyright of dance works or other intellectual property rights;- Any content that violates public order and good customs or is inconsistent with the dance community atmosphere.

2.2 Content Licensing
You retain ownership of the content posted, but by Posting, you grant Zive a non-exclusive license to use, distribute, display, and provide content-related services within the App.

3. Reporting and Response Mechanism

3.1 Your Responsibilities
If you find User content that violates this EULA, you agree to report it immediately through Zive's reporting mechanism.

3.2 Our ResponseWe will review the reported content within 24 hours and take appropriate measures, including but not limited to removing the offending content, warning or banning the offending user. Repeated violations may result in permanent suspension.

4. Privacy Policy

By using the App, you acknowledge that you have read and understood our [Privacy Policy], which details how we collect, use and protect your personal information.

5. Terminate

We may terminate or suspend your access to Zive at any time, with or without prior notice. You can also stop using Zive and delete your account at any time.

6. Modification of the agreement

We may amend this Agreement at any time. Changes will be announced in the App, and your continued use of the App means your acceptance of the revised terms.

7. Disclaimer

Zive is provided "AS IS" without warranties of any kind, express or implied. We do not guarantee that the application will always be interruption-free, error-free or completely secure.

8. Limitation of liability

To the fullest extent permitted by law, we are not liable for any damage caused by your use of Zive.
""")
                                .font(ZiveStyle.FontBook.regular(15))
                                .foregroundStyle(ZiveStyle.ColorPalette.textPrimary.opacity(0.92))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 18)
                        .padding(.bottom, 14)
                    }
                    .frame(maxHeight: 390)

                    HStack(spacing: 8) {
                        Button {
                            pulseLedgerEULAHasRead.toggle()
                        } label: {
                            Circle()
                                .fill(
                                    pulseLedgerEULAHasRead
                                    ? LinearGradient(
                                        colors: [
                                            ZiveStyle.ColorPalette.brandPink,
                                            ZiveStyle.ColorPalette.brandOrange
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    : LinearGradient(
                                        colors: [Color.black.opacity(0.08), Color.black.opacity(0.08)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 20, height: 20)
                                .overlay {
                                    if pulseLedgerEULAHasRead {
                                        Circle()
                                            .fill(Color.white.opacity(0.55))
                                            .frame(width: 8, height: 8)
                                            .blur(radius: 10)
                                    }
                                }
                    }
                    .buttonStyle(.plain)
                        Text("I have read and agree to the EULA")
                            .font(ZiveStyle.FontBook.regular(14))
                            .foregroundStyle(ZiveStyle.ColorPalette.textPrimary.opacity(0.92))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    HStack(spacing: 14) {
                        Button("Cancel") {
                            pulseLedgerEULAIsPresented = false
                        }
                        .buttonStyle(.plain)
                        .font(ZiveStyle.FontBook.regular(16))
                        .foregroundStyle(ZiveStyle.ColorPalette.textPrimary.opacity(0.65))
                        Button(action: {
                            if pulseLedgerEULAHasRead {
                                qeixbgBriwyAgreeEULA = true
                                pulseLedgerEULAIsPresented = false
                            }
                            
                        }) {
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
                                Text("Agree")
                                    .font(ZiveStyle.FontBook.boldItalic(20))
                                    .foregroundStyle(Color(red: 1, green: 235/255, blue: 235/255))
                            }.frame(height: 53)
                            .opacity(pulseLedgerEULAHasRead ? 1 : 0.55)
                            .allowsHitTesting(pulseLedgerEULAHasRead)
                        }
                        

                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 24 + pulseLedgerEULAGeometry.safeAreaInsets.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(
                    ZStack(alignment: .top) {
                        Color.white
                        Image("ZIVECardBg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 295)
                    }
                )
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    PulseLedgerEULASheet(
        pulseLedgerEULAIsPresented: .constant(true),
    )
}
