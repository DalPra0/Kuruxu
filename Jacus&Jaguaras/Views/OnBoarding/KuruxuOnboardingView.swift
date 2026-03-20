//
//  OnBoarding.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 20/03/26.
//

import SwiftUI

// MARK: - Text Card

struct TextCard<Content: View>: View {
    let label: String
    let title: String
    let description: String
    var extra: (() -> Content)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .heavy))
                .tracking(2)
                .foregroundColor(.secondary400)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineSpacing(2)

            Text(description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.75))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            if let extra = extra {
                extra()
                    .padding(.top, 4)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.purple700.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.purple400.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
}

// Convenience init when there's no extra content
extension TextCard where Content == EmptyView {
    init(label: String, title: String, description: String) {
        self.label = label
        self.title = title
        self.description = description
        self.extra = nil
    }
}

// MARK: - Dots Indicator

struct DotsIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i == current ? .secondary400 : Color.white.opacity(0.25))
                    .frame(width: i == current ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
    }
}

// MARK: - Primary Button

struct PrimaryButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                ButtonView(
                    primaryColor: .white, secondaryColor: .secondary400, cornerRadius: 12
                )

                Text(label)
                    .font(.system(size: 14, weight: .heavy))
                    .tracking(2)
                    .foregroundColor(.primary600)
                    .padding(.vertical, 18)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .tracking(1)
                .foregroundColor(.white.opacity(0.6))
                .underline()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Alert Box

struct AlertBox: View {
    let text: String
    let boldText: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("⚠️")
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 2) {
                Text(boldText)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.orange400)
                Text(text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.orange400.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange400.opacity(0.45), lineWidth: 1)
                )
        )
    }
}

// MARK: - ── Screen 1: Welcome ──

struct WelcomeScreen: View {
    @State private var floating = false

    var body: some View {
        VStack {
            Spacer()

            Logo()

            Spacer()
        }
        .onAppear { floating = true }
    }
}

// MARK: - ── Screen 2: What is Kuruxu ──

struct ConstellationArtView: View {
    @State private var glow = false

    // Points of a simplified tapir-ish constellation
    let pts: [(CGFloat, CGFloat)] = [
        (30, 100), (80, 60), (150, 50), (200, 65),
        (245, 48), (255, 90), (200, 120), (150, 140),
        (80, 130), (45, 160)
    ]

    let connections: [(Int, Int)] = [
        (0,1),(1,2),(2,3),(3,4),(4,5),(5,6),(6,7),(7,8),(8,9),(9,0),(2,7)
    ]

    var body: some View {
        Canvas { ctx, size in
            // Lines
            for (a, b) in connections {
                let p1 = CGPoint(x: pts[a].0, y: pts[a].1)
                let p2 = CGPoint(x: pts[b].0, y: pts[b].1)
                var path = Path()
                path.move(to: p1)
                path.addLine(to: p2)
                ctx.stroke(path, with: .color(.secondary400.opacity(0.45)), lineWidth: 1.5)
            }
            // Dots
            for (i, pt) in pts.enumerated() {
                let r: CGFloat = i == 0 ? 7 : 5
                let rect = CGRect(x: pt.0 - r, y: pt.1 - r, width: r*2, height: r*2)
                ctx.fill(Path(ellipseIn: rect), with: .color(.secondary400))
            }
        }
        .frame(width: 280, height: 190)
        .shadow(color: .secondary100.opacity(glow ? 0.7 : 0.3), radius: glow ? 20 : 8)
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glow)
        .onAppear { glow = true }
    }
}

// MARK: - ── Screen 3: Cards ──

struct CardScanView: View {
    @State private var scanPulse = false
    @State private var cardFloat = false

    private let cardColors: [Color] = [.primary600, .primary400, .primary100]
    private let cardRotations: [Double] = [-8, 4, -2]
    private let cardOffsetsX: [CGFloat] = [-30, 10, -5]

