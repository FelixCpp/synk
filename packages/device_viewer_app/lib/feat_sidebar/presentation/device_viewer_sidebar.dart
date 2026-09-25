import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_sidebar/data/repositories/sidebar_repository_impl.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        RepositoryProvider.of(context),
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
        spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
        children: [
          Align(
            alignment: .centerLeft,
            child: Text(
              "Android Debug Bridge",
              style: context.typo.headline,
            ),
          ),
          for (final device in state.devices) _AdbDeviceEntry(device: device),
          Divider(),
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
    return Row(
      spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: Row(
            spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: MacosDynamicColor.resolve(
                    MacosColors.systemGreenColor,
                    context,
                  ).withAlpha(50),
                ),
                padding: EdgeInsets.all(12.0),
                child: MacosIcon(
                  CupertinoIcons.device_phone_portrait,
                  color: MacosDynamicColor.resolve(
                    MacosColors.systemGreenColor,
                    context,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (adbDevice.info.model case String model) ...[
                      Text(
                        model,
                        style: context.typo.headline,
                        overflow: .ellipsis,
                      ),
                      Text(
                        adbDevice.id,
                        style: context.typo.subheadline,
                        overflow: .ellipsis,
                      ),
                    ] else ...[
                      Text(
                        adbDevice.id,
                        style: context.typo.headline,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        PushButton(
          controlSize: .large,
          onPressed: () {
            BlocProvider.of<SidebarBloc>(context)
                .add(SidebarEvent.onConnect(adbDevice));
          },
          child: Text(device.isConnected ? "Trennen" : "Verbinden"),
        ),
      ],
    );
  }
}
