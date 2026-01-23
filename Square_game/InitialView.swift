import SwiftUI

struct InitialView: View {
    @State private var isAnimating = false
    @State private var selectedMode: GameMode? = nil
    @State private var navigateToSquareGame1 = false
    @State private var navigateToSquareGame2 = false
    
    enum GameMode {
        case squareGame1
        case squareGame2
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                CandyTheme.backgroundGradient
                    .ignoresSafeArea()
                
                // Navigation links (hidden)
                NavigationLink(destination: InitialPageView(), isActive: $navigateToSquareGame1) {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(destination: InitialPageViewA(), isActive: $navigateToSquareGame2) {
                    EmptyView()
                }
                .hidden()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // App icon/logo area
                    ZStack {
                        Circle()
                            .fill(CandyTheme.primaryGradient)
                            .frame(width: 140, height: 140)
                            .shadow(color: Color.pink.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: "square.grid.3x3.fill")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                    
                    // Title and subtitle
                    VStack(spacing: 12) {
                        Text("Square Games")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        Text("Choose your game mode")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                    
                    Spacer()
                    
                    // Game mode selection cards
                    VStack(spacing: 20) {
                        // Square Game 1
                        GameModeCard(
                            title: "Square Game 1",
                            description: "Classic mode",
                            icon: "square.fill",
                            gradient: CandyTheme.primaryGradient,
                            isSelected: selectedMode == .squareGame1
                        ) {
                            selectedMode = .squareGame1
                            navigateToSquareGame1 = true
                        }
                        
                        // Square Game 2
                        GameModeCard(
                            title: "Square Game 2",
                            description: "Advanced mode",
                            icon: "square.grid.2x2.fill",
                            gradient: CandyTheme.secondaryGradient,
                            isSelected: selectedMode == .squareGame2
                        ) {
                            selectedMode = .squareGame2
                            navigateToSquareGame2 = true
                        }
                    }
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
                    
                    Spacer()
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
            }
            .onAppear {
                isAnimating = true
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GameModeCard: View {
    let title: String
    let description: String
    let icon: String
    let gradient: LinearGradient
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(gradient)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "2C2C2E"))
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "636366"))
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? Color(hex: "DB1392") : Color(hex: "636366").opacity(0.5))
            }
            .padding(20)
            .background(Color.white.opacity(0.95))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? gradient : LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom), lineWidth: isSelected ? 4 : 0)
            )
            .shadow(color: Color.black.opacity(isSelected ? 0.25 : 0.15), radius: isSelected ? 16 : 8, x: 0, y: isSelected ? 10 : 4)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
