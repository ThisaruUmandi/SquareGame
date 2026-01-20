import SwiftUI

struct HighScoreView: View {
    @EnvironmentObject var highScoreManager: HighScoreManager

    var body: some View {
        VStack {
            Text("High Scores")
                .font(.largeTitle)
                .bold()
                .padding()

            List {
                ForEach(highScoreManager.highScores) { score in
                    HStack {
                        Text(score.name)
                        Spacer()
                        Text("\(score.score)")
                    }
                }
            }
        }
    }
}

struct HighScoreView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreView()
            .environmentObject(HighScoreManager())
    }
}
