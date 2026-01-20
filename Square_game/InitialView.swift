import SwiftUI

// MARK: - Bubble Model
struct Bubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var speed: CGFloat
    var color: Color
    var wobble: CGFloat
    var wobbleSpeed: CGFloat
    var opacity: Double
    
    init(screenWidth: CGFloat, screenHeight: CGFloat, colors: [Color]) {
        self.x = CGFloat.random(in: 0...screenWidth)
        self.y = screenHeight + CGFloat.random(in: 0...200)
        self.radius = CGFloat.random(in: 20...80)
        self.speed = CGFloat.random(in: 0.3...1.1)
        self.color = colors.randomElement() ?? .pink
        self.wobble = CGFloat.random(in: 0...(2 * .pi))
        self.wobbleSpeed = CGFloat.random(in: 0.02...0.04)
        self.opacity = Double.random(in: 0.6...1.0)
    }
}

// MARK: - Bubble View
struct BubbleView: View {
    let bubble: Bubble
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        bubble.color.opacity(1.0),
                        bubble.color.opacity(0.8),
                        bubble.color.opacity(0.4)
                    ],
                    center: .init(x: 0.3, y: 0.3),
                    startRadius: 0,
                    endRadius: bubble.radius
                )
            )
            .frame(width: bubble.radius * 2, height: bubble.radius * 2)
            .overlay(
                Circle()
                    .fill(.white.opacity(0.5))
                    .frame(width: bubble.radius * 0.6, height: bubble.radius * 0.6)
                    .offset(x: -bubble.radius * 0.3, y: -bubble.radius * 0.3)
            )
            .opacity(bubble.opacity)
            .position(x: bubble.x, y: bubble.y)
    }
}

// MARK: - Main Game Front Page
struct ColorsGameFrontPage: View {
    @State private var isStarting = false
    @State private var bounce = false
    @State private var bubbles: [Bubble] = []
    @State private var screenSize: CGSize = .zero
    
    let colors: [Color] = [
        Color(hex: "FFB6D9"), // Baby pink
        Color(hex: "FFC4A3"), // Peach
        Color(hex: "FFF4A3"), // Pale yellow
        Color(hex: "B4E7CE"), // Mint green
        Color(hex: "A8D8F0"), // Baby blue
        Color(hex: "D4B5F0"), // Lavender
        Color(hex: "FFB6D9")  // Baby pink
    ]
    
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    let bounceTimer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "FFF5F7"),
                        Color(hex: "F0F7FF"),
                        Color(hex: "F5F0FF")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Bubbles
