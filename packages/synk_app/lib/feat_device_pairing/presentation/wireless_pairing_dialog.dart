import 'package:synk/feat_device_pairing/domain/models/pairable_device.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:synk/feat_device_pairing/presentation/bloc/device_pairing_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool?> showWirelessPairingDialog(BuildContext context) {
  final repository = RepositoryProvider.of<DevicePairingRepository>(context);

  return showSynkUiDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => BlocProvider(
      create: (context) =>
          DevicePairingBloc(repository)
            ..add(const DevicePairingEvent.onStarted()),
      child: const WirelessPairingDialog(),
    ),
  );
}

class const WirelessPairingDialog({super.key}) extends StatefulWidget {
  @override
  State<WirelessPairingDialog> createState() => _WirelessPairingDialogState();
}

class _WirelessPairingDialogState extends State<WirelessPairingDialog> {
  final _hostPortController = TextEditingController();
  final _codeController = TextEditingController();
  final _portController = TextEditingController();
  final _codeFocusNode = FocusNode();

  @override
  void dispose() {
    _codeFocusNode.dispose();
    _hostPortController.dispose();
    _codeController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _submit() {
    BlocProvider.of<DevicePairingBloc>(context).add(
      DevicePairingEvent.onSubmitted(
        hostPort: _hostPortController.text,
        pairingCode: _codeController.text,
      ),
    );
  }

  void _select(PairableDevice device) {
    _hostPortController.text = device.hostPort;
    _codeFocusNode.requestFocus();
  }

  void _submitPort() {
    BlocProvider.of<DevicePairingBloc>(context).add(
      DevicePairingEvent.onConnectPortSubmitted(port: _portController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DevicePairingBloc, DevicePairingState>(
      listenWhen: (previous, current) => current.step is DevicePairingConnected,
      listener: (context, state) => Navigator.of(context).pop(true),
      builder: (context, state) => switch (state.step) {
        DevicePairingConnectPortNeeded(:final host, :final error) =>
          _ConnectPortContent(
            host: host,
            error: error,
            isBusy: false,
            portController: _portController,
            onSubmit: _submitPort,
          ),
        DevicePairingConnecting(:final host) => _ConnectPortContent(
          host: host,
          error: null,
          isBusy: true,
          portController: _portController,
          onSubmit: _submitPort,
        ),
        final step => _Content(
          step: step,
          pairableDevices: state.pairableDevices,
          hostPortController: _hostPortController,
          codeController: _codeController,
          codeFocusNode: _codeFocusNode,
          onSelect: _select,
          onSubmit: _submit,
        ),
      },
    );
  }
}

class const _Content({
  required final DevicePairingStep step,
  required final List<PairableDevice> pairableDevices,
  required final TextEditingController hostPortController,
  required final TextEditingController codeController,
  required final FocusNode codeFocusNode,
  required final ValueChanged<PairableDevice> onSelect,
  required final VoidCallback onSubmit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final isPairing = step is DevicePairingPairing;
    final error = switch (step) {
      DevicePairingEditing(:final error) => error,
      _ => null,
    };

    return _DialogCard(
      children: [
        Text('Wireless-Gerät koppeln', style: theme.typography.heading),
        Text(
          'Auf dem Gerät unter „Kabelloses Debugging“ › „Mit '
          'Pairing-Code koppeln“ öffnen. Das Gerät erscheint dann hier; '
          'sonst die angezeigte Adresse eintragen.',
          style: theme.typography.secondary,
        ),
        _PairableDevices(
          devices: pairableDevices,
          hostPortController: hostPortController,
          onSelect: onSelect,
        ),
        _LabeledField(
          label: 'IP-Adresse & Port',
          controller: hostPortController,
          placeholder: '192.168.1.23:41234',
          autofocus: true,
          onSubmitted: (_) => onSubmit(),
        ),
        _LabeledField(
          label: 'Pairing-Code',
          controller: codeController,
          focusNode: codeFocusNode,
          placeholder: '123456',
          keyboardType: TextInputType.number,
          onSubmitted: (_) => onSubmit(),
        ),
        if (error case final error?) _ErrorText(error),
        _Actions(
          submitLabel: isPairing ? 'Kopple…' : 'Koppeln',
          isBusy: isPairing,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}

class const _PairableDevices({
  required final List<PairableDevice> devices,
  required final TextEditingController hostPortController,
  required final ValueChanged<PairableDevice> onSelect,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SynkUiSpace.s4,
      children: [
        Text('Gefundene Geräte', style: theme.typography.label),
        if (devices.isEmpty)
          Row(
            spacing: SynkUiSpace.s8,
            children: [
              const SynkUiSpinner(size: 14.0),
              Text('Suche im WLAN…', style: theme.typography.secondary),
            ],
          )
        else
          ValueListenableBuilder(
            valueListenable: hostPortController,
            builder: (context, value, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final device in devices)
                  SynkUiListRow(
                    leading: SynkUiStatusDot(color: theme.colors.accent),
                    title: device.name,
                    subtitle: device.hostPort,
                    selected: value.text.trim() == device.hostPort,
                    onTap: () => onSelect(device),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class const _ConnectPortContent({
  required final String host,
  required final String? error,
  required final bool isBusy,
  required final TextEditingController portController,
  required final VoidCallback onSubmit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return _DialogCard(
      children: [
        Text('Gekoppelt – Port fehlt', style: theme.typography.heading),
        Text(
          'Den Port zum Verbinden konnte synk nicht selbst ermitteln. Er '
          'steht auf dem Gerät unter „Kabelloses Debugging“ bei „IP-Adresse '
          '& Port“ und ist ein anderer als der Port zum Koppeln.',
          style: theme.typography.secondary,
        ),
        _LabeledField(
          label: 'Port für $host',
          controller: portController,
          placeholder: '37099',
          autofocus: true,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => onSubmit(),
        ),
        if (error case final error?) _ErrorText(error),
        _Actions(
          submitLabel: isBusy ? 'Verbinde…' : 'Verbinden',
          isBusy: isBusy,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}

class const _DialogCard({required final List<Widget> children})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360.0),
        child: SynkUiCard(
          elevation: SynkUiElevation.modal,
          padding: const EdgeInsets.all(SynkUiSpace.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: SynkUiSpace.s12,
            children: children,
          ),
        ),
      ),
    );
  }
}

class const _ErrorText(final String error) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Text(
      error,
      style: theme.typography.secondary.copyWith(color: theme.colors.error),
    );
  }
}

class const _Actions({
  required final String submitLabel,
  required final bool isBusy,
  required final VoidCallback onSubmit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: SynkUiSpace.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: SynkUiSpace.s8,
        children: [
          SynkUiButton(
            label: 'Abbrechen',
            variant: SynkUiButtonVariant.secondary,
            onPressed: isBusy ? null : () => Navigator.of(context).pop(),
          ),
          SynkUiButton(
            label: submitLabel,
            onPressed: isBusy ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}

class const _LabeledField({
  required final String label,
  required final TextEditingController controller,
  required final String placeholder,
  final FocusNode? focusNode,
  final bool autofocus = false,
  final TextInputType keyboardType = TextInputType.text,
  final ValueChanged<String>? onSubmitted,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SynkUiSpace.s4,
      children: [
        Text(label, style: theme.typography.label),
        SynkUiTextField(
          controller: controller,
          placeholder: placeholder,
          focusNode: focusNode,
          autofocus: autofocus,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
