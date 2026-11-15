import UIKit
import WebKit

/// Main ViewController embedding the Beatcloud Pro Audio WebEngine inside an optimized WKWebView.
class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    private var webView: WKWebView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var errorContainerView: UIView?

    // MARK: - Status Bar & Safe Area
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        // Hide iOS status bar (clock, battery, WiFi) completely across iPad and iPhone
        // so top navigation, hamburger menu and language flags are 100% accessible and unobstructed
        return true
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        // Minimize home indicator distraction during music sessions
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConfig.chassisBackground

        setupWebView()
        setupLoadingIndicator()
        loadWebContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioSessionManager.shared.configureAudioSession()
    }

    // MARK: - WebView Setup
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()

        // Enable inline audio/video playback without full-screen forcing
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.suppressesIncrementalRendering = false

        // Preferences
        let preferences = WKPreferences()
        if #available(iOS 15.4, *) {
            preferences.isElementFullscreenEnabled = true
        }
        configuration.preferences = preferences

        // JavaScript Bridge: Native Haptics & Audio Hooks
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "haptic")
        userContentController.add(self, name: "audioSession")
        configuration.userContentController = userContentController

        // Instantiate WebView
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        // Background & Scrolling customization
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = AppConfig.chassisBackground
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = AppConfig.goldAccent
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true

        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        loadingIndicator.startAnimating()
    }

    private func loadWebContent() {
        let request = URLRequest(
            url: AppConfig.liveURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 25.0
        )
        webView.load(request)
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        errorContainerView?.removeFromSuperview()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        setNeedsStatusBarAppearanceUpdate()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showErrorView(error: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showErrorView(error: error)
    }

    // MARK: - Error Handling
    private func showErrorView(error: Error) {
        guard errorContainerView == nil else { return }

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = AppConfig.chassisBackground

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "BEATCLOUD PRO AUDIO"
        titleLabel.textColor = AppConfig.goldAccent
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Verbindung wird überprüft...\nBitte überprüfe deine Internetverbindung."
        messageLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        let retryButton = UIButton(type: .system)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("ERNEUT VERBINDEN", for: .normal)
        retryButton.setTitleColor(UIColor.black, for: .normal)
        retryButton.backgroundColor = AppConfig.goldAccent
        retryButton.layer.cornerRadius = 8
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(retryButton)
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -40),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -28),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 22),
            retryButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            retryButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        self.errorContainerView = container
    }

    @objc private func retryTapped() {
        errorContainerView?.removeFromSuperview()
        errorContainerView = nil
        loadWebContent()
    }

    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "haptic", let type = message.body as? String {
            HapticFeedbackManager.shared.trigger(type)
        } else if message.name == "audioSession" {
            AudioSessionManager.shared.configureAudioSession()
        }
    }

    // MARK: - Orientation Changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}