//                ForEach(bubbles) { bubble in
//                    BubbleView(bubble: bubble)
//                }
                
                // Overlay gradients
                LinearGradient(
                    colors: [
                        .white.opacity(0.4),
                        .clear,
                        .white.opacity(0.4)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content
                VStack(spacing: min(geometry.size.height * 0.03, 25)) {
                    Spacer()
                    
                    // Title
                    VStack(spacing: 8) {
                        HStack(spacing: 1) {
                            ForEach(Array("CoLoRs".enumerated()), id: \.offset) { index, letter in
                                Text(String(letter))
                                    .font(.system(size: min(geometry.size.width * 0.18, 85), weight: .black))
                                    .foregroundColor(colors[index % colors.count])
                                    .shadow(color: colors[index % colors.count].opacity(0.6), radius: 15, x: 0, y: 8)
                                    .shadow(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)
                                    .rotationEffect(.degrees(Double(index - 2) * 6))
                                    .scaleEffect(1.0 + (Double(index) * 0.02))
                            }
                        }
                        .scaleEffect(bounce ? 1.15 : 1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: bounce)
                        
                        Text("Sort & Match Colors!")
                            .font(.system(size: min(geometry.size.width * 0.05, 22), weight: .bold))
                            .foregroundColor(.gray.opacity(0.8))
                            .shadow(color: .white, radius: 2)
                    }
                    
                    // Play button
                    if !isStarting {
                        NavigationLink {
                            LevelEasyView()
                        } label: {
                            Text("PLAY")
                                .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, min(geometry.size.width * 0.12, 50))
                                .padding(.vertical, min(geometry.size.height * 0.025, 20))
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "FF8FB1"),
                                            Color(hex: "C77DFF"),
                                            Color(hex: "7FB5FF")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(50)
                                .shadow(color: .purple.opacity(0.4), radius: 20, x: 0, y: 10)
                        }
                        .scaleEffect(bounce ? 1.05 : 1.0)
                        .simultaneousGesture(TapGesture().onEnded {
                            handleStart()
                        })
                    } else {
                        HStack(spacing: 12) {
                            ForEach(0..<5) { index in
                                Circle()
                                    .fill(colors[index])
                                    .frame(width: min(geometry.size.width * 0.1, 40), height: min(geometry.size.width * 0.1, 40))
                                    .shadow(color: colors[index].opacity(0.4), radius: 8)
                                    .offset(y: animateCircle(index: index))
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 20)
                    }
                    
                    Spacer()
                    
                    // Bottom color circles
//                    HStack(spacing: min(geometry.size.width * 0.03, 12)) {
//                        ForEach(0..<6) { index in
//                            Circle()
//                                .fill(colors[index])
//                                .frame(width: min(geometry.size.width * 0.12, 50), height: min(geometry.size.width * 0.12, 50))
//                                .shadow(color: colors[index].opacity(0.5), radius: 12)
//                                .offset(y: animateCircle(index: index))
//                        }
//                    }
                    .padding(.bottom, 20)
                }
                
                // Floating stars
//                ForEach(starPositions, id: \.id) { star in
//                    Text("★")
//                        .font(.system(size: 34))
//                        .foregroundColor(colors[star.id % colors.count])
//                        .shadow(color: .black.opacity(0.2), radius: 2)
//                        .position(
//                            x: geometry.size.width * star.x,
//                            y: geometry.size.height * star.y
//                        )
//                        .opacity(animateStar(index: star.id))
//                }
                
                // Settings button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("⚙️")
                                .font(.system(size: 28))
                                .frame(width: 56, height: 56)
                                .background(.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    }
                    Spacer()
                }
            }
            .onAppear {
                screenSize = geometry.size
                initializeBubbles(width: geometry.size.width, height: geometry.size.height)
            }
            .onReceive(timer) { _ in
                updateBubbles(width: geometry.size.width, height: geometry.size.height)
            }
            .onReceive(bounceTimer) { _ in
                withAnimation {
                    bounce = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        bounce = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    func initializeBubbles(width: CGFloat, height: CGFloat) {
        bubbles = (0..<30).map { _ in
            Bubble(screenWidth: width, screenHeight: height, colors: colors)
        }
    }
    
    func updateBubbles(width: CGFloat, height: CGFloat) {
        for index in bubbles.indices {
            bubbles[index].wobble += bubbles[index].wobbleSpeed
            bubbles[index].y -= bubbles[index].speed
            bubbles[index].x += sin(bubbles[index].wobble) * 1.5
            
            if bubbles[index].y + bubbles[index].radius < 0 {
                bubbles[index].y = height + bubbles[index].radius
                bubbles[index].x = CGFloat.random(in: 0...width)
            }
        }
    }
    
    func handleStart() {
        isStarting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isStarting = false
        }
    }
    
    func animateCircle(index: Int) -> CGFloat {
        let animation = sin(Date().timeIntervalSinceReferenceDate * 2 + Double(index) * 0.3) * 10
        return CGFloat(animation)
    }
    
//    func animateStar(index: Int) -> Double {
//        let animation = 0.5 + sin(Date().timeIntervalSinceReferenceDate * 1.5 + Double(index) * 0.4) * 0.5
//        return animation
//    }
    
    let starPositions: [(id: Int, x: CGFloat, y: CGFloat)] = [
        (0, 0.08, 0.12),
        (1, 0.85, 0.08),
        (2, 0.15, 0.75),
        (3, 0.90, 0.80),
        (4, 0.25, 0.25),
        (5, 0.75, 0.35),
        (6, 0.50, 0.85),
        (7, 0.60, 0.15)
    ]
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct ColorsGameFrontPage_Previews: PreviewProvider {
    static var previews: some View {
        ColorsGameFrontPage()
    }
}
