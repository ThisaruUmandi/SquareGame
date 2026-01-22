//import SwiftUI
//
//struct ScoreView: View {
//    let score: Int
//    let moves: Int
//    let stars: Int // 1-3 stars based on performance
//    let onHome: () -> Void
//    let onNext: () -> Void
//    
//    @State private var showContent = false
//    @State private var starScales: [CGFloat] = [0, 0, 0]
//    
//    var body: some View {
//        ZStack {
//            // Background matching LevelSelectionView
////            LinearGradient(
////                colors: [
////                    Color.yellow.opacity(0.3),
////                    Color.green.opacity(0.3),
////                    Color.blue.opacity(0.3),
////                    Color.purple.opacity(0.3),
////                    Color.pink.opacity(0.3)
////                ],
////                startPoint: .topLeading,
////                endPoint: .bottomTrailing
////            )
////            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Home button at top
//                HStack {
//                    Spacer()
//                    Button(action: onHome) {
//                        Image(systemName: "xmark")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .frame(width: 44, height: 44)
//                            .background(
//                                Circle()
//                                    .fill(Color.orange.opacity(0.8))
//                                    .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
//                            )
//                    }
//                    .padding(.trailing, 30)
//                }
//                .padding(.top, 20)
//                
//                Spacer()
//                
//                // Completion card
//                VStack(spacing: 25) {
//                    // Stars
//                    HStack(spacing: 20) {
//                        ForEach(0..<3) { index in
//                            Image(systemName: index < stars ? "star.fill" : "star")
//                                .font(.system(size: 50))
//                                .foregroundStyle(
//                                    LinearGradient(
//                                        colors: index < stars ? [.yellow, .orange] : [.gray.opacity(0.3)],
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing
//                                    )
//                                )
//                                .scaleEffect(starScales[index])
//                                .animation(
//                                    .spring(response: 0.6, dampingFraction: 0.6)
//                                        .delay(Double(index) * 0.15),
//                                    value: starScales[index]
//                                )
//                        }
//                    }
//                    .padding(.top, 20)
//                    
//                    // Complete banner
//                    Text("COMPLETE!")
//                        .font(.system(size: 36, weight: .black))
//                        .foregroundStyle(
//                            LinearGradient(
//                                colors: [.gray, .mint],
//                                startPoint: .leading,
//                                endPoint: .trailing
//                            )
//                        )
//                        .shadow(color: .gray.opacity(0.3), radius: 10)
//                    
//                    // Score display
//                    VStack(spacing: 10) {
//                        Text("YOUR SCORE")
//                            .font(.headline)
//                            .foregroundColor(.orange)
//                        
//                        Text("\(score)")
//                            .font(.system(size: 48, weight: .bold))
//                            .foregroundStyle(
//                                LinearGradient(
//                                    colors: [.orange, .yellow],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                    }
//                    .padding(.vertical, 15)
//                    .frame(maxWidth: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.orange.opacity(0.1))
//                    )
//                    .padding(.horizontal, 30)
//                    
//                    // Moves count
//                    HStack {
//                        Image(systemName: "arrow.triangle.2.circlepath")
//                            .foregroundColor(.blue)
//                        Text("Moves: \(moves)")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.bottom, 10)
//                    
//                    // Action buttons
//                    HStack(spacing: 15) {
//                        Button(action: onNext) {
//                            HStack {
//                                Text("Next")
//                                    .fontWeight(.semibold)
//                                Image(systemName: "arrow.right")
//                            }
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 16)
//                            .background(
//                                LinearGradient(
//                                    colors: [.green, .mint],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                            .cornerRadius(15)
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.bottom, 20)
//                }
//                .frame(maxWidth: 400)
//                .background(
//                    RoundedRectangle(cornerRadius: 30)
//                        .fill(.ultraThinMaterial)
//                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 30)
//                        .stroke(
//                            LinearGradient(
//                                colors: [.yellow.opacity(0.5), .green.opacity(0.5)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            ),
//                            lineWidth: 2
//                        )
//                )
//                .padding(.horizontal, 30)
//                .scaleEffect(showContent ? 1 : 0.8)
//                .opacity(showContent ? 1 : 0)
//                
//                Spacer()
//            }
//        }
//        .onAppear {
//            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                showContent = true
//            }
//            
//            // Animate stars sequentially
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                for i in 0..<stars {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
//                        starScales[i] = 1.0
//                    }
//                }
//            }
//        }
//    }
//}
//
//// Preview
//#Preview {
//    ScoreView(
//        score: 4255,
//        moves: 23,
//        stars: 3,
//        onHome: { print("Home tapped") },
//        onNext: { print("Next tapped") }
//    )
//}
