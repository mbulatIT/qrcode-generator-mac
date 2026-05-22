import AppKit
import SwiftUI

struct LogoPreset: Identifiable, Hashable {
    enum Kind: Hashable {
        case none
        case symbol(name: String, tint: NSColor, background: NSColor, useCircle: Bool)
        case text(String, foreground: NSColor, background: NSColor?, scanMeStyle: ScanMeStyle?)
    }

    enum ScanMeStyle: Hashable {
        case stacked
        case stackedBold
        case framed
        case menu
        case fork
    }

    let id: String
    let title: String
    let kind: Kind
}

enum LogoPresets {
    static let all: [LogoPreset] = [
        .init(id: "none", title: "None", kind: .none),
        .init(id: "link", title: "Link",
              kind: .symbol(name: "link", tint: .white, background: NSColor(red: 0.51, green: 0.32, blue: 0.93, alpha: 1), useCircle: true)),
        .init(id: "location", title: "Location",
              kind: .symbol(name: "mappin.and.ellipse", tint: .white, background: NSColor(red: 0.86, green: 0.18, blue: 0.18, alpha: 1), useCircle: true)),
        .init(id: "mail", title: "Mail",
              kind: .symbol(name: "envelope.fill", tint: NSColor(red: 0.72, green: 0.42, blue: 0.10, alpha: 1), background: NSColor(red: 0.99, green: 0.78, blue: 0.27, alpha: 1), useCircle: true)),
        .init(id: "whatsapp", title: "Phone",
              kind: .symbol(name: "phone.fill", tint: .white, background: NSColor(red: 0.18, green: 0.78, blue: 0.36, alpha: 1), useCircle: true)),
        .init(id: "wifi", title: "Wi-Fi",
              kind: .symbol(name: "wifi", tint: .white, background: NSColor(red: 0.20, green: 0.51, blue: 0.95, alpha: 1), useCircle: true)),
        .init(id: "contact", title: "Contact",
              kind: .symbol(name: "person.text.rectangle.fill", tint: .white, background: NSColor(red: 0.07, green: 0.21, blue: 0.45, alpha: 1), useCircle: true)),
        .init(id: "paypal", title: "PayPal",
              kind: .text("P", foreground: NSColor(red: 0.0, green: 0.18, blue: 0.5, alpha: 1), background: nil, scanMeStyle: nil)),
        .init(id: "bitcoin", title: "Bitcoin",
              kind: .symbol(name: "bitcoinsign.circle.fill", tint: .white, background: NSColor(red: 0.95, green: 0.58, blue: 0.10, alpha: 1), useCircle: true)),
        .init(id: "scanme1", title: "Scan me",
              kind: .text("SCAN\nME", foreground: .black, background: nil, scanMeStyle: .stacked)),
        .init(id: "scanme2", title: "Scan me bold",
              kind: .text("SCAN\nME", foreground: .black, background: nil, scanMeStyle: .stackedBold)),
        .init(id: "framed", title: "Framed",
              kind: .text("", foreground: .black, background: nil, scanMeStyle: .framed)),
        .init(id: "menu", title: "Menu",
              kind: .text("MENU", foreground: .black, background: nil, scanMeStyle: .menu)),
        .init(id: "fork", title: "Restaurant",
              kind: .text("", foreground: .black, background: nil, scanMeStyle: .fork)),
    ]
    static func by(id: String) -> LogoPreset { all.first(where: { $0.id == id }) ?? all[0] }
}

enum LogoImageRenderer {
    static func image(for preset: LogoPreset, size: CGFloat = 256) -> NSImage? {
        switch preset.kind {
        case .none: return nil
        case .symbol(let name, let tint, let background, let useCircle):
            return symbolImage(name: name, tint: tint, background: background, useCircle: useCircle, size: size)
        case .text(let text, let fg, let bg, let scanStyle):
            return textImage(text: text, foreground: fg, background: bg, style: scanStyle, size: size)
        }
    }

    private static func symbolImage(name: String, tint: NSColor, background: NSColor, useCircle: Bool, size: CGFloat) -> NSImage? {
        let canvas = NSImage(size: NSSize(width: size, height: size))
        canvas.lockFocus()
        defer { canvas.unlockFocus() }

        let rect = NSRect(x: 0, y: 0, width: size, height: size)
        if useCircle {
            background.setFill()
            NSBezierPath(ovalIn: rect).fill()
        } else {
            background.setFill()
            rect.fill()
        }

        let cfg = NSImage.SymbolConfiguration(pointSize: size * 0.55, weight: .bold)
        guard let symbol = NSImage(systemSymbolName: name, accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else { return canvas }

        let tinted = symbol.tinted(with: tint)
        let symbolSize = tinted.size
        let scale = min(size * 0.6 / symbolSize.width, size * 0.6 / symbolSize.height)
        let drawSize = NSSize(width: symbolSize.width * scale, height: symbolSize.height * scale)
        let origin = NSPoint(x: (size - drawSize.width) / 2, y: (size - drawSize.height) / 2)
        tinted.draw(in: NSRect(origin: origin, size: drawSize),
                    from: .zero,
                    operation: .sourceOver,
                    fraction: 1.0)
        return canvas
    }

    private static func textImage(text: String, foreground: NSColor, background: NSColor?, style: LogoPreset.ScanMeStyle?, size: CGFloat) -> NSImage? {
        let canvas = NSImage(size: NSSize(width: size, height: size))
        canvas.lockFocus()
        defer { canvas.unlockFocus() }

        let rect = NSRect(x: 0, y: 0, width: size, height: size)
        (background ?? .white).setFill()
        rect.fill()

        let attr: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: size * 0.22, weight: .heavy),
            .foregroundColor: foreground,
            .paragraphStyle: { let p = NSMutableParagraphStyle(); p.alignment = .center; return p }(),
        ]

