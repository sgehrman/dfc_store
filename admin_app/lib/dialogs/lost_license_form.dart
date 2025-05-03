import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LostLicenseForm extends StatefulWidget {
  const LostLicenseForm({
    required this.restUrl,
    required this.isMobile,
  });

  final String restUrl;
  final bool isMobile;

  @override
  State<LostLicenseForm> createState() => _LostLicenseFormState();
}

class _LostLicenseFormState extends State<LostLicenseForm> {
  final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: '_formKey: LostLicenseForm');
  late Map<String, dynamic> _initialValue;
  AutovalidateMode _validateMode = AutovalidateMode.onUserInteraction;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'email': '',
    };
  }

  Future<void> _doSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final state = _formKey.currentState!;

      final email = state.value['email'] as String? ?? '';

      // clear out email and toast
      state.fields['email']?.didChange('');
      _validateMode = AutovalidateMode.disabled;

      setState(() {});

      final response = await ServerRestApi.requestLostLicense(
        restUrl: widget.restUrl,
        email: email,
        sendEmail: !Utils.debugBuild,
      );

      if (response['result'] == 'ok') {
        Utils.successSnackbar(
          title: 'Success',
          message: 'License sent!',
        );
      } else {
        final error = response['message'] as String? ?? 'Something went wrong';

        Utils.successSnackbar(
          title: 'Error',
          message: error,
          error: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          FormBuilder(
            autovalidateMode: _validateMode,
            key: _formKey,
            initialValue: _initialValue,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'email',
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email Address',
                      helperText: ' ',
                    ),
                    onSubmitted: (unused) => _doSubmit(),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Please enter your email address',
                      ),
                      FormBuilderValidators.email(
                        errorText: 'Your email address is not valid',
                      ),
                    ]),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                DFButton(
                  label: 'Email License',
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
