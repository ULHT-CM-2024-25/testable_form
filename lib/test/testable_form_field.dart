import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class TestableFormField<T> extends FormField<T> {
  final T Function() getValue;
  final void Function(FormFieldState<T>, T) internalSetValue;

  /// Holds the current FormFieldState instance
  FormFieldState<T>? _currentState;

  /// Exposed `setValue` function for external use (e.g., in tests)
  @visibleForTesting
  void setValue(T value) {
    if (_currentState != null) {
      internalSetValue(_currentState!, value);
    } else {
      throw Exception("FormFieldState is not yet available");
    }
  }

  TestableFormField({
    super.key,
    required Widget Function(FormFieldState<T>) builder,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    required this.getValue,
    required this.internalSetValue,
  }) : super(
    builder: (FormFieldState<T> state) {
      final field = _TestableFormFieldState<T>(
        state: state,
        builder: builder,
        internalSetValue: internalSetValue,
      );

      (state.widget as TestableFormField<T>)._currentState = state;

      return field;
    },
  );
}

class _TestableFormFieldState<T> extends StatefulWidget {
  final FormFieldState<T> state;
  final Widget Function(FormFieldState<T>) builder;
  final void Function(FormFieldState<T>, T) internalSetValue;

  _TestableFormFieldState({
    Key? key,
    required this.state,
    required this.builder,
    required this.internalSetValue,
  }) : super(key: key);

  @override
  _TestableFormFieldStateState<T> createState() =>
      _TestableFormFieldStateState<T>();
}

class _TestableFormFieldStateState<T> extends State<_TestableFormFieldState<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.state);
  }
}