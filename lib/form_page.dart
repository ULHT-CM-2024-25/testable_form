import 'package:flutter/material.dart';
import 'package:testable_form/test/testable_form_field.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  int? _number1;
  double _number2 = 5;
  int? _result;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _result = _number1! + _number2.toInt();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Sum Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildNumber1Field(),
              const SizedBox(height: 24),
              buildNumber2Field(),
              const SizedBox(height: 24),

              ElevatedButton(
                key: Key('sum-btn'),
                onPressed: _submit,
                child: const Text('Sum'),
              ),

              const SizedBox(height: 24),

              // Result Display
              if (_result != null)
                Text('Result: $_result', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  FormField<int?> buildNumber1Field() {
    return TestableFormField<int?>(
      key: Key('number-1-field'),
      getValue: () => _number1,
      internalSetValue: (state, value) {
        _number1 = value;
        state.didChange(value);
      },
      validator: (value) {
        if (value == null) {
          return 'Please enter a number';
        }
        return null;
      },
      onSaved: (value) {
        _number1 = value!;
      },
      builder: (field) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Number 1',
            errorText: field.errorText,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final parsed = int.tryParse(value);
            field.didChange(parsed);
          },
        );
      },
    );
  }

  FormField<double> buildNumber2Field() {
    return TestableFormField<double>(
      key: Key('number-2-field'),
      getValue: () => _number2,
      internalSetValue: (state, value) {
        _number2 = value;
        state.didChange(value);
      },
      initialValue: _number2,
      validator: (value) {
        if (value == null || value < 1 || value > 10) {
          return 'Select a value between 1 and 10';
        }
        return null;
      },
      onSaved: (value) {
        _number2 = value!;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Number 2: ${field.value?.toStringAsFixed(0) ?? ''}"),
            Slider(
              value: field.value ?? 5,
              min: 1,
              max: 10,
              divisions: 9,
              label: field.value?.toStringAsFixed(0),
              onChanged: (val) {
                field.didChange(val);
              },
            ),
            if (field.hasError) Text(field.errorText!, style: TextStyle(color: Colors.red)),
          ],
        );
      },
    );
  }
}
