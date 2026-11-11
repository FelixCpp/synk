import 'package:flutter/services.dart';

class DeviceTextInputClient({
  required final ValueChanged<String> onTextComposed,
}) with TextInputClient {
  TextInputConnection? _connection;
  var _value = TextEditingValue.empty;

  bool get isComposing => !_value.composing.isCollapsed;

  void attach({required Size size, required Matrix4 transform}) {
    if (_connection?.attached ?? false) {
      return;
    }

    _value = TextEditingValue.empty;
    _connection =
        TextInput.attach(
            this,
            const TextInputConfiguration(
              autocorrect: false,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              inputAction: TextInputAction.none,
            ),
          )
          ..setEditingState(_value)
          ..setEditableSizeAndTransform(size, transform)
          ..setCaretRect(
            Rect.fromCenter(
              center: size.center(Offset.zero),
              width: 1,
              height: 1,
            ),
          )
          ..show();
  }

  void detach() {
    _connection?.close();
    _connection = null;
    _value = TextEditingValue.empty;
  }

  @override
  TextEditingValue get currentTextEditingValue => _value;

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  void updateEditingValue(TextEditingValue value) {
    if (!value.composing.isCollapsed) {
      _value = value;
      return;
    }

    _value = TextEditingValue.empty;
    _connection?.setEditingState(_value);

    if (value.text.isNotEmpty) {
      onTextComposed(value.text);
    }
  }

  @override
  void connectionClosed() {
    _connection = null;
    _value = TextEditingValue.empty;
  }

  @override
  void performAction(TextInputAction action) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {}
}
