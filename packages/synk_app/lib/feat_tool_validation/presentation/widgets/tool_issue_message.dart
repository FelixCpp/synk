import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

extension ToolIssueMessage on ToolIssue {
  String get message {
    final cause = detail == null ? '' : ' ($detail)';

    return switch ((tool, problem)) {
      (.adb, .notFound) =>
        'Das mitgelieferte adb wurde nicht gefunden$cause. '
            'Android-Geräte sind nicht verfügbar. Bitte Synk neu installieren.',
      (.adb, _) =>
        'adb lässt sich nicht ausführen$cause. '
            'Android-Geräte sind nicht verfügbar.',
      (.devicectl, _) =>
        'Xcode (devicectl) ist nicht verfügbar$cause. '
            'iOS-Screenshots und Zwischenablage funktionieren nicht. '
            'Bitte Xcode installieren und die Lizenz akzeptieren '
            '(„sudo xcodebuild -license accept“).',
      (.coreDevice, .unsupportedMac) =>
        'Touch, Tastatur und Ton auf iOS-Geräten brauchen einen Mac mit '
            'Apple Silicon und macOS 14 oder neuer$cause. '
            'iOS-Geräte lassen sich nur ansehen.',
      (.coreDevice, _) =>
        'Xcode ist nicht installiert oder wurde noch nie gestartet$cause. '
            'iOS-Geräte lassen sich nur ansehen, ohne Ton. '
            'Bitte Xcode installieren und einmal öffnen.',
    };
  }
}
