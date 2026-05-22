import AppKit
import CoreGraphics
import QRCode
import SwiftUI

@MainActor
enum QRRenderer {
    static func render(design: QRDesign, pixelSize: CGFloat = 1024) -> NSImage? {
        guard let document = makeDocument(from: design) else { return nil }
        let qrBaseSize = qrInsetSize(for: design, totalSize: pixelSize)
        guard let qrCG = try? document.cgImage(CGSize(width: qrBaseSize, height: qrBaseSize)) else {
            return nil
        }

        let canvasSize = CGSize(width: pixelSize, height: pixelSize)
        let image = NSImage(size: canvasSize)
        image.lockFocus()
        defer { image.unlockFocus() }
        guard let ctx = NSGraphicsContext.current?.cgContext else { return image }
        ctx.interpolationQuality = .high

        let frameStyle = FramePresets.by(id: design.framePresetID).style
        drawFrameBackground(ctx: ctx, size: canvasSize, design: design, style: frameStyle)

        let qrRect = qrFrameRect(for: frameStyle, in: CGRect(origin: .zero, size: canvasSize))
        ctx.draw(qrCG, in: qrRect)

        if !design.removeBackgroundBehindLogo,
           let logoImage = currentLogoImage(design: design) {
            drawLogo(logoImage, in: qrRect, ctx: ctx)
        }

        drawFrameOverlay(ctx: ctx, size: canvasSize, design: design, style: frameStyle)

        return image
    }

    private static func currentLogoImage(design: QRDesign) -> NSImage? {
        if let data = design.customLogoData, let img = NSImage(data: data) {
            return img
        }
        let preset = LogoPresets.by(id: design.logoPresetID)
        return LogoImageRenderer.image(for: preset)
    }

    private static func drawLogo(_ logo: NSImage, in qrRect: CGRect, ctx: CGContext) {
        let logoSide = qrRect.width * 0.22
        let center = CGPoint(x: qrRect.midX, y: qrRect.midY)
        let rect = CGRect(x: center.x - logoSide / 2,
                          y: center.y - logoSide / 2,
                          width: logoSide,
                          height: logoSide)
        if let cg = logo.toCGImage() {
            ctx.saveGState()
            ctx.draw(cg, in: rect)
            ctx.restoreGState()
        }
    }

    private static func qrInsetSize(for design: QRDesign, totalSize: CGFloat) -> CGFloat {
        let style = FramePresets.by(id: design.framePresetID).style
        switch style {
        case .none: return totalSize
        case .barBelow, .barBelowRounded: return totalSize * 0.82
        case .outlinedBar: return totalSize * 0.78
        case .circle: return totalSize * 0.7
        case .phone: return totalSize * 0.72
        case .speech: return totalSize * 0.75
        }
    }

    private static func qrFrameRect(for style: FrameStyle, in bounds: CGRect) -> CGRect {
        let size = bounds.width
        switch style {
        case .none:
            return bounds
        case .barBelow, .barBelowRounded:
            let qrSize = size * 0.82
            let x = (size - qrSize) / 2
            let y = size - qrSize - size * 0.02
            return CGRect(x: x, y: y, width: qrSize, height: qrSize)
        case .outlinedBar:
            let qrSize = size * 0.78
            let x = (size - qrSize) / 2
            let y = size - qrSize - size * 0.04
            return CGRect(x: x, y: y, width: qrSize, height: qrSize)
        case .circle:
            let qrSize = size * 0.7
            return CGRect(x: (size - qrSize) / 2, y: (size - qrSize) / 2, width: qrSize, height: qrSize)
        case .phone:
            let qrSize = size * 0.72
            return CGRect(x: (size - qrSize) / 2, y: size * 0.18, width: qrSize, height: qrSize)
        case .speech:
            let qrSize = size * 0.75
            let x = (size - qrSize) / 2
            let y = size - qrSize - size * 0.02
            return CGRect(x: x, y: y, width: qrSize, height: qrSize)
        }
    }

