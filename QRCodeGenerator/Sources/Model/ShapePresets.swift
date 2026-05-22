import Foundation
import QRCode

struct DotsPreset: Identifiable, Hashable {
    let id: String
    let title: String
    let make: @Sendable () -> any QRCodePixelShapeGenerator

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: DotsPreset, rhs: DotsPreset) -> Bool { lhs.id == rhs.id }
}

enum DotsPresets {
    static let all: [DotsPreset] = [
        .init(id: "square", title: "Square") { QRCode.PixelShape.Square() },
        .init(id: "rounded", title: "Rounded") { QRCode.PixelShape.RoundedRect(cornerRadiusFraction: 0.45) },
        .init(id: "horizontal", title: "Horizontal") { QRCode.PixelShape.Horizontal(insetFraction: 0.05, cornerRadiusFraction: 0.6) },
        .init(id: "vertical", title: "Vertical") { QRCode.PixelShape.Vertical(insetFraction: 0.05, cornerRadiusFraction: 0.6) },
        .init(id: "pointy", title: "Pointy") { QRCode.PixelShape.Pointy() },
        .init(id: "curve", title: "Curve") { QRCode.PixelShape.CurvePixel() },
        .init(id: "blob", title: "Blob") { QRCode.PixelShape.Blob() },
        .init(id: "stitch", title: "Stitch") { QRCode.PixelShape.Stitch() },
        .init(id: "sharp", title: "Sharp") { QRCode.PixelShape.Sharp() },
        .init(id: "abstract", title: "Abstract") { QRCode.PixelShape.Abstract() },
        .init(id: "circle", title: "Circle") { QRCode.PixelShape.Circle() },
        .init(id: "star", title: "Star") { QRCode.PixelShape.Star() },
        .init(id: "flower", title: "Flower") { QRCode.PixelShape.Flower() },
        .init(id: "spikyCircle", title: "Spiky Circle") { QRCode.PixelShape.SpikyCircle() },
        .init(id: "heart", title: "Heart") { QRCode.PixelShape.Heart() },
        .init(id: "diamond", title: "Diamond") { QRCode.PixelShape.Diamond() },
        .init(id: "hexagon", title: "Hexagon") { QRCode.PixelShape.Hexagon() },
        .init(id: "shiny", title: "Shiny") { QRCode.PixelShape.Shiny() },
        .init(id: "gear", title: "Gear") { QRCode.PixelShape.Gear() },
    ]
    static func by(id: String) -> DotsPreset { all.first(where: { $0.id == id }) ?? all[0] }
}

struct EyeBorderPreset: Identifiable, Hashable {
    let id: String
    let title: String
    let make: @Sendable () -> any QRCodeEyeShapeGenerator

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: EyeBorderPreset, rhs: EyeBorderPreset) -> Bool { lhs.id == rhs.id }
}

enum EyeBorderPresets {
    static let all: [EyeBorderPreset] = [
        .init(id: "square", title: "Square") { QRCode.EyeShape.Square() },
        .init(id: "roundedRect", title: "Rounded square") { QRCode.EyeShape.RoundedRect() },
        .init(id: "circle", title: "Circle") { QRCode.EyeShape.Circle() },
        .init(id: "edges", title: "Edges") { QRCode.EyeShape.Edges() },
        .init(id: "corneredPixels", title: "Cornered") { QRCode.EyeShape.CorneredPixels() },
        .init(id: "leaf", title: "Leaf") { QRCode.EyeShape.Leaf() },
        .init(id: "teardrop", title: "Teardrop") { QRCode.EyeShape.Teardrop() },
        .init(id: "squircle", title: "Squircle") { QRCode.EyeShape.Squircle() },
        .init(id: "roundedOuter", title: "Rounded outer") { QRCode.EyeShape.RoundedOuter() },
        .init(id: "roundedPointingIn", title: "Pointing in") { QRCode.EyeShape.RoundedPointingIn() },
        .init(id: "roundedPointingOut", title: "Pointing out") { QRCode.EyeShape.RoundedPointingOut() },
        .init(id: "squarePeg", title: "Square peg") { QRCode.EyeShape.SquarePeg() },
        .init(id: "shield", title: "Shield") { QRCode.EyeShape.Shield() },
        .init(id: "spikyCircle", title: "Spiky circle") { QRCode.EyeShape.SpikyCircle() },
        .init(id: "explode", title: "Explode") { QRCode.EyeShape.Explode() },
    ]
    static func by(id: String) -> EyeBorderPreset { all.first(where: { $0.id == id }) ?? all[0] }
}

struct EyeCenterPreset: Identifiable, Hashable {
    let id: String
    let title: String
    let make: @Sendable () -> any QRCodePupilShapeGenerator

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: EyeCenterPreset, rhs: EyeCenterPreset) -> Bool { lhs.id == rhs.id }
}

enum EyeCenterPresets {
    static let all: [EyeCenterPreset] = [
        .init(id: "square", title: "Square") { QRCode.PupilShape.Square() },
        .init(id: "roundedRect", title: "Rounded square") { QRCode.PupilShape.RoundedRect() },
        .init(id: "circle", title: "Circle") { QRCode.PupilShape.Circle() },
        .init(id: "pixels", title: "Pixels") { QRCode.PupilShape.Pixels() },
        .init(id: "corneredPixels", title: "Cornered") { QRCode.PupilShape.CorneredPixels() },
        .init(id: "leaf", title: "Leaf") { QRCode.PupilShape.Leaf() },
        .init(id: "teardrop", title: "Teardrop") { QRCode.PupilShape.Teardrop() },
        .init(id: "squircle", title: "Squircle") { QRCode.PupilShape.Squircle() },
        .init(id: "roundedOuter", title: "Rounded outer") { QRCode.PupilShape.RoundedOuter() },
        .init(id: "spikyCircle", title: "Spiky circle") { QRCode.PupilShape.SpikyCircle() },
        .init(id: "blobby", title: "Blob") { QRCode.PupilShape.Blobby() },
        .init(id: "cross", title: "Cross") { QRCode.PupilShape.Cross() },
        .init(id: "crossCurved", title: "Cross curved") { QRCode.PupilShape.CrossCurved() },
        .init(id: "seal", title: "Seal") { QRCode.PupilShape.Seal() },
        .init(id: "heart", title: "Heart") { QRCode.PupilShape.Heart() },
        .init(id: "hexagonLeaf", title: "Hexagon leaf") { QRCode.PupilShape.HexagonLeaf() },
        .init(id: "gear", title: "Gear") { QRCode.PupilShape.Gear() },
    ]
    static func by(id: String) -> EyeCenterPreset { all.first(where: { $0.id == id }) ?? all[0] }
}
