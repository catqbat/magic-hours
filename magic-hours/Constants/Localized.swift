// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs
// swiftlint:disable type_name

enum L10n {
  /// blue hour
  static let blueHour = L10n.tr("blue_hour")
  /// checking weather forecast...
  static let checkingForecast = L10n.tr("checking_forecast")
  /// weather forecast unavailable
  static let forecastUnavailable = L10n.tr("forecast_unavailable")
  /// from
  static let from = L10n.tr("from")
  /// golden hour
  static let goldenHour = L10n.tr("golden_hour")
  /// sunrise
  static let sunrise = L10n.tr("sunrise")
  /// sunset
  static let sunset = L10n.tr("sunset")
  /// to
  static let to = L10n.tr("to")
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
