import SwiftUI

class AnimationHelper {
    static func swapAnimation() -> Animation {
        .spring(response: ConstantsA.swapDuration, dampingFraction: 0.7)
    }
    
    static func matchAnimation() -> Animation {
        .easeOut(duration: ConstantsA.matchDuration)
    }
    
    static func fallAnimation() -> Animation {
        .easeIn(duration: ConstantsA.fallDuration)
    }
    
    static func spawnAnimation() -> Animation {
        .spring(response: ConstantsA.spawnDuration, dampingFraction: 0.6)
    }
    
    static func pulseAnimation() -> Animation {
        .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
    }
    
    static func shakeAnimation() -> Animation {
        .spring(response: 0.3, dampingFraction: 0.3)
    }
}