        switch style {
        case .framed:
            drawCornerBrackets(in: rect, color: foreground, lineWidth: size * 0.06)
            (text as NSString).draw(centeredIn: rect.insetBy(dx: size * 0.18, dy: size * 0.18), withAttributes: attr)
        case .menu:
            drawCornerBrackets(in: rect, color: foreground, lineWidth: size * 0.06)
            let menuAttr: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: size * 0.18, weight: .heavy),
                .foregroundColor: foreground,
                .paragraphStyle: { let p = NSMutableParagraphStyle(); p.alignment = .center; return p }(),
            ]
            ("MENU" as NSString).draw(centeredIn: rect.insetBy(dx: size * 0.2, dy: size * 0.2), withAttributes: menuAttr)
        case .fork:
            drawForkAndKnife(in: rect, color: foreground)
        case .stacked, .stackedBold, nil:
            let weight: NSFont.Weight = style == .stackedBold ? .black : .bold
            let textAttr: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: size * 0.22, weight: weight),
                .foregroundColor: foreground,
                .paragraphStyle: { let p = NSMutableParagraphStyle(); p.alignment = .center; return p }(),
            ]
            if style == .stacked || style == .stackedBold {
                drawCornerBrackets(in: rect, color: foreground, lineWidth: size * 0.05)
            }
            (text as NSString).draw(centeredIn: rect.insetBy(dx: size * 0.18, dy: size * 0.18), withAttributes: textAttr)
        }
        return canvas
    }

    private static func drawCornerBrackets(in rect: NSRect, color: NSColor, lineWidth: CGFloat) {
        color.setStroke()
        let path = NSBezierPath()
        path.lineWidth = lineWidth
        let len = min(rect.width, rect.height) * 0.22
        let pad = lineWidth / 2
        // top-left
        path.move(to: NSPoint(x: rect.minX + pad, y: rect.maxY - len - pad))
        path.line(to: NSPoint(x: rect.minX + pad, y: rect.maxY - pad))
        path.line(to: NSPoint(x: rect.minX + len + pad, y: rect.maxY - pad))
        // top-right
        path.move(to: NSPoint(x: rect.maxX - len - pad, y: rect.maxY - pad))
        path.line(to: NSPoint(x: rect.maxX - pad, y: rect.maxY - pad))
        path.line(to: NSPoint(x: rect.maxX - pad, y: rect.maxY - len - pad))
        // bottom-right
        path.move(to: NSPoint(x: rect.maxX - pad, y: rect.minY + len + pad))
        path.line(to: NSPoint(x: rect.maxX - pad, y: rect.minY + pad))
        path.line(to: NSPoint(x: rect.maxX - len - pad, y: rect.minY + pad))
        // bottom-left
        path.move(to: NSPoint(x: rect.minX + len + pad, y: rect.minY + pad))
        path.line(to: NSPoint(x: rect.minX + pad, y: rect.minY + pad))
        path.line(to: NSPoint(x: rect.minX + pad, y: rect.minY + len + pad))
        path.stroke()
    }

    private static func drawForkAndKnife(in rect: NSRect, color: NSColor) {
        let cfg = NSImage.SymbolConfiguration(pointSize: rect.width * 0.7, weight: .bold)
        guard let symbol = NSImage(systemSymbolName: "fork.knife", accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else { return }
        let tinted = symbol.tinted(with: color)
        let s = tinted.size
        let scale = min(rect.width * 0.7 / s.width, rect.height * 0.7 / s.height)
        let draw = NSSize(width: s.width * scale, height: s.height * scale)
        let origin = NSPoint(x: rect.midX - draw.width / 2, y: rect.midY - draw.height / 2)
        tinted.draw(in: NSRect(origin: origin, size: draw),
                    from: .zero,
                    operation: .sourceOver,
                    fraction: 1)
    }
}

private extension NSString {
    func draw(centeredIn rect: NSRect, withAttributes attrs: [NSAttributedString.Key: Any]) {
        let size = self.size(withAttributes: attrs)
        let origin = NSPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        self.draw(at: origin, withAttributes: attrs)
    }
}

extension NSImage {
    func tinted(with color: NSColor) -> NSImage {
        let result = NSImage(size: size)
        result.lockFocus()
        defer { result.unlockFocus() }
        color.set()
        let rect = NSRect(origin: .zero, size: size)
        self.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1)
        rect.fill(using: .sourceAtop)
        return result
    }
}
