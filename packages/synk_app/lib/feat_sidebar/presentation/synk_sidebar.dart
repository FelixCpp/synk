import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:synk/feat_device_pairing/presentation/wireless_pairing_dialog.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/data/repositories/sidebar_repository.dart';
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
        SidebarRepository(RepositoryProvider.of(context)),
        RepositoryProvider.of(context),
        RepositoryProvider.of(context),
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
      padding: SynkTheme.pagePadding,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: SynkTheme.verticalComponentSpacingMedium,
        children: [
          if (context.read<ToolAvailability>().isAdbAvailable)
            const _ConnectWirelessDeviceButton(),
          _SectionHeader(title: "VERBUNDENE GERÄTE"),
          if (state.devices.isEmpty)
            const _NoDevicesPlugged()
          else
            for (final device in state.devices) _DeviceEntry(device: device),
        ],
      ),
    );
  }
}

class const _DeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return device.state.map(
      disconnected: (_) => _DisconnectedDeviceEntry(device: device),
      connecting: (_) => _ConnectingDeviceEntry(device: device),
      connected: (_) => _ConnectedDeviceEntry(device: device),
      failedToConnect: (state) =>
          _FailedToConnectDeviceEntry(device: device, failure: state.failure),
      unableToConnect: (_) => _UnableToConnectDeviceEntry(device: device),
    );
  }
}

