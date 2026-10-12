import XCTest

class RunnerTests: XCTestCase {

  func testDeepLinkBundleConfiguration() throws {
    let testBundle = Bundle(for: type(of: self))
    let applicationBundleURL = testBundle.bundleURL
      .deletingLastPathComponent()
      .appendingPathComponent("pinkall.app", isDirectory: true)
    let applicationBundle = try XCTUnwrap(Bundle(url: applicationBundleURL))
    let urlTypes = try XCTUnwrap(
      applicationBundle.object(forInfoDictionaryKey: "CFBundleURLTypes")
        as? [[String: Any]]
    )
    let schemes = urlTypes.flatMap {
      $0["CFBundleURLSchemes"] as? [String] ?? []
    }

    XCTAssertTrue(schemes.contains("pinkall"))
    XCTAssertEqual(
      applicationBundle.object(forInfoDictionaryKey: "FlutterDeepLinkingEnabled")
        as? Bool,
      false
    )
  }

  func testKeychainBootstrapPreservesAnExplicitEnvironmentToken() {
    var didReadKeychain = false
    var injectedToken: String?

    let result = PinkallKeychainBootstrap.bootstrap(
      existingToken: " launch-token ",
      tokenProvider: {
        didReadKeychain = true
        return .token("keychain-token")
      },
      environmentSetter: { token in
        injectedToken = token
        return true
      }
    )

    XCTAssertEqual(result, .alreadyConfigured)
    XCTAssertFalse(didReadKeychain)
    XCTAssertNil(injectedToken)
  }

  func testKeychainBootstrapTrimsAndInjectsTheToken() {
    var injectedToken: String?

    let result = PinkallKeychainBootstrap.bootstrap(
      existingToken: nil,
      tokenProvider: { .token("  keychain-token\n") },
      environmentSetter: { token in
        injectedToken = token
        return true
      }
    )

    XCTAssertEqual(result, .injected)
    XCTAssertEqual(injectedToken, "keychain-token")
  }

  func testKeychainBootstrapDoesNotInjectAMissingToken() {
    var didSetEnvironment = false

    let result = PinkallKeychainBootstrap.bootstrap(
      existingToken: "\n",
      tokenProvider: { .missing },
      environmentSetter: { _ in
        didSetEnvironment = true
        return true
      }
    )

    XCTAssertEqual(result, .keychainItemMissing)
    XCTAssertFalse(didSetEnvironment)
  }

  func testKeychainBootstrapRejectsAnEmptyToken() {
    let result = PinkallKeychainBootstrap.bootstrap(
      existingToken: nil,
      tokenProvider: { .token(" \n ") },
      environmentSetter: { _ in
        XCTFail("An empty token must not be injected.")
        return true
      }
    )

    XCTAssertEqual(result, .malformedKeychainItem)
  }

  func testKeychainBootstrapReportsEnvironmentFailure() {
    let result = PinkallKeychainBootstrap.bootstrap(
      existingToken: nil,
      tokenProvider: { .token("keychain-token") },
      environmentSetter: { _ in false }
    )

    XCTAssertEqual(result, .environmentFailure)
  }

}