    var body: some View {
        ZStack {
            // Card stack
            ForEach(0..<3) { i in
                let offsetY: CGFloat = i == 2 ? (cardFloat ? -5 : 5) : (i == 0 ? 20 : 30)

                RoundedRectangle(cornerRadius: 16)
                    .fill(cardColors[i])
                    .overlay(
                        CardPatternOverlay()
                            .opacity(0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    )
                    .frame(width: 180, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.purple400, lineWidth: 1.5)
                    )
                    .rotationEffect(.degrees(cardRotations[i]))
                    .offset(x: cardOffsetsX[i], y: offsetY)
                    .zIndex(Double(i))
                    .animation(
                        i == 2 ? .easeInOut(duration: 3).repeatForever(autoreverses: true) : .default,
                        value: cardFloat
                    )
            }

            // Scan dot
            Circle()
                .fill(Color.purple200)
                .frame(width: 36, height: 36)
                .shadow(color: Color.purple200.opacity(0.8), radius: scanPulse ? 24 : 8)
                .scaleEffect(scanPulse ? 1.3 : 1.0)
                .offset(y: 80)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scanPulse)
                .zIndex(10)
        }
        .onAppear {
            scanPulse = true
            cardFloat = true
        }
    }
}

struct CardPatternOverlay: View {
    var body: some View {
        Canvas { ctx, size in
            let tileSize: CGFloat = 30
            let cols = Int(size.width / tileSize) + 1
            let rows = Int(size.height / tileSize) + 1
            for row in 0..<rows {
                for col in 0..<cols {
                    let x = CGFloat(col) * tileSize
                    let y = CGFloat(row) * tileSize
                    var up = Path()
                    up.move(to: CGPoint(x: x, y: y))
                    up.addLine(to: CGPoint(x: x + tileSize, y: y))
                    up.addLine(to: CGPoint(x: x + tileSize/2, y: y + tileSize * 0.87))
                    up.closeSubpath()
                    ctx.fill(up, with: .color(.blue500.opacity(0.5)))

                    var down = Path()
                    down.move(to: CGPoint(x: x, y: y + tileSize))
                    down.addLine(to: CGPoint(x: x + tileSize, y: y + tileSize))
                    down.addLine(to: CGPoint(x: x + tileSize/2, y: y + tileSize * 0.13))
                    down.closeSubpath()
                    ctx.fill(down, with: .color(.blue400.opacity(0.25)))
                }
            }
        }
    }
}

// MARK: - ── Screen 4: AR ──
 
struct ARPreviewView: View {
    @State private var drawProgress: CGFloat = 0
 
    let lineSegments: [(CGPoint, CGPoint)] = [
        (CGPoint(x: 40, y: 100),  CGPoint(x: 90, y: 70)),
        (CGPoint(x: 90, y: 70),   CGPoint(x: 150, y: 80)),
        (CGPoint(x: 150, y: 80),  CGPoint(x: 210, y: 60)),
        (CGPoint(x: 210, y: 60),  CGPoint(x: 240, y: 110)),
        (CGPoint(x: 150, y: 80),  CGPoint(x: 150, y: 170)),
        (CGPoint(x: 40, y: 100),  CGPoint(x: 40, y: 180)),
    ]
 
    let dots: [CGPoint] = [
        CGPoint(x: 40, y: 100), CGPoint(x: 90, y: 70),
        CGPoint(x: 150, y: 80), CGPoint(x: 210, y: 60),
        CGPoint(x: 240, y: 110), CGPoint(x: 150, y: 170),
        CGPoint(x: 40, y: 180)
    ]
 
    var body: some View {
        ZStack {
            // Camera background
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.3))
                .frame(width: 280, height: 220)
 
            // Corner brackets
            ARCorners()
                .frame(width: 280, height: 220)
 
            // Tapir silhouette hint
            Text("🦌")
                .font(.system(size: 60))
                .opacity(0.1)
 
