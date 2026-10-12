import Foundation
import Security

enum PinkallKeychainTokenReadResult: Equatable {
  case token(String)
  case missing
  case malformed
  case failure(OSStatus)
}

enum PinkallKeychainBootstrapResult: Equatable {
  case alreadyConfigured
  case injected
  case keychainItemMissing
  case malformedKeychainItem
  case keychainFailure(OSStatus)
  case environmentFailure
}

/// Loads the local POC bearer token from the user's Keychain into the process.
///
/// The token is injected before Flutter starts so Dart can consume it through
/// `Platform.environment`. It is never stored in the application bundle or
/// passed as a command-line argument.
enum PinkallKeychainBootstrap {
  static let environmentVariableName = "PINKALL_API_TOKEN"
  static let keychainAccount = "pinkall-poc"
  static let keychainService = "com.pinkall.api-token"

  @discardableResult
  static func bootstrap() -> PinkallKeychainBootstrapResult {
    bootstrap(
      existingToken: ProcessInfo.processInfo.environment[environmentVariableName],
      tokenProvider: readTokenFromKeychain,
      environmentSetter: setProcessEnvironment
    )
  }

  static func bootstrap(
    existingToken: String?,
    tokenProvider: () -> PinkallKeychainTokenReadResult,
    environmentSetter: (String) -> Bool
  ) -> PinkallKeychainBootstrapResult {
    if let existingToken, !existingToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return .alreadyConfigured
    }

    switch tokenProvider() {
    case .token(let rawToken):
      let token = rawToken.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !token.isEmpty else {
        return .malformedKeychainItem
      }
      return environmentSetter(token) ? .injected : .environmentFailure
    case .missing:
      return .keychainItemMissing
    case .malformed:
      return .malformedKeychainItem
    case .failure(let status):
      return .keychainFailure(status)
    }
  }

  private static func readTokenFromKeychain() -> PinkallKeychainTokenReadResult {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: keychainAccount,
      kSecAttrService as String: keychainService,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound {
      return .missing
    }
    guard status == errSecSuccess else {
      return .failure(status)
    }
    guard
      let data = item as? Data,
      let token = String(data: data, encoding: .utf8)
    else {
      return .malformed
    }
    return .token(token)
  }

  private static func setProcessEnvironment(token: String) -> Bool {
    environmentVariableName.withCString { namePointer in
      token.withCString { tokenPointer in
        setenv(namePointer, tokenPointer, 1) == 0
      }
    }
  }
}
