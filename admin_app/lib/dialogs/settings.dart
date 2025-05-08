import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

Future<void> showSettingsDialog({required BuildContext context}) {
  return widgetDialog(
    context: context,
    scrollable: false,
    title: 'Settings',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        const Flexible(child: _AdminWidget(isMobile: false)),
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

      Prefs.verifySecret = state.value['verifySecret'] as String? ?? '';
      Prefs.webDomain = state.value['webDomain'] as String? ?? '';
      Prefs.restUrl = state.value['restUrl'] as String? ?? '';
      Prefs.apiPassword = state.value['apiPassword'] as String? ?? '';

      Navigator.of(context).pop();
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
                    hintText: 'https://cocoatech.io/wp-json/api/rest',
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'webDomain',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Web Domain',
                    hintText: 'cocoatech.io',
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'verifySecret',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Verify Secret'),
                ),

                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'apiPassword',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
