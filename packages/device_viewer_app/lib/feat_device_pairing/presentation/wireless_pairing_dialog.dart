import 'package:app_logger/app_logger.dart';
import 'package:bench_ui/bench_ui.dart';
import 'package:device_viewer/feat_device_pairing/data/repositories/device_pairing_repository_impl.dart';
import 'package:device_viewer/feat_device_pairing/domain/usecases/connect_wirelessly_interactor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool?> showWirelessPairingDialog(BuildContext context) {
  return showBenchDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const WirelessPairingDialog(),
  );
}

class const WirelessPairingDialog({super.key}) extends StatefulWidget {
  @override
  State<WirelessPairingDialog> createState() => _WirelessPairingDialogState();
}

class _WirelessPairingDialogState extends State<WirelessPairingDialog> {
  final _hostPortController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _hostPortController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hostPort = _hostPortController.text.trim();
    final code = _codeController.text.trim();

    if (hostPort.isEmpty || code.isEmpty) {
      setState(() => _errorMessage = 'Bitte IP-Adresse, Port und Code angeben.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final interactor = ConnectWirelesslyInteractor(
      DevicePairingRepositoryImpl(RepositoryProvider.of(context)),
    ).logger();

    try {
      await interactor.getOrThrow((hostPort: hostPort, pairingCode: code));
      if (mounted) Navigator.of(context).pop(true);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360.0),
        child: BenchCard(
          elevation: BenchElevation.modal,
          padding: const EdgeInsets.all(BenchSpace.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: BenchSpace.s12,
            children: [
              Text('Wireless-Gerät koppeln', style: theme.typography.heading),
              Text(
                'Auf dem Gerät unter "Kabelloses Debugging" > "Mit Pairing-Code koppeln" öffnen und die angezeigte Adresse sowie den Code hier eintragen.',
                style: theme.typography.secondary,
              ),
              _LabeledField(
                label: 'IP-Adresse & Port',
                controller: _hostPortController,
                placeholder: '192.168.1.23:41234',
                autofocus: true,
                onSubmitted: (_) => _submit(),
              ),
              _LabeledField(
                label: 'Pairing-Code',
                controller: _codeController,
                placeholder: '123456',
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submit(),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: theme.typography.secondary.copyWith(color: colors.error),
                ),
              Padding(
                padding: const EdgeInsets.only(top: BenchSpace.s4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: BenchSpace.s8,
                  children: [
                    BenchButton(
                      label: 'Abbrechen',
                      variant: BenchButtonVariant.secondary,
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                    BenchButton(
                      label: _isSubmitting ? 'Verbinde…' : 'Koppeln',
                      onPressed: _isSubmitting ? null : _submit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    final theme = context.bench;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: BenchSpace.s4,
      children: [
        Text(label, style: theme.typography.label),
        BenchTextField(
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
