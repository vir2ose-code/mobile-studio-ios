import UIKit

/// Provides low-latency haptic feedback for physical feel when tapping beat pads and hardware faders.
final class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()

    private init() {
        prepare()
    }

    func prepare() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        selectionFeedback.prepare()
        notificationFeedback.prepare()
    }

    func trigger(_ type: String) {
        switch type.lowercased() {
        case "light":
            lightImpact.impactOccurred()
        case "medium":
            mediumImpact.impactOccurred()
        case "heavy":
            heavyImpact.impactOccurred()
        case "select", "selection":
            selectionFeedback.selectionChanged()
        case "success":
            notificationFeedback.notificationOccurred(.success)
        case "warning":
            notificationFeedback.notificationOccurred(.warning)
        case "error":
            notificationFeedback.notificationOccurred(.error)
        default:
            mediumImpact.impactOccurred()
        }
    }
}
