import SwiftUI
import QRCode

@MainActor
final class QRDesign: ObservableObject {
    @Published var content: String = "https://example.com"
    @Published var errorCorrection: QRCode.ErrorCorrection = .high

    @Published var dotsPresetID: String = DotsPresets.all[0].id
    @Published var dotsColor: Color = .black
    @Published var useGradient: Bool = false
    @Published var gradientEndColor: Color = Color(red: 0.18, green: 0.45, blue: 0.95)
    @Published var backgroundColor: Color = .white
    @Published var transparentBackground: Bool = false

    @Published var eyeBorderPresetID: String = EyeBorderPresets.all[0].id
    @Published var eyeBorderColor: Color = .black
    @Published var eyeCenterPresetID: String = EyeCenterPresets.all[0].id
    @Published var eyeCenterColor: Color = .black

    @Published var logoPresetID: String = LogoPresets.all[0].id
    @Published var customLogoData: Data? = nil
    @Published var removeBackgroundBehindLogo: Bool = true

    @Published var framePresetID: String = FramePresets.all[0].id
    @Published var framePhrase: String = "SCAN ME"
    @Published var framePhraseFont: PhraseFont = .sansSerif
    @Published var frameColor: Color = .black
}

enum PhraseFont: String, CaseIterable, Identifiable {
    case sansSerif = "Sans-Serif"
    case serif = "Serif"
    case rounded = "Rounded"
    case monospaced = "Monospaced"

    var id: String { rawValue }

    var nsFont: NSFont {
        switch self {
        case .sansSerif:
            return NSFont.systemFont(ofSize: 48, weight: .bold)
        case .serif:
            return NSFont(name: "Georgia-Bold", size: 48) ?? NSFont.systemFont(ofSize: 48, weight: .bold)
        case .rounded:
            return NSFont.systemFont(ofSize: 48, weight: .heavy).withRoundedDesign() ?? NSFont.systemFont(ofSize: 48, weight: .heavy)
        case .monospaced:
            return NSFont.monospacedSystemFont(ofSize: 48, weight: .bold)
        }
    }
}

private extension NSFont {
    func withRoundedDesign() -> NSFont? {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else { return nil }
        return NSFont(descriptor: descriptor, size: pointSize)
    }
}
