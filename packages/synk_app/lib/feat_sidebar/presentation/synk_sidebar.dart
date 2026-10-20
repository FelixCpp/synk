import 'package:synk/design/theme/device_status_colors.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_device_pairing/presentation/wireless_pairing_dialog.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_availability.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SynkSidebar({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SidebarBloc>(
      create: (context) => SidebarBloc(
        RepositoryProvider.of<SidebarFeature>(context),
        RepositoryProvider.of<NotificationFeature>(context),
      ),
      child: BlocBuilder<SidebarBloc, SidebarState>(
        builder: (context, state) {
          return _Content(state: state);
        },
      ),
    );
  }
}

class const _Content({required final SidebarState state})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: SynkUiInsets.page,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: SynkUiSpace.s8,
        children: [
          if (RepositoryProvider.of<ToolAvailability>(context).isAdbAvailable)
            const _ConnectWirelessDeviceButton(),
          const _SectionHeader(title: 'VERBUNDENE GERÄTE'),
          if (state.devices.isEmpty)
            const _NoDevicesPlugged()
          else
            for (final device in state.devices) _DeviceEntry(device: device),
        ],
      ),
    );
  }
}

/// The control an entry offers on its right-hand side.
enum _EntryAction {
  connect(
    icon: CupertinoIcons.bolt_fill,
    tooltip: 'Verbinden',
    isDestructive: false,
  ),
  disconnect(
    icon: CupertinoIcons.bolt_slash_fill,
    tooltip: 'Trennen',
    isDestructive: true,
  ),
  retry(
    icon: CupertinoIcons.arrow_clockwise,
    tooltip: 'Erneut verbinden',
    isDestructive: false,
  ),
  cameraSettings(
    icon: CupertinoIcons.gear_alt,
    tooltip: 'Kamerazugriff in den Systemeinstellungen erlauben',
    isDestructive: false,
  );

  const _EntryAction({
    required this.icon,
    required this.tooltip,
    required this.isDestructive,
  });

  final IconData icon;
  final String tooltip;
  final bool isDestructive;
}

/// Everything a [SidebarDeviceState] decides about how its entry looks.
///
/// [statusText] of `null` means the entry shows the device id instead, in the
/// secondary text color; a text is shown in [status] instead.
typedef _EntryLook = ({
  Color status,
  String? statusText,
  List<_EntryAction> actions,
  bool isBusy,
  bool isUnauthorized,
});

_EntryLook _lookOf(BuildContext context, SidebarDeviceState state) {
  final colors = context.synkUi.colors;

  return switch (state) {
    SidebarDeviceDisconnected() => (
      status: colors.deviceDisconnected,
      statusText: null,
      actions: const [_EntryAction.connect],
      isBusy: false,
      isUnauthorized: false,
    ),
    SidebarDeviceConnecting() => (
      status: colors.deviceConnecting,
      statusText: 'Verbinde …',
      actions: const [],
      isBusy: true,
      isUnauthorized: false,
    ),
    SidebarDeviceConnected() => (
      status: colors.deviceConnected,
      statusText: null,
      actions: const [_EntryAction.disconnect],
      isBusy: false,
      isUnauthorized: false,
    ),
    SidebarDeviceFailedToConnect(:final failure) => (
      status: colors.error,
      statusText: _labelOf(failure),
      actions: _isClearedOutsideOfSynk(failure)
          ? const [_EntryAction.cameraSettings, _EntryAction.retry]
          : const [_EntryAction.retry],
      isBusy: false,
      isUnauthorized: false,
    ),
    SidebarDeviceUnableToConnect() => (
      status: colors.deviceUnauthorized,
      statusText: null,
      actions: const [],
      isBusy: false,
      isUnauthorized: true,
    ),
  };
}

bool _isClearedOutsideOfSynk(ConnectionFailure failure) {
  return failure == ConnectionFailure.cameraAccessDenied;
}

String _labelOf(ConnectionFailure failure) => switch (failure) {
  ConnectionFailure.connectionRefused => 'Verbindung abgelehnt',
  ConnectionFailure.cameraAccessDenied => 'Kamerazugriff verweigert',
  ConnectionFailure.deviceNotPaired => 'Nicht gekoppelt',
  ConnectionFailure.developerModeDisabled => 'Entwicklermodus aus',
  ConnectionFailure.developerDiskImageUnavailable =>
    'Nicht für Entwicklung vorbereitet',
  ConnectionFailure.unknown => 'Verbindung fehlgeschlagen',
};

