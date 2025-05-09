import 'package:admin_app/misc/enums.dart';
import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SettingsDialogContent extends StatelessWidget {
  const SettingsDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(child: _AdminWidget(isMobile: false));
  }
}

// =================================================================

class _AdminWidget extends StatelessWidget {
  const _AdminWidget({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return const SettingsForm(restUrl: '');
  }
}

// =================================================================

class SettingsForm extends StatefulWidget {
  const SettingsForm({required this.restUrl, super.key});

  final String restUrl;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormBuilderState>(
    debugLabel: '_formKey: SettingsForm',
  );
  late Map<String, dynamic> _initialValue;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {};

    for (final domain in WebStoreDomain.values) {
      _initialValue[domain.formKey('verifySecret')] = Prefs.verifySecret(
        domain,
      );
      _initialValue[domain.formKey('apiPassword')] = Prefs.apiPassword(domain);
    }
  }

  Future<void> _doSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final state = _formKey.currentState!;

      for (final domain in WebStoreDomain.values) {
        Prefs.setVerifySecret(
          domain,
          state.value[domain.formKey('verifySecret')] as String,
        );

        Prefs.setApiPassword(
          domain,
          state.value[domain.formKey('apiPassword')] as String,
        );
      }

      Navigator.of(context).pop();
    }
  }

  List<Widget> get _fields {
    final result = <Widget>[];

    for (final domain in WebStoreDomain.values) {
      result.addAll([
        FormBuilderTextField(
          name: domain.formKey('verifySecret'),
          autocorrect: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Verify Secret ${domain.name}',
          ),
        ),
        FormBuilderTextField(
          name: domain.formKey('apiPassword'),
          autocorrect: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password ${domain.name}',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ]);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBuilder(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._fields,
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: DFButton(label: 'Save', onPressed: _doSubmit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
