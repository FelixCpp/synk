import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_connections/domain/usecases/toggle_connection_interactor.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_sidebar/data/repositories/sidebar_repository_impl.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

class const DeviceViewerSidebar({
  super.key,
  required final ScrollController scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SidebarBloc>(
      create: (context) => SidebarBloc(
        SidebarRepositoryImpl(
          RepositoryProvider.of(context),
          RepositoryProvider.of(context),
        ),
        ToggleConnectionInteractor(RepositoryProvider.of(context)),
        RepositoryProvider.of<NotificationService>(context),
      ),
      child: BlocBuilder<SidebarBloc, SidebarState>(
        builder: (context, state) {
          return _Content(
            scrollController: scrollController,
            state: state,
          );
        },
      ),
    );
  }
}

class const _Content({
  required final ScrollController scrollController,
  required final SidebarState state,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: DeviceViewerTheme.pagePadding,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              top: DeviceViewerTheme.verticalComponentSpacingSmall,
            ),
            child: Text(
              "ANDROID DEBUG BRIDGE",
              style: context.typo.caption2.copyWith(
                color: context.colors.secondaryLabel,
                fontWeight: .w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          if (state.devices.isEmpty)
            const _NoDevicesPlugged()
          else
            for (final device in state.devices) _AdbDeviceEntry(device: device),
        ],
      ),
    );
  }
}

class const _NoDevicesPlugged() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: Column(
        spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
        children: [
          MacosIcon(
            CupertinoIcons.device_phone_portrait,
            size: 28.0,
            color: context.colors.secondaryLabel,
          ),
          Text(
            "Kein Gerät angeschlossen",
            textAlign: .center,
            style: context.typo.headline.copyWith(
              color: context.colors.label,
            ),
          ),
          Text(
            "Verbinde ein Android-Gerät per USB und aktiviere USB-Debugging.",
            textAlign: .center,
            style: context.typo.caption2.copyWith(
              color: context.colors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class const _AdbDeviceEntry({required final SidebarDevice device})
    extends StatelessWidget {
  AndroidDevice get adbDevice => device.device;

  @override
  Widget build(BuildContext context) {
    final statusColor = device.isConnected
        ? context.colors.deviceConnected
        : context.colors.deviceDisconnected;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.cardHover,
        borderRadius: BorderRadius.circular(
          DeviceViewerTheme.smallCornerRadius,
        ),
        border: Border.all(
          color: context.colors.divider,
          width: DeviceViewerTheme.hairlineThickness,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
          children: [
            Row(
              spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DeviceViewerTheme.smallCornerRadius,
                    ),
                    color: statusColor.withAlpha(38),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: MacosIcon(
                      CupertinoIcons.device_phone_portrait,
                      size: 18.0,
                      color: statusColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        adbDevice.modelName,
                        style: context.typo.headline,
                        overflow: .ellipsis,
                      ),
                      Text(
                        adbDevice.id,
                        style: context.typo.caption1.copyWith(
                          color: context.colors.secondaryLabel,
                        ),
                        overflow: .ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            PushButton(
              controlSize: .large,
              secondary: device.isConnected,
              onPressed: () {
                BlocProvider.of<SidebarBloc>(context)
                    .add(SidebarEvent.onConnect(adbDevice));
              },
              child: Text(device.isConnected ? "Trennen" : "Verbinden"),
            ),
          ],
        ),
      ),
    );
  }
}
