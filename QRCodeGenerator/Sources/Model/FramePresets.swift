import AppKit
import CoreGraphics

enum FrameStyle: String, Hashable {
    case none
    case barBelow
    case barBelowRounded
    case outlinedBar
    case circle
    case phone
    case speech
}

struct FramePreset: Identifiable, Hashable {
    let id: String
    let title: String
    let style: FrameStyle
}

enum FramePresets {
    static let all: [FramePreset] = [
        .init(id: "none", title: "None", style: .none),
        .init(id: "barBelow", title: "Bar below", style: .barBelow),
        .init(id: "barBelowRounded", title: "Bar below rounded", style: .barBelowRounded),
        .init(id: "outlinedBar", title: "Outlined bar", style: .outlinedBar),
        .init(id: "circle", title: "Circle", style: .circle),
        .init(id: "phone", title: "Phone", style: .phone),
        .init(id: "speech", title: "Speech", style: .speech),
    ]
    static func by(id: String) -> FramePreset { all.first(where: { $0.id == id }) ?? all[0] }
}
