import SwiftUI

struct LevelSelectionView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                
                Text("Start the Game!")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 30) {
                    
                    NavigationLink {
                        LevelEasyView()
                    } label: {
                        levelButton(title: "Easy", color: .green)
                    }
                    
                    NavigationLink {
                        LevelMediumView()
                    } label: {
                        levelButton(title: "Medium", color: .yellow)
                    }
                    
                    NavigationLink {
                        LevelHardView()
                    } label: {
                        levelButton(title: "Hard", color: .red)
                    }
                }
            }
//            .padding(30)
            //for glass view style.
//            .background(
//                RoundedRectangle(cornerRadius: 30)
//                    .fill(.ultraThinMaterial)
//            )
//            .shadow(radius: 20)
        }
    }
}

struct levelButton: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .frame(width: 300, height: 55)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#Preview {
    LevelSelectionView()
}
