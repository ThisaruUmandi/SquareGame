//import SwiftUI
//
//struct LevelSelectionView: View {
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
////                // Gradient background
////                LinearGradient(
////                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
////                    startPoint: .topLeading,
////                    endPoint: .bottomTrailing
////                )
////                .ignoresSafeArea()
//                
//                LinearGradient(
//                    colors: [/*Color.red.opacity(0.6),*/
//                             /*Color.orange.opacity(0.3),*/
//                             Color.yellow.opacity(0.3),
//                             Color.green.opacity(0.3),
//                             Color.blue.opacity(0.3),
//                             Color.purple.opacity(0.3),
//                             Color.pink.opacity(0.3)],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .ignoresSafeArea()
//                
//                VStack(spacing: 40) {
//                    
//                    VStack(spacing: 10) {
//                        Image(systemName: "square.grid.3x3.fill")
//                            .font(.system(size: 60))
//                            .foregroundStyle(
//                                LinearGradient(
//                                    colors: [.red, .yellow, .green],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                        
//                        Text("Color Match")
//                            .font(.system(size: 44, weight: .black))
//                            .foregroundStyle(
//                                LinearGradient(
//                                    colors: [.primary, .secondary],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                        
//                        Text("Align the colors to win!")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.top, 40)
//                    
//                    VStack(spacing: 20) {
//                        
//                        NavigationLink {
//                            LevelEasyView()
//                        } label: {
//                            LevelButton(
//                                title: "Easy",
//                                subtitle: "3×3 Grid",
//                                color: .green,
//                                icon: "leaf.fill"
//                            )
//                        }
//                        
//                        NavigationLink {
//                            LevelMediumView()
//                        } label: {
//                            LevelButton(
//                                title: "Medium",
//                                subtitle: "4×4 Grid",
//                                color: .orange,
//                                icon: "flame.fill"
//                            )
//                        }
//                        
//                        NavigationLink {
//                            LevelHardView()
//                        } label: {
//                            LevelButton(
//                                title: "Hard",
//                                subtitle: "5×5 Grid",
//                                color: .red,
//                                icon: "bolt.fill"
//                            )
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                    
//                    Spacer()
//                }
//                .padding(.vertical, 30)
//            }
//        }
//    }
//}
//
//struct LevelButton: View {
//    let title: String
//    let subtitle: String
//    let color: Color
//    let icon: String
//    
//    var body: some View {
//        HStack(spacing: 15) {
//            Image(systemName: icon)
//                .font(.title)
//                .foregroundColor(.white)
//                .frame(width: 50, height: 50)
//                .background(color.opacity(0.8))
//                .clipShape(Circle())
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.primary)
//                
//                Text(subtitle)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.secondary)
//        }
//        .padding(20)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(.ultraThinMaterial)
//                .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(color.opacity(0.5), lineWidth: 2)
//        )
//    }
//}
//
//#Preview {
//    LevelSelectionView()
//}