class const _DeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final look = _lookOf(context, device.state);
    final plugged = device.device;

    return _EntryFrame(
      leading: _LeadingIcon(statusColor: look.status),
      title: Column(
        crossAxisAlignment: .start,
        spacing: SynkUiSpace.s2,
        children: [
          _TitleRow(
            modelName: plugged.modelName,
            tagColor: look.isUnauthorized ? look.status : null,
          ),
          _StatusLine(
            text: look.statusText ?? plugged.id,
            color: look.statusText == null
                ? context.synkUi.colors.textSecondary
                : look.status,
          ),
        ],
      ),
      trailing: _Trailing(look: look, device: plugged),
    );
  }
}

class const _TitleRow({
  required final String modelName,
  required final Color? tagColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Text(
      modelName,
      style: context.synkUi.typography.label,
      overflow: .ellipsis,
    );

    final color = tagColor;
    if (color == null) {
      return name;
    }

    return Row(
      spacing: SynkUiSpace.s4,
      children: [
        Flexible(child: name),
        SynkUiTag(label: 'Nicht autorisiert', color: color),
      ],
    );
  }
}

class const _StatusLine({
  required final String text,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.synkUi.typography.secondary.copyWith(color: color),
      overflow: .ellipsis,
    );
  }
}

class const _Trailing({
  required final _EntryLook look,
  required final PluggedDevice device,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (look.isBusy) {
      return SynkUiSpinner(color: look.status);
    }

    if (look.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = context.synkUi.colors;

    return Row(
      mainAxisSize: .min,
      children: [
        for (final action in look.actions)
          SynkUiTooltip(
            message: action.tooltip,
            child: SynkUiIconButton(
              icon: action.icon,
              iconSize: 15.0,
              color: action.isDestructive ? colors.error : colors.accent,
              onPressed: () => _dispatch(context, action, device),
            ),
          ),
      ],
    );
  }
}

/// The single place the sidebar turns an action into an event.
void _dispatch(
  BuildContext context,
  _EntryAction action,
  PluggedDevice device,
) {
  final bloc = BlocProvider.of<SidebarBloc>(context);

  switch (action) {
    case .connect || .retry:
      bloc.add(SidebarEvent.onConnectRequested(device));
    case .disconnect:
      bloc.add(SidebarEvent.onDisconnectRequested(device));
    case .cameraSettings:
      bloc.add(const SidebarEvent.onOpenCameraPrivacySettings());
  }
}

class const _ConnectWirelessDeviceButton() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiInteractive(
      onPressed: () => showWirelessPairingDialog(context),
      builder: (context, state) {
        final colors = context.synkUi.colors;

        return SynkUiCard(
          padding: const .all(SynkUiSpace.s12),
          focused: state.contains(WidgetState.focused),
          overlayColor: colors.overlayFor(state),
          child: Column(
            mainAxisAlignment: .center,
            spacing: SynkUiSpace.s4,
            children: [
              Icon(
                CupertinoIcons.add,
                size: SynkUiSize.icon,
                color: colors.text,
              ),
              Text(
                'Wireless-Gerät verbinden',
                style: context.synkUi.typography.label.copyWith(
                  color: colors.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class const _SectionHeader({
  required final String title,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(left: SynkUiSpace.s4, top: SynkUiSpace.s4),
      child: Text(
        title,
        style: context.synkUi.typography.secondary.copyWith(
          fontSize: 11.0,
          color: context.synkUi.colors.textSecondary,
          fontWeight: .w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class const _NoDevicesPlugged() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SynkUiEmptyState(
      icon: CupertinoIcons.device_phone_portrait,
      iconSize: 28.0,
      title: 'Kein Gerät angeschlossen',
      message:
          'Verbinde ein Android- oder iOS-Gerät per USB und aktiviere '
          'USB-Debugging.',
    );
  }
}

class const _EntryFrame({
  required final Widget leading,
  required final Widget title,
  required final Widget trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.synkUi.colors.surface,
        borderRadius: .circular(SynkUiRadius.card),
        border: .all(
          color: context.synkUi.colors.line,
          width: SynkUiSize.hairline,
        ),
      ),
      child: Padding(
        padding: const .all(SynkUiSpace.s8),
        child: Row(
          spacing: SynkUiSpace.s8,
          children: [
            leading,
            Expanded(child: title),
            trailing,
          ],
        ),
      ),
    );
  }
}

class const _LeadingIcon({required final Color statusColor})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(SynkUiRadius.card),
        color: statusColor.withAlpha(38),
      ),
      child: Padding(
        padding: const .all(9.0),
        child: Icon(
          CupertinoIcons.device_phone_portrait,
          size: 18.0,
          color: statusColor,
        ),
      ),
    );
  }
}