    private static func drawFrameBackground(ctx: CGContext, size: CGSize, design: QRDesign, style: FrameStyle) {
        // Outer background — always white unless transparent for none style
        if style == .none {
            return
        }
        ctx.saveGState()
        NSColor.white.setFill()
        ctx.fill(CGRect(origin: .zero, size: size))
        ctx.restoreGState()
    }

    private static func drawFrameOverlay(ctx: CGContext, size: CGSize, design: QRDesign, style: FrameStyle) {
        guard style != .none else { return }
        let bounds = CGRect(origin: .zero, size: size)
        let cg = NSColor(design.frameColor).cgColor
        let phrase = design.framePhrase
        let font = design.framePhraseFont.nsFont

        ctx.saveGState()
        defer { ctx.restoreGState() }

        switch style {
        case .none: break

        case .barBelow:
            let barRect = CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.14)
            ctx.setFillColor(cg)
            ctx.fill(barRect)
            drawText(phrase, color: .white, font: font, in: barRect, ctx: ctx)

        case .barBelowRounded:
            let barRect = CGRect(x: size.width * 0.08, y: size.height * 0.02,
                                 width: size.width * 0.84, height: size.height * 0.12)
            ctx.setFillColor(cg)
            let path = CGPath(roundedRect: barRect, cornerWidth: barRect.height / 2, cornerHeight: barRect.height / 2, transform: nil)
            ctx.addPath(path); ctx.fillPath()
            drawText(phrase, color: .white, font: font, in: barRect, ctx: ctx)

        case .outlinedBar:
            let outline = bounds.insetBy(dx: size.width * 0.04, dy: size.width * 0.04)
            ctx.setStrokeColor(cg)
            ctx.setLineWidth(size.width * 0.012)
            let path = CGPath(roundedRect: outline, cornerWidth: size.width * 0.04, cornerHeight: size.width * 0.04, transform: nil)
            ctx.addPath(path); ctx.strokePath()
            let barRect = CGRect(x: outline.minX, y: outline.minY,
                                 width: outline.width, height: size.height * 0.13)
            ctx.setFillColor(cg)
            let barPath = CGPath(roundedRect: barRect, cornerWidth: size.width * 0.04, cornerHeight: size.width * 0.04, transform: nil)
            ctx.addPath(barPath); ctx.fillPath()
            drawText(phrase, color: .white, font: font, in: barRect, ctx: ctx)

        case .circle:
            ctx.setStrokeColor(cg)
            ctx.setLineWidth(size.width * 0.015)
            let circleRect = bounds.insetBy(dx: size.width * 0.04, dy: size.width * 0.04)
            ctx.addEllipse(in: circleRect)
            ctx.strokePath()
            let textRect = CGRect(x: 0, y: size.height * 0.06,
                                  width: size.width, height: size.height * 0.08)
            drawText(phrase, color: NSColor(design.frameColor), font: font, in: textRect, ctx: ctx)

        case .phone:
            let phoneRect = bounds.insetBy(dx: size.width * 0.1, dy: size.width * 0.03)
            ctx.setStrokeColor(cg)
            ctx.setLineWidth(size.width * 0.012)
            let path = CGPath(roundedRect: phoneRect, cornerWidth: size.width * 0.05, cornerHeight: size.width * 0.05, transform: nil)
            ctx.addPath(path); ctx.strokePath()
            // Notch / speaker line
            let speaker = CGRect(x: size.width * 0.42, y: phoneRect.maxY - size.height * 0.04,
                                 width: size.width * 0.16, height: size.height * 0.012)
            ctx.setFillColor(cg)
            ctx.addPath(CGPath(roundedRect: speaker, cornerWidth: speaker.height / 2, cornerHeight: speaker.height / 2, transform: nil))
            ctx.fillPath()
            // Bottom phrase
            let textRect = CGRect(x: phoneRect.minX, y: phoneRect.minY + size.height * 0.02,
                                  width: phoneRect.width, height: size.height * 0.08)
            drawText(phrase, color: NSColor(design.frameColor), font: font, in: textRect, ctx: ctx)

        case .speech:
            // rounded outline + tail
            let frame = bounds.insetBy(dx: size.width * 0.04, dy: size.width * 0.04)
            let bubble = CGMutablePath()
            bubble.addRoundedRect(in: frame, cornerWidth: size.width * 0.06, cornerHeight: size.width * 0.06)
            ctx.setStrokeColor(cg)
            ctx.setLineWidth(size.width * 0.012)
            ctx.addPath(bubble); ctx.strokePath()
            // bar at bottom
            let barRect = CGRect(x: frame.minX, y: frame.minY,
                                 width: frame.width, height: size.height * 0.12)
            ctx.setFillColor(cg)
            let barPath = CGPath(roundedRect: barRect, cornerWidth: size.width * 0.04, cornerHeight: size.width * 0.04, transform: nil)
            ctx.addPath(barPath); ctx.fillPath()
            drawText(phrase, color: .white, font: font, in: barRect, ctx: ctx)
        }
    }

    private static func drawText(_ text: String, color: NSColor, font: NSFont, in rect: CGRect, ctx: CGContext) {
        guard !text.isEmpty else { return }
        // Auto size font based on rect height
        let scaledFont = NSFont(descriptor: font.fontDescriptor, size: rect.height * 0.55) ?? font
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [
            .font: scaledFont,
            .foregroundColor: color,
            .paragraphStyle: style,
        ]
        let attributedString = NSAttributedString(string: text, attributes: attrs)
        let textSize = attributedString.size()
        let origin = CGPoint(x: rect.midX - textSize.width / 2,
                             y: rect.midY - textSize.height / 2)

        NSGraphicsContext.saveGraphicsState()
        let nsCtx = NSGraphicsContext(cgContext: ctx, flipped: false)
        NSGraphicsContext.current = nsCtx
        attributedString.draw(at: origin)
        NSGraphicsContext.restoreGraphicsState()
    }

    private static func makeDocument(from design: QRDesign) -> QRCode.Document? {
        guard !design.content.isEmpty,
              let document = try? QRCode.Document(utf8String: design.content, errorCorrection: design.errorCorrection) else {
            return nil
        }

        document.design.shape.onPixels = DotsPresets.by(id: design.dotsPresetID).make()
        document.design.shape.eye = EyeBorderPresets.by(id: design.eyeBorderPresetID).make()
        document.design.shape.pupil = EyeCenterPresets.by(id: design.eyeCenterPresetID).make()

        // dot fill
        if design.useGradient,
           let gradientFill = try? QRCode.FillStyle.LinearGradient(
                pins: [
                    DSFGradient.Pin(NSColor(design.dotsColor).cgColor, 0),
                    DSFGradient.Pin(NSColor(design.gradientEndColor).cgColor, 1),
                ],
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: 1, y: 1)
           ) {
            document.design.style.onPixels = gradientFill
        } else {
            document.design.style.onPixels = QRCode.FillStyle.Solid(NSColor(design.dotsColor).cgColor)
        }

        if design.transparentBackground {
            document.design.style.background = QRCode.FillStyle.Solid(CGColor(gray: 0, alpha: 0))
        } else {
            document.design.style.background = QRCode.FillStyle.Solid(NSColor(design.backgroundColor).cgColor)
        }

        document.design.style.eye = QRCode.FillStyle.Solid(NSColor(design.eyeBorderColor).cgColor)
        document.design.style.pupil = QRCode.FillStyle.Solid(NSColor(design.eyeCenterColor).cgColor)

        if design.removeBackgroundBehindLogo,
           let logo = currentLogoImage(design: design),
           let cg = logo.toCGImage() {
            let logoRect = CGRect(x: 0.36, y: 0.36, width: 0.28, height: 0.28)
            let path = CGPath(rect: logoRect, transform: nil)
            document.logoTemplate = QRCode.LogoTemplate(image: cg, path: path)
        }

        return document
    }
}

extension NSImage {
    func toCGImage() -> CGImage? {
        if let cg = self.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            return cg
        }
        guard let tiff = self.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff) else { return nil }
        return rep.cgImage
    }
}
