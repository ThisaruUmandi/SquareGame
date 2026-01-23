import Foundation
import Combine

class TimeManagerA: ObservableObject {
    @Published var timeRemaining: Int = 0
    private var timer: AnyCancellable?
    private var isRunning = false
    
    func start(duration: Int, onTick: @escaping (Int) -> Void, onComplete: @escaping () -> Void) {
        timeRemaining = duration
        isRunning = true
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.isRunning else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    onTick(self.timeRemaining)
                } else {
                    self.stop()
                    onComplete()
                }
            }
    }
    
    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func pause() {
        isRunning = false
    }
    
    func resume() {
        isRunning = true
    }
    
    func reset() {
        stop()
        timeRemaining = 0
    }
}
