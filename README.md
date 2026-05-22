# QR Code Generator for macOS

A **completely free, fully offline** QR code generator for macOS. No accounts, no subscriptions, no tracking, no network calls. Generate beautifully customized QR codes locally on your Mac and export them as high-resolution PNG images.

![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)
![Offline](https://img.shields.io/badge/100%25-offline-success)

## Features

- **100% offline** — everything runs locally, no internet required
- **No accounts, no ads, no analytics, no tracking**
- **Live preview** — every change updates the QR instantly
- **Encode any URL or text**
- **Logos** — 14 built-in preset logos (Link, Location, Mail, Phone, Wi-Fi, Contact, PayPal, Bitcoin, Scan Me variants, Menu, Restaurant) or upload your own PNG / JPEG / HEIC
- **Marker borders** — 15 shapes (Square, Rounded, Circle, Edges, Leaf, Teardrop, Squircle, Shield, Spiky Circle, Explode, and more)
- **Marker centers** — 17 shapes (Square, Circle, Pixels, Leaf, Teardrop, Cross, Heart, Gear, Seal, and more)
- **Dot styles** — 19 patterns (Square, Rounded, Horizontal, Vertical, Pointy, Curve, Blob, Stitch, Sharp, Abstract, Circle, Star, Flower, Spiky Circle, Heart, Diamond, Hexagon, Shiny, Gear)
- **Frames** — None, Bar, Rounded bar, Outlined, Circle, Phone, Speech bubble — with customizable phrase, font, and color
- **Colors** — full hex / color-picker control for dots, background, eye border, eye center, and frame
- **Linear gradient fill** for the dots
- **Transparent background** option
- **Remove background behind logo** toggle
- **Error correction** — Low / Medium / Quantize / High
- **Export PNG** at 2048×2048

## Requirements

- macOS 13 (Ventura) or later
- Xcode 15+ (only if building from source)
- [Tuist](https://tuist.io) 4+ (only if building from source)

## Install

### From release

1. Download the latest `QRStudio.app.zip` from the [Releases](https://github.com/mbulatIT/qrcode-generator-mac/releases) page
2. Unzip and move `QRStudio.app` to `/Applications`
3. Right-click → **Open** the first time (unsigned build, Gatekeeper prompt)

### Build from source

```bash
git clone git@github.com:mbulatIT/qrcode-generator-mac.git
cd qrcode-generator-mac
tuist install
tuist generate
open QRCodeGenerator.xcworkspace
```

Then build the **QRStudio** scheme in Xcode.

## Usage

1. Type or paste a URL / text in the **Content** field
2. Pick a logo preset or click **Browse** to upload your own
3. Pick **Marker border** + **Marker center** shapes and set colors
4. Pick a **Frame** style, edit the phrase / font / color
5. Pick a **Dot** pattern, set background and dot color (or enable gradient)
6. Click **Export PNG** in the toolbar to save

## Tech stack

- SwiftUI (macOS)
- [`dagronf/QRCode`](https://github.com/dagronf/QRCode) — pure-Swift QR code rendering
- [Tuist](https://tuist.io) — project generation

## Privacy

This app makes **zero network calls**. It does not phone home, it does not collect analytics, it does not have an account system. Everything happens on your Mac.

## License

MIT — see [LICENSE](LICENSE).
