import 'package:synk/feat_settings/presentation/settings_category.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';

const _navWidth = 200.0;
const _navItemHeight = 32.0;
const _navIconSize = 16.0;

/// The rail on the left of the settings window listing every category.
class const SettingsNav({
  super.key,
  required final SettingsCategory selected,
  required final ValueChanged<SettingsCategory> onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border(
          right: BorderSide(
            color: colors.line,
            width: SynkUiSize.hairline,
          ),
        ),
      ),
      child: SizedBox(
        width: _navWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SynkUiSpace.s8,
            vertical: SynkUiSpace.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: SynkUiSpace.s2,
            children: [
              for (final category in SettingsCategory.values)
                _NavItem(
                  category: category,
                  selected: category == selected,
                  onPressed: () => onSelected(category),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _NavItem({
  required final SettingsCategory category,
  required final bool selected,
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final borderRadius = BorderRadius.circular(SynkUiRadius.row);

    return SynkUiInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        final foreground = selected ? colors.accent : colors.text;

        return AnimatedContainer(
          duration: SynkUiMotion.state,
          curve: SynkUiMotion.standard,
          height: _navItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: selected
                ? colors.soft(colors.accent)
                : colors.overlayFor(states),
            borderRadius: borderRadius,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: states.contains(WidgetState.focused)
                  ? colors.accent
                  : const Color(0x00000000),
              width: SynkUiSize.hairline,
            ),
          ),
          child: Row(
            spacing: 10.0,
            children: [
              Icon(category.icon, size: _navIconSize, color: foreground),
              Expanded(
                child: Text(
                  category.label,
                  style: theme.typography.label.copyWith(color: foreground),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