class const _ConnectWirelessDeviceButton() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiInteractive(
      onPressed: () => showWirelessPairingDialog(context),
      builder: (context, state) {
        final colors = context.synkUi.colors;
        final foregroundColor = colors.text;

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
                color: foregroundColor,
              ),
              Text(
                "Wireless-Gerät verbinden",
                style: context.synkUi.typography.label.copyWith(
                  color: foregroundColor,
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
      padding: const .only(
        left: 4.0,
        top: SynkTheme.verticalComponentSpacingSmall,
      ),
      child: Text(
        title,
        style: context.typo.caption2.copyWith(
          color: context.colors.secondaryLabel,
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
      message: 'Verbinde ein Android- oder iOS-Gerät per USB und aktiviere USB-Debugging.',
    );
  }
}

class const _DeviceEntryFrame({
  required final Widget leading,
  required final Widget title,
  required final Widget? trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: .circular(
          SynkTheme.smallCornerRadius,
        ),
        border: .all(
          color: context.colors.divider,
          width: SynkTheme.hairlineThickness,
        ),
      ),
      child: Padding(
        padding: const .all(8.0),
        child: Row(
          spacing: SynkTheme.horizontalComponentSpacingMedium,
          children: [
            leading,
            Expanded(child: title),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class const _LeadingDeviceFrameIcon({required final Color statusColor})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(SynkTheme.smallCornerRadius),
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

class const _DisconnectedDeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  PluggedDevice get pluggedDevice => device.device;
  @override
  Widget build(BuildContext context) {
    return _DeviceEntryFrame(
      leading: _LeadingDeviceFrameIcon(
        statusColor: context.colors.deviceDisconnected,
      ),
      title: Column(
        crossAxisAlignment: .start,
        spacing: 2.0,
        children: [
          Text(
            pluggedDevice.modelName,
            style: context.typo.headline,
            overflow: .ellipsis,
          ),
          Text(
            pluggedDevice.id,
            style: context.typo.caption1.copyWith(
              color: context.colors.secondaryLabel,
            ),
            overflow: .ellipsis,
          ),
        ],
      ),
      trailing: _ConnectButton(
        onPressed: () {
          BlocProvider.of<SidebarBloc>(context).add(
            .onConnect(pluggedDevice),
          );
        },
      ),
    );
  }
}

class const _ConnectedDeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  PluggedDevice get pluggedDevice => device.device;
  @override
  Widget build(BuildContext context) {
    return _DeviceEntryFrame(
      leading: _LeadingDeviceFrameIcon(
        statusColor: context.colors.deviceConnected,
      ),
      title: Column(
        crossAxisAlignment: .start,
        spacing: 2.0,
        children: [
          Text(
            pluggedDevice.modelName,
            style: context.typo.headline,
            overflow: .ellipsis,
          ),
          Text(
            pluggedDevice.id,
            style: context.typo.caption1.copyWith(
              color: context.colors.secondaryLabel,
            ),
            overflow: .ellipsis,
          ),
        ],
      ),
      trailing: _DisconnectButton(
        onPressed: () {
          BlocProvider.of<SidebarBloc>(context)
              .add(SidebarEvent.onConnect(pluggedDevice));
        },
      ),
    );
  }
}

class const _ConnectingDeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  PluggedDevice get pluggedDevice => device.device;

  @override
  Widget build(BuildContext context) {
    return _DeviceEntryFrame(
      leading: _LeadingDeviceFrameIcon(
        statusColor: context.colors.deviceConnecting,
      ),
      title: Column(
        crossAxisAlignment: .start,
        spacing: 2.0,
        children: [
          Text(
            pluggedDevice.modelName,
            style: context.typo.headline,
            overflow: .ellipsis,
          ),
          Text(
            'Verbinde ...',
            style: context.typo.caption1.copyWith(
              color: context.colors.deviceConnecting,
            ),
            overflow: .ellipsis,
          ),
        ],
      ),
      trailing: _ConnectingIndicator(),
    );
  }
}

class const _ConnectingIndicator() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiSpinner(
      color: context.colors.deviceConnecting,
    );
  }
}

class const _FailedToConnectDeviceEntry({
  required final SidebarDevice device,
  required final ConnectionFailure failure,
}) extends StatelessWidget {
  PluggedDevice get pluggedDevice => device.device;

  @override
  Widget build(BuildContext context) {
    return _DeviceEntryFrame(
      leading: _LeadingDeviceFrameIcon(
        statusColor: context.colors.error,
      ),
      title: Column(
        crossAxisAlignment: .start,
        spacing: 2.0,
        children: [
          Text(
            pluggedDevice.modelName,
            style: context.typo.headline,
            overflow: .ellipsis,
          ),
          Text(
            _labelOf(failure),
            style: context.typo.caption1.copyWith(
              color: context.colors.error,
            ),
            overflow: .ellipsis,
          ),
        ],
      ),
      trailing: _RetryButton(
        onPressed: () {
          BlocProvider.of<SidebarBloc>(context)
              .add(SidebarEvent.onConnect(pluggedDevice));
        },
      ),
    );
  }

  String _labelOf(ConnectionFailure failure) => switch (failure) {
    ConnectionFailure.connectionRefused => 'Verbindung abgelehnt',
    ConnectionFailure.unknown => 'Verbindung fehlgeschlagen',
  };
}

class const _UnableToConnectDeviceEntry({
  required final SidebarDevice device,
}) extends StatelessWidget {
  PluggedDevice get pluggedDevice => device.device;

  @override
  Widget build(BuildContext context) {
    final statusColor = context.colors.deviceUnauthorized;

    return _DeviceEntryFrame(
      leading: _LeadingDeviceFrameIcon(statusColor: statusColor),
      title: Column(
        crossAxisAlignment: .start,
        spacing: 2.0,
        children: [
          Row(
            spacing: SynkTheme.horizontalComponentSpacingSmall,
            children: [
              Flexible(
                child: Text(
                  pluggedDevice.modelName,
                  style: context.typo.headline,
                  overflow: .ellipsis,
                ),
              ),
              SynkUiTag(label: 'Nicht autorisiert', color: statusColor),
            ],
          ),
          Text(
            pluggedDevice.id,
            style: context.typo.caption1.copyWith(
              color: context.colors.secondaryLabel,
            ),
            overflow: .ellipsis,
          ),
        ],
      ),
      trailing: null,
    );
  }
}

class const _RetryButton({
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUiTheme.colors;

    return SynkUiTooltip(
      message: 'Erneut verbinden',
      child: SynkUiIconButton(
        icon: CupertinoIcons.arrow_clockwise,
        iconSize: 15.0,
        color: colors.accent,
        onPressed: onPressed,
      ),
    );
  }
}

class const _DisconnectButton({
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUiTheme.colors;

    return SynkUiTooltip(
      message: 'Trennen',
      child: SynkUiIconButton(
        icon: CupertinoIcons.bolt_slash_fill,
        iconSize: 15.0,
        color: colors.error,
        onPressed: onPressed,
      ),
    );
  }
}

class const _ConnectButton({
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUiTheme.colors;

    return SynkUiTooltip(
      message: 'Verbinden',
      child: SynkUiIconButton(
        icon: CupertinoIcons.bolt_fill,
        iconSize: 15.0,
        color: colors.accent,
        onPressed: onPressed,
      ),
    );
  }
}
