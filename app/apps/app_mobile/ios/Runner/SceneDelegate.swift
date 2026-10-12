import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    if let shortcut = connectionOptions.shortcutItem {
      _ = RecordingImportCoordinator.shared.handle(shortcutItem: shortcut)
    }
    for context in connectionOptions.urlContexts {
      if RecordingImportCoordinator.shared.handle(url: context.url) { break }
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    let appLinkContexts = Set(URLContexts.filter {
      !RecordingImportCoordinator.shared.handle(url: $0.url)
    })
    if !appLinkContexts.isEmpty {
      super.scene(scene, openURLContexts: appLinkContexts)
    }
  }

  override func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    let handled = RecordingImportCoordinator.shared.handle(
      shortcutItem: shortcutItem
    )
    if handled {
      completionHandler(true)
    } else {
      super.windowScene(
        windowScene,
        performActionFor: shortcutItem,
        completionHandler: completionHandler
      )
    }
  }
}
