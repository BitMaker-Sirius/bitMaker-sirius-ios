// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Main {
    /// редактировать
    internal static var edit: String {
      return L10n.tr("Localizable", "main.edit")
    }
    /// Мои треки
    internal static var myTracks: String {
      return L10n.tr("Localizable", "main.my-tracks")
    }
    /// Новый трек
    internal static var newProject: String {
      return L10n.tr("Localizable", "main.new-project")
    }
  }

  internal enum ProjectEditor {
    /// Выбранные звуки
    internal static var allSounds: String {
      return L10n.tr("Localizable", "project-editor.all-sounds")
    }
    /// Тон
    internal static var pitch: String {
      return L10n.tr("Localizable", "project-editor.pitch")
    }
    /// Название проекта
    internal static var projectNamePlaceholder: String {
      return L10n.tr("Localizable", "project-editor.project-name-placeholder")
    }
    /// Громкость
    internal static var volume: String {
      return L10n.tr("Localizable", "project-editor.volume")
    }
    internal enum Alert {
      /// Принять
      internal static var accept: String {
        return L10n.tr("Localizable", "project-editor.alert.accept")
      }
      /// Введите название проекта
      internal static var changeProjectName: String {
        return L10n.tr("Localizable", "project-editor.alert.change-project-name")
      }
    }
  }

  internal enum SoundsList {
    /// Библиотека звуков
    internal static var title: String {
      return L10n.tr("Localizable", "sounds-list.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: BundleToken.bundle, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type


