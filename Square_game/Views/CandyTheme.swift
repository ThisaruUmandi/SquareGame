import SwiftUI

struct CandyTheme {
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "FF6BBD"), Color(hex: "DB1392")],
        startPoint: .top, endPoint: .bottom
    )
    
    static let backgroundGradient = RadialGradient(
        gradient: Gradient(colors: [Color(hex: "7AC9FF"), Color(hex: "2E62D5")]),
        center: .center, startRadius: 100, endRadius: 600
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
        startPoint: .top, endPoint: .bottom
    )
    
    static let warningGradient = LinearGradient(
        colors: [Color(hex: "f6d365"), Color(hex: "fda085")],
        startPoint: .top, endPoint: .bottom
    )
    
    static let successGradient = LinearGradient(
        colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
        startPoint: .top, endPoint: .bottom
    )
    
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
            .padding(20)
            .background(Color.white.opacity(0.95))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(CandyTheme.primaryGradient, lineWidth: 5)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
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
