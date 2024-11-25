import 'package:admin_app/dialogs/prefs.dart';
import 'package:admin_app/dialogs/widget_dialog.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

Future<void> showSettingsDialog({
  required BuildContext context,
}) {
  return widgetDialog(
    context: context,
    scrollable: false,
    title: 'Settings',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        const Flexible(
          child: _AdminWidget(
            isMobile: false,
          ),
        ),
      ],
    ),
  );
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
  const SettingsForm({
    required this.restUrl,
    super.key,
  });

  final String restUrl;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: '_formKey: SettingsForm');
  late Map<String, dynamic> _initialValue;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'verifySecret': Prefs.verifySecret,
      'webDomain': Prefs.webDomain,
      'restUrl': Prefs.restUrl,
      'apiPassword': Prefs.apiPassword,
    };
  }

  Future<void> _doSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final state = _formKey.currentState!;

      final verifySecret = state.value['verifySecret'] as String? ?? '';
      final webDomain = state.value['webDomain'] as String? ?? '';
      final restUrl = state.value['restUrl'] as String? ?? '';
      final apiPassword = state.value['apiPassword'] as String? ?? '';

      Prefs.apiPassword = apiPassword;
      Prefs.webDomain = webDomain;
      Prefs.restUrl = restUrl;
      Prefs.verifySecret = verifySecret;
    }
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
                FormBuilderTextField(
                  name: 'restUrl',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Rest Url',
                    helperText: ' ',
                  ),
                ),
                FormBuilderTextField(
                  name: 'webDomain',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Web Domain',
                    helperText: ' ',
                  ),
                ),
                FormBuilderTextField(
                  name: 'verifySecret',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Verify Secret',
                    helperText: ' ',
                  ),
                ),
                FormBuilderTextField(
                  name: 'apiPassword',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    helperText: ' ',
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
                const SizedBox(
                  width: 20,
                ),
                DFButton(
                  label: 'Save',
                  onPressed: _doSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
