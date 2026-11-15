import Foundation
import UIKit

/// Central configuration for Mobile Studio iOS
struct AppConfig {
    // App Identity
    static let appName = "Mobile Studio Pro"
    static let appDisplayName = "Mobile Studio"
    static let bundleIdentifier = "com.vir2osesound.mobilestudio"
    static let author = "Waldemar Krucinski (vir2osesound)"
    static let version = "1.0.0"
    static let build = "1"

    // Live Web Endpoints
    static let liveURL = URL(string: "https://mobile-studio.waldemar-krucinski.com/")!
    static let studioURL = URL(string: "https://mobile-studio.waldemar-krucinski.com/studio.html")!

    // UI Theme & Branding
    static let chassisBackground = UIColor(red: 10/255.0, green: 12/255.0, blue: 16/255.0, alpha: 1.0) // #0a0c10
    static let goldAccent = UIColor(red: 199/255.0, green: 181/255.0, blue: 132/255.0, alpha: 1.0)     // #c7b584
    static let padGlowCyan = UIColor(red: 0/255.0, green: 229/255.0, blue: 255/255.0, alpha: 1.0)     // #00e5ff

    // Audio Buffer Latency (~5 milliseconds for instant beat pad triggering)
    static let preferredIOBufferDuration: Double = 0.005
}