            // Animated constellation
            TimelineView(.animation) { timeline in
                Canvas { ctx, size in
                    for (i, seg) in lineSegments.enumerated() {
                        let segProgress = min(max(drawProgress - CGFloat(i) * 0.15, 0), 1)
                        guard segProgress > 0 else { continue }
                        let endX = seg.0.x + (seg.1.x - seg.0.x) * segProgress
                        let endY = seg.0.y + (seg.1.y - seg.0.y) * segProgress
                        var path = Path()
                        path.move(to: seg.0)
                        path.addLine(to: CGPoint(x: endX, y: endY))
                        ctx.stroke(path, with: .color(.secondary400.opacity(0.8)), lineWidth: 2)
                    }
                    for dot in dots {
                        let rect = CGRect(x: dot.x-5, y: dot.y-5, width: 10, height: 10)
                        ctx.fill(Path(ellipseIn: rect), with: .color(.secondary400))
                    }
                }
                .frame(width: 280, height: 220)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.secondary400.opacity(0.3), lineWidth: 1.5)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: false)) {
                drawProgress = 1.0
            }
        }
    }
}
 

struct ARCorners: View {
    var body: some View {
        ZStack {
            ForEach(0..<4) { i in
                ARCorner()
                    .rotationEffect(.degrees(Double(i) * 90))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: cornerAlignment(i))
                    .padding(12)
            }
        }
    }

    func cornerAlignment(_ i: Int) -> Alignment {
        [.topLeading, .topTrailing, .bottomTrailing, .bottomLeading][i]
    }
}

struct ARCorner: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: 20))
            p.addLine(to: CGPoint(x: 0, y: 0))
            p.addLine(to: CGPoint(x: 20, y: 0))
        }
        .stroke(.secondary400, style: StrokeStyle(lineWidth: 3, lineCap: .round))
        .frame(width: 20, height: 20)
    }
}

// MARK: - ── Screen 5: Print Cards ──

struct PrintCardsView: View {
    @State private var printerBounce = false
    @State private var cardsAppeared = false

    let cardColors: [Color] = [
        .primary400, .purple500, .primary600, Color(red: 0.29, green: 0.34, blue: 0.91)
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("🖨️")
                .font(.system(size: 70))
                .offset(y: printerBounce ? -8 : 0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: printerBounce)

            HStack(spacing: 12) {
                ForEach(0..<4) { i in
                    MiniCardView(color: cardColors[i])
                        .opacity(cardsAppeared ? 1 : 0)
                        .offset(y: cardsAppeared ? 0 : -20)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7)
                            .delay(Double(i) * 0.15 + 0.3),
                            value: cardsAppeared
                        )
                }
            }
        }
        .onAppear {
            printerBounce = true
            cardsAppeared = true
        }
    }
}

struct MiniCardView: View {
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .overlay(
                CardPatternOverlay()
                    .opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.purple400, lineWidth: 1)
            )
            .frame(width: 65, height: 46)
    }
}

// MARK: - ── Individual Onboarding Pages ──

struct OnboardingPage: Identifiable {
    let id: Int
    let label: String
    let title: String
    let description: String
}

// MARK: - ── Main Onboarding View ──

struct KuruxuOnboardingView: View {
    @State private var currentPage = 0
    @State private var showApp = false

