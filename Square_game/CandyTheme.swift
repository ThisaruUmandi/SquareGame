import SwiftUI

struct CandyTheme {

        // Vibrant candy-themed gradients
        static let primaryGradient = LinearGradient(
            colors: [Color(hex: "FF1493"), Color(hex: "FF69B4"), Color(hex: "FFB6C1")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        
        static let backgroundGradient = LinearGradient(
            colors: [Color(hex: "2a83ff"), Color(hex: "FFC2D1"), Color(hex: "FB6F92")],
            startPoint: .top, endPoint: .bottom
        )
        
        static let gameBackgroundGradient = LinearGradient(
            colors: [Color(hex: "A8EDEA"), Color(hex: "FED6E3")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        
        static let levelButtonGradient = LinearGradient(
            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
            startPoint: .top, endPoint: .bottom
        )
        
        static let successGradient = LinearGradient(
            colors: [Color(hex: "56CCF2"), Color(hex: "2F80ED")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        
        static let warningGradient = LinearGradient(
            colors: [Color(hex: "F2994A"), Color(hex: "F2C94C")],
            startPoint: .top, endPoint: .bottom
        )
        
        static let dangerGradient = LinearGradient(
            colors: [Color(hex: "EB5757"), Color(hex: "FF6B6B")],
            startPoint: .top, endPoint: .bottom
        )
        
        static let jellyGradient = LinearGradient(
            colors: [Color(hex: "A8E6CF"), Color(hex: "3EECAC")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        
        static let rainbowColors: [Color] = [
            Color(hex: "FF0080"), // Hot Pink
            Color(hex: "FF8C00"), // Orange
            Color(hex: "FFD700"), // Gold
            Color(hex: "00FF7F"), // Spring Green
            Color(hex: "1E90FF"), // Dodger Blue
            Color(hex: "9370DB"), // Medium Purple
        ]

//    static let primaryGradient = LinearGradient(
//        colors: [Color(hex: "FF6BBD"), Color(hex: "DB1392")],
//        startPoint: .top, endPoint: .bottom
//    )
//    
//    static let backgroundGradient = RadialGradient(
//        gradient: Gradient(colors: [Color(hex: "7AC9FF"), Color(hex: "2E62D5")]),
//        center: .center, startRadius: 100, endRadius: 600
//    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
        startPoint: .top, endPoint: .bottom
    )
    
//    static let warningGradient = LinearGradient(
//        colors: [Color(hex: "f6d365"), Color(hex: "fda085")],
//        startPoint: .top, endPoint: .bottom
//    )
//    
//    static let successGradient = LinearGradient(
//        colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
//        startPoint: .top, endPoint: .bottom
//    )
    
    static let orangeGradient = LinearGradient(
        colors: [Color(hex: "FF9500"), Color(hex: "FF5E00")],
        startPoint: .top, endPoint: .bottom
    )
    
    static let grayGradient = LinearGradient(
        colors: [Color(hex: "636366"), Color(hex: "2C2C2E")],
        startPoint: .top, endPoint: .bottom
    )
}

struct CandyCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color(hex: "FF1493"), Color(hex: "00CED1")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                }
            )
    }
}

struct PuffyButtonStyle: ButtonStyle {
    var color: LinearGradient = CandyTheme.primaryGradient
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 32)
            .background(
                ZStack {
                    Capsule().fill(Color.black.opacity(0.2)).offset(y: 4)
                    Capsule().fill(color)
                    Capsule().strokeBorder(Color.white.opacity(0.4), lineWidth: 3).blur(radius: 1)
                }
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
