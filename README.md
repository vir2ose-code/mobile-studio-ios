# Mobile Studio iOS (iPhone & iPad Pro Audio Workstation)

> **Powered by Waldemar Krucinski (`vir2osesound`)**  
> Offizielles natives iOS / Xcode-Projekt für Mobile Studio & Beatcloud Sequencer.

---

## 🎧 Über das Projekt

Dieses Xcode-Projekt stellt die native iOS-Hülle (Swift / WKWebView Container) für **Mobile Studio** bereit:
- **Echtzeit-Synchronisierung:** Lädt die Web-Engine von `https://mobile-studio.waldemar-krucinski.com/`. Jede Änderung am Web-Code auf GitHub landet sofort in der iOS-App, ohne dass ein erneutes App-Store-Review nötig ist.
- **Low-Latency Pro Audio:** Konfiguriert mit `AVAudioSession (.playback)` für unterbrechungsfreie Audiowiedergabe selbst bei aktiviertem Hardware-Stummschalter am iPhone.
- **Hardware Haptic Feedback:** Integrierte Schnittstelle für physisches Taptic-Feedback beim Drücken von Beat-Pads und Hardware-Fadern.
- **Vollständige Kante-zu-Kante Immersion:** Automatische Ausblendung der Statusleiste im Smartphone-Querformat für ungehindertes 10-Spur-Sequencing.

---

## 📱 Projektstruktur

```
mobile-studio-ios/
├── MobileStudio.xcodeproj/             # Xcode Projektdatei
│   ├── project.pbxproj
│   └── project.xcworkspace/
└── MobileStudio/
    ├── App/
    │   ├── AppDelegate.swift          # AudioSession Lifecycle & App Initialisierung
    │   └── SceneDelegate.swift        # iOS 13+ Multi-Scene Support
    ├── Controllers/
    │   └── WebViewController.swift    # WKWebView, Haptic Bridge & Vollbild-Handling
    ├── Services/
    │   ├── AudioSessionManager.swift  # Low-Latency AVAudioSession (.playback, 5ms IO-Buffer)
    │   └── HapticFeedbackManager.swift# Taptic Engine Feedback Generator
    ├── Configuration/
    │   ├── AppConfig.swift            # Globale URLs, Theme-Farben & Bundles
    │   └── Info.plist                 # App Store Berechtigungen & Audio Background Modes
    └── Resources/
        ├── Assets.xcassets/           # AppIcons (1024x1024, iPhone, iPad) & Splash
        └── LaunchScreen.storyboard    # Dark Titanium Splashscreen
```

---

## 🛠️ In Xcode öffnen & starten

1. **Projekt klonen oder Ordner auf den Mac kopieren:**
   ```bash
   git clone https://github.com/vir2ose-code/mobile-studio-ios.git
   ```
2. **`MobileStudio.xcodeproj` per Doppelklick in Xcode öffnen.**
3. **Signing & Capabilities einrichten:**
   * Klicke im Projekt-Navigator ganz oben auf `MobileStudio`.
   * Wähle das Target `MobileStudio` aus.
   * Gehe auf den Tab **Signing & Capabilities**.
   * Wähle dein Apple Developer Team aus (Personal Team für kostenlose Gerätetests oder Apple Developer Program für TestFlight / App Store).
4. **Gerät auswählen & starten:**
   * Schließe dein iPhone oder iPad per USB an (oder wähle einen Simulator, z. B. *iPhone 15 Pro Max*).
   * Drücke **`Cmd + R`** (oder den Play-Button oben links in Xcode).

---

## 🚀 App Store / TestFlight Bereitstellung

1. In Xcode oben als Zielgerät **Any iOS Device (arm64)** auswählen.
2. Im Menü: **Product -> Archive**.
3. Nach Abschluss im Organizer-Fenster auf **Distribute App** klicken:
   * **TestFlight & App Store** auswählen.
   * Automatische Signierung bestätigen und hochladen.
4. In App Store Connect ist der Build innerhalb von ~10–15 Minuten zur internen und externen TestFlight-Verteilung bereit!

---

© 2026 Waldemar Krucinski (vir2osesound). Alle Rechte vorbehalten.
