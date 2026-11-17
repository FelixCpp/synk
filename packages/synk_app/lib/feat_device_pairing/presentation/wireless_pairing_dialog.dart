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
      create: (context) => DevicePairingBloc(repository),
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

  @override
  void dispose() {
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

  void _submitPort() {
    BlocProvider.of<DevicePairingBloc>(context).add(
      DevicePairingEvent.onConnectPortSubmitted(port: _portController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DevicePairingBloc, DevicePairingState>(
      listenWhen: (previous, current) => current is DevicePairingConnected,
      listener: (context, state) => Navigator.of(context).pop(true),
      builder: (context, state) => switch (state) {
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
        _ => _Content(
          state: state,
          hostPortController: _hostPortController,
          codeController: _codeController,
          onSubmit: _submit,
        ),
      },
    );
  }
}

class const _Content({
  required final DevicePairingState state,
  required final TextEditingController hostPortController,
  required final TextEditingController codeController,
  required final VoidCallback onSubmit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final isPairing = state is DevicePairingPairing;
    final error = switch (state) {
      DevicePairingEditing(:final error) => error,
      _ => null,
    };

    return _DialogCard(
      children: [
        Text('Wireless-Gerät koppeln', style: theme.typography.heading),
        Text(
          'Auf dem Gerät unter „Kabelloses Debugging“ › „Mit '
          'Pairing-Code koppeln“ öffnen und die angezeigte Adresse '
          'sowie den Code hier eintragen.',
          style: theme.typography.secondary,
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
          autofocus: autofocus,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
