import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';

const _rowGutter = 14.0;
const _pageSpacing = 20.0;
const _pageGutter = 28.0;

class const SettingsPage({
  super.key,
  required final String title,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: _pageGutter,
        vertical: SynkUiSpace.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _pageSpacing,
        children: [
          Text(title, style: context.synkUi.typography.heading),
          ...children,
        ],
      ),
    );
  }
}

class const SettingsSection({
  super.key,
  required final String title,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: SynkUiSpace.s8,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.typography.microLabel.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SynkUiCard(
          color: colors.raised,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0) const _RowSeparator(),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class const _RowSeparator() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SynkUiSize.hairline,
      child: ColoredBox(color: context.synkUi.colors.line),
    );
  }
}

class const SettingsRow({
  super.key,
  required final Widget label,
  final Widget? leading,
  final Widget? trailing,
  final double spacing = SynkUiSpace.s16,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _rowGutter,
        vertical: SynkUiSpace.s12,
      ),
      child: Row(
        spacing: spacing,
        children: [
          ?leading,
          Expanded(child: label),
          ?trailing,
        ],
      ),
    );
  }
}

/// The text block of a [SettingsRow]: what the setting is, and why.
class const SettingsRowLabel({
  super.key,
  required final String title,
  final String? subtitle,
  final Widget? badge,
  final TextStyle? titleStyle,
  final TextStyle? subtitleStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final subtitle = this.subtitle;
    final badge = this.badge;

    final title = Text(
      this.title,
      style: titleStyle ?? theme.typography.label,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: SynkUiSpace.s2,
      children: [
        if (badge == null)
          title
        else
          Row(
            spacing: SynkUiSpace.s8,
            children: [
              Flexible(child: title),
              badge,
            ],
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: subtitleStyle ?? theme.typography.secondary,
          ),
      ],
    );
  }
}