    var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.10, green: 0.12, blue: 0.48),
                Color(red: 0.14, green: 0.17, blue: 0.60),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    var body: some View {
        @State var showPDF = false
        
        ZStack {
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {

                    // ── Page 0: Welcome ──
                    pageLayout(art: AnyView(WelcomeScreen())) {
                        TextCard(
                            label: "Bem-vindo",
                            title: "A astronomia Tupi-Guarani na palma da sua mão",
                            description: "Explore constelações indígenas de um jeito interativo e divertido com Realidade Aumentada e cartas físicas."
                        )
                    }
                    .tag(0)

                    // ── Page 1: What is ──
                    pageLayout(art: AnyView(
                        VStack {
                            ConstellationArtView()
                                .padding(.top, 20)
                        
                        }
                    )) {
                        TextCard(
                            label: "O que é o Kuruxu?",
                            title: "Monte constelações no mundo real",
                            description: "Aprenda sobre a astronomia dos povos Tupi-Guarani explorando constelações em Realidade Aumentada. Cada constelação traz uma lenda e um universo de saberes ancestrais."
                        )
                    }
                    .tag(1)

                    // ── Page 2: Cards ──
                    pageLayout(art: AnyView(
                        VStack {
                            CardScanView()
                                .padding(.top, 30)
                            Spacer()
                        }
                    )) {
                        TextCard(
                            label: "Como funciona",
                            title: "Cada carta é uma estrela",
                            description: "As cartas físicas representam estrelas da constelação. Aponte a câmera para uma carta com o mosaico voltado para cima: o app a detecta e vai conectando os pontos no céu digital."
                        )
                    }
                    .tag(2)

                    // ── Page 3: AR ──
                    pageLayout(art: AnyView(
                        VStack {
                            ARPreviewView()
                                .padding(.top, 24)
                            Spacer()
                        }
                    )) {
                        TextCard(
                            label: "Realidade Aumentada",
                            title: "A constelação ganha vida!",
                            description: "Conforme você escaneia cada carta, o app vai conectando as estrelas e revelando a constelação completa em RA, junto com a lenda do povo Tupi-Guarani que a criou."
                        )
                    }
                    .tag(3)

                    // ── Page 4: Print ──
                    pageLayout(art: AnyView(
                        VStack {
                            PrintCardsView()
                                .padding(.top, 16)
                    
                        }
                    )) {
                        TextCard(
                            label: "Antes de começar",
                            title: "Imprima as cartas",
                            description: "Para jogar, você precisa das cartas físicas. Faça o download do PDF, imprima e recorte."
                        ) {
                            AlertBox(
                                text: "Sem as cartas físicas, o app não consegue detectar as estrelas.",
                                boldText: "Ação necessária"
                            )
                        }
                    }
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.55, dampingFraction: 0.85), value: currentPage)

                // ── Bottom nav ──
                VStack(spacing: 16) {
                    DotsIndicator(total: 5, current: currentPage)

                    if currentPage < 4 {
                        PrimaryButton(label: currentPage == 0 ? "COMEÇAR →" : "PRÓXIMO →") {
                            withAnimation { currentPage += 1 }
                        }

                        if currentPage > 0 {
                            SecondaryButton(label: "Pular introdução") {
                                withAnimation { currentPage = 4 }
                            }
                        }
                    } else {
                        PrimaryButton(label: "⬇  BAIXAR PDF DAS CARTAS") {
                            showPDF = true
                        }
                        .sheet(isPresented: $showPDF) {
                            PDFViewerSheet()
                        }
                        SecondaryButton(label: "Já tenho as cartas → entrar") {
                            showApp = true
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 36)
            }
        }
        .background(
            EllipticalGradient(
                stops: [
                    Gradient.Stop(color: .primary600, location: 0.00),
                    Gradient.Stop(color: .primary900, location: 1.00),
                ],
                center: UnitPoint(x: 0.53, y: 0.5)
            )
        )
        .fullScreenCover(isPresented: $showApp) {
            StartView()
                .background(
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: .primary600, location: 0.00),
                            Gradient.Stop(color: .primary900, location: 1.00),
                        ],
                        center: UnitPoint(x: 0.53, y: 0.5)
                    )
                )
        }
    }

    // Helper: wraps art + text card in a page-shaped VStack
    @ViewBuilder
    private func pageLayout<TextContent: View>(
        art: AnyView,
        @ViewBuilder textContent: () -> TextContent
    ) -> some View {
        VStack(spacing: 0) {
            art
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.40)

            textContent()

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    KuruxuOnboardingView()
}
