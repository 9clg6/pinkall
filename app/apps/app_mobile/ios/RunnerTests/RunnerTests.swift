import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  func testDeepLinkBundleConfiguration() throws {
    let urlTypes = try XCTUnwrap(
      Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes")
        as? [[String: Any]]
    )
    let schemes = urlTypes.flatMap {
      $0["CFBundleURLSchemes"] as? [String] ?? []
    }

    XCTAssertTrue(schemes.contains("pinkall"))
    XCTAssertEqual(
      Bundle.main.object(forInfoDictionaryKey: "FlutterDeepLinkingEnabled")
        as? Bool,
      false
    )
  }

}
