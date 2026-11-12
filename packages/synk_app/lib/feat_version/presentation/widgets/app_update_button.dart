import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk/feat_version/presentation/bloc/app_version_bloc.dart';
import 'package:synk_ui/synk_ui.dart';

class const AppUpdateButton({
  super.key,
  required final AppVersionState state,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppVersionBloc>(context);

    if (state.isReadyToRestart) {
      return SynkUiButton(
        label: 'Neu starten',
        onPressed: () => bloc.add(const .onRestart()),
      );
    }

    return SynkUiButton(
      label: switch ((state.isUpdating, state.downloadProgress)) {
        (false, _) => 'Aktualisieren',
        (true, null) => 'Wird geladen …',
        (true, final progress?) =>
          'Wird geladen … ${(progress * 100).round()} %',
      },
      onPressed: state.isUpdating ? null : () => bloc.add(const .onUpdate()),
    );
  }
}
