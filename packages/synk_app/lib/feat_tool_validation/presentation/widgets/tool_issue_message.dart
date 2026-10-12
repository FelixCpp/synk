import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

extension ToolIssueMessage on ToolIssue {
  String get message {
    final cause = detail == null ? '' : ' ($detail)';

    return switch ((tool, problem)) {
      (.adb, .notFound) =>
        'Das mitgelieferte adb wurde nicht gefunden$cause. '
            'Android-Geräte sind nicht verfügbar. Bitte Synk neu installieren.',
      (.adb, .notRunnable) =>
        'adb lässt sich nicht ausführen$cause. '
            'Android-Geräte sind nicht verfügbar.',
      (.devicectl, _) =>
        'Xcode (devicectl) ist nicht verfügbar$cause. '
            'iOS-Screenshots und Zwischenablage funktionieren nicht. '
            'Bitte Xcode installieren und die Lizenz akzeptieren '
            '(„sudo xcodebuild -license accept“).',
    };
  }
}
