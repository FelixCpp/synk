import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_window_utils/macos_window_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManipulator.initialize();
  await WindowManipulator.makeTitlebarTransparent();
  await WindowManipulator.enableFullSizeContentView();
  await WindowManipulator.hideTitle();
  await WindowManipulator.addToolbar();
  await WindowManipulator.setToolbarStyle(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );

  runApp(const SynkUiPreviewApp());
}

class SynkUiPreviewApp extends StatefulWidget {
  const SynkUiPreviewApp({super.key});

  @override
  State<SynkUiPreviewApp> createState() => _SynkUiPreviewAppState();
}

class _SynkUiPreviewAppState extends State<SynkUiPreviewApp> {
  var _brightness = Brightness.dark;

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = SynkUiThemeData.forBrightness(_brightness);

    return WidgetsApp(
      title: 'Synk UI',
      color: theme.colors.accent,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: SynkUiTheme(
        data: theme,
        child: DefaultTextStyle(
          style: theme.typography.body,
          child: _Preview(onToggleBrightness: _toggleBrightness),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.onToggleBrightness});

  final VoidCallback onToggleBrightness;

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return SynkUiShell(
      title: 'Synk',
      actions: [
        SynkUiIconButton(
          icon: theme.brightness == Brightness.dark
              ? CupertinoIcons.sun_max
              : CupertinoIcons.moon,
          onPressed: onToggleBrightness,
        ),
        SynkUiIconButton(
          icon: CupertinoIcons.gear,
          onPressed: () {},
        ),
      ],
      sidebar: const _Sidebar(),
      child: const _Content(),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            SynkUiSpace.s16,
            SynkUiSpace.s6,
            SynkUiSpace.s16,
            SynkUiSpace.s8,
          ),
          child: Text('GERÄTE', style: theme.typography.microLabel),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SynkUiSpace.s8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: SynkUiSpace.s2,
            children: [
              _DeviceRow(
                name: 'Pixel 8 Pro',
                id: '3B291JEHN0193K',
                isConnected: true,
              ),
              _DeviceRow(
                name: 'Galaxy Tab S9',
                id: 'R9WX40ABCDE',
                isConnected: false,
              ),
              _DeviceRow(
                name: 'Pixel 6a',
                id: '1A044XYZ99021Q',
                isConnected: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.name,
    required this.id,
    required this.isConnected,
  });

  final String name;
  final String id;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final status = isConnected ? colors.live : colors.idle;

    return SynkUiListRow(
      leading: SynkUiStatusTile(
        icon: CupertinoIcons.device_phone_portrait,
        color: status,
      ),
      title: name,
      subtitle: id,
      trailing: SynkUiIconButton(
        icon: CupertinoIcons.bolt_horizontal,
        color: isConnected ? colors.error : colors.accent,
        onPressed: () {},
      ),
      onTap: () {},
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SynkUiSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SynkUiSpace.s24,
        children: [
          Wrap(
            spacing: SynkUiSpace.s8,
            runSpacing: SynkUiSpace.s8,
            children: [
              _DeviceTile(name: 'Pixel 8 Pro', isLive: true),
              _DeviceTile(name: 'Galaxy Tab S9', isLive: false),
              _DeviceTile(name: 'Pixel 6a', isLive: true),
            ],
          ),
          const _Gallery(),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatefulWidget {
  const _DeviceTile({required this.name, required this.isLive});

  final String name;
  final bool isLive;

  @override
  State<_DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<_DeviceTile> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        width: 172.0,
        child: SynkUiCard(
          radius: SynkUiRadius.frame,
          clip: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SynkUiSize.deviceToolbar,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: SynkUiSpace.s12,
                    right: SynkUiSpace.s4,
                  ),
                  child: Row(
                    children: [
                      SynkUiStatusDot(
                        color: widget.isLive ? colors.live : colors.idle,
                        glow: widget.isLive,
                      ),
                      const SizedBox(width: SynkUiSpace.s6),
                      Expanded(
                        child: Text(
                          widget.name,
                          style: theme.typography.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: SynkUiMotion.reveal,
                        opacity: _hovered ? 1.0 : 0.0,
                        child: Row(
                          children: [
                            SynkUiIconButton(
                              icon: CupertinoIcons.camera,
                              onPressed: () {},
                            ),
                            SynkUiIconButton(
                              icon:
                                  CupertinoIcons.arrow_up_left_arrow_down_right,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: SynkUiSize.hairline,
                color: colors.line,
              ),
              AspectRatio(
                aspectRatio: 9 / 19.5,
                child: ColoredBox(
                  color: colors.inset,
                  child: const _MirrorContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MirrorContent extends StatelessWidget {
  const _MirrorContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SynkUiSpace.s16,
        children: [
          Container(
            height: 3.0,
            decoration: BoxDecoration(
              color: const Color(0x17FFFFFF),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF),
              borderRadius: BorderRadius.circular(SynkUiRadius.control),
            ),
          ),
          Wrap(
            spacing: SynkUiSpace.s8,
            runSpacing: SynkUiSpace.s8,
            children: [
              for (var i = 0; i < 8; i++)
                Container(
                  width: 26.0,
                  height: 26.0,
                  decoration: BoxDecoration(
                    color: const Color(0x0DFFFFFF),
                    borderRadius: BorderRadius.circular(SynkUiRadius.row),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SynkUiSpace.s12,
      children: [
        Text('BAUSTEINE', style: theme.typography.microLabel),
        Wrap(
          spacing: SynkUiSpace.s8,
          runSpacing: SynkUiSpace.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SynkUiButton(label: 'Verbinden', onPressed: () {}),
            SynkUiButton(
              label: 'Abbrechen',
              variant: SynkUiButtonVariant.secondary,
              onPressed: () {},
            ),
            SynkUiButton(
              label: 'Trennen',
              variant: SynkUiButtonVariant.danger,
              onPressed: () {},
            ),
            const SynkUiButton(label: 'Inaktiv', onPressed: null),
            const SizedBox(width: SynkUiSpace.s8),
            SynkUiTag(label: 'Live', color: colors.live),
            SynkUiTag(label: 'Eingefroren', color: colors.warn),
            SynkUiTag(label: 'Fehler', color: colors.error),
            const SizedBox(width: SynkUiSpace.s8),
            SynkUiIconButton(icon: CupertinoIcons.camera, onPressed: () {}),
            SynkUiIconButton(
              icon: CupertinoIcons.video_camera,
              onPressed: () {},
            ),
            const SynkUiIconButton(icon: CupertinoIcons.clear, onPressed: null),
            const SizedBox(width: SynkUiSpace.s8),
            SynkUiInfoPopover(
              title: 'Pixel 6',
              rows: const [
                SynkUiInfoRow(label: 'Modell', value: 'Pixel 6'),
                SynkUiInfoRow(label: 'Hersteller', value: 'Google'),
                SynkUiInfoRow(label: 'Android-Version', value: '16'),
                SynkUiInfoRow(label: 'SDK-Level', value: '36'),
                SynkUiInfoRow(label: 'CPU-Architektur', value: 'arm64-v8a'),
                SynkUiInfoRow(label: 'Auflösung', value: '720x1600'),
                SynkUiInfoRow(
                  label: 'Seriennummer',
                  value: '18131FDF6002UE',
                  monospace: true,
                ),
              ],
              triggerBuilder: (context, controller) => SynkUiIconButton(
                icon: CupertinoIcons.info_circle,
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
          ],
        ),
        Row(
          spacing: SynkUiSpace.s24,
          children: [
            Text('Fließtext in 13 Punkt.', style: theme.typography.body),
            Text('Sekundär in 12.', style: theme.typography.secondary),
            Text('1080×2400 · 8 Mbit/s · 60 fps', style: theme.typography.mono),
          ],
        ),
      ],
    );
  }
}
