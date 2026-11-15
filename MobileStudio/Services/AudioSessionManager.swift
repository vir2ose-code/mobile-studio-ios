import Foundation
import AVFoundation

/// Manages the low-latency AVAudioSession configuration for professional music production.
final class AudioSessionManager {
    static let shared = AudioSessionManager()

    private init() {}

    /// Configures AVAudioSession with `.playback` category to allow audio output
    /// even when the iPhone's physical silent switch is engaged and during lock-screen playback.
    func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            
            // Pro Audio: .playback category ensures uninterrupted sound output
            try session.setCategory(
                .playback,
                mode: .default,
                options: [
                    .mixWithOthers,
                    .allowAirPlay,
                    .defaultToSpeaker
                ]
            )

            // Ultra-low latency buffer duration for live pad tapping
            try session.setPreferredIOBufferDuration(AppConfig.preferredIOBufferDuration)
            try session.setActive(true, options: [])

            print("[AudioSessionManager] ✓ AVAudioSession configured (.playback, low-latency, active).")
        } catch {
            print("[AudioSessionManager] ⚠ Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
    }
}
