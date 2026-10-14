import 'package:flutter/widgets.dart';

class SettingsWindow extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyBloc>(
      create: (context) => MyBloc(),
      child: Container(),
    );
  }
}
