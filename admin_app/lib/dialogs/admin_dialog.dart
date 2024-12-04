import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

Future<void> showAdminDialog({
  required BuildContext context,
}) {
  return widgetDialog(
    context: context,
    scrollable: false,
    title: 'Admin',
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
    return const LicenseKeyForm();
  }
}

// =================================================================

class LicenseKeyForm extends StatefulWidget {
  const LicenseKeyForm({
    super.key,
  });

  @override
  State<LicenseKeyForm> createState() => _LicenseKeyFormState();
}

class _LicenseKeyFormState extends State<LicenseKeyForm> {
  final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: '_formKey: SignInForm');
  late Map<String, dynamic> _initialValue;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'email': '',
      'firstName': '',
      'lastName': '',
      'password': '',
    };
  }

  Future<void> _doSubmit() async {
    if (Prefs.apiPassword.isEmpty) {
      Utils.successSnackbar(
        title: 'Error',
        message: 'API password is blank',
        error: true,
      );

      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final state = _formKey.currentState!;

      final email = state.value['email'] as String? ?? '';
      final firstName = state.value['firstName'] as String? ?? '';
      final lastName = state.value['lastName'] as String? ?? '';

      // clear out email and toast
      state.fields['firstName']?.didChange('');
      state.fields['lastName']?.didChange('');
      state.fields['email']?.didChange('');
      setState(() {});

      final success = await ServerRestApi.sendLicenseKey(
        restUrl: Prefs.restUrl,
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: Prefs.apiPassword,
      );

      if (success) {
        Utils.successSnackbar(
          title: 'Success',
          message: 'License Key sent',
        );
      } else {
        Utils.successSnackbar(
          title: 'Error',
          message: 'Something went wrong',
          error: true,
        );
      }

      print('$firstName $lastName, $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create license key and send it to user',
          ),
          const SizedBox(height: 20),
          FormBuilder(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'email',
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                FormBuilderTextField(
                  name: 'firstName',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'First Name',
                    helperText: ' ',
                  ),
                  onSubmitted: (unused) => _doSubmit(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Please enter the first name',
                    ),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'lastName',
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Last Name',
                    helperText: ' ',
                  ),
                  onSubmitted: (unused) => _doSubmit(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Please enter the last name',
                    ),
                  ]),
                ),
                const SizedBox(
                  width: 20,
                ),
                DFButton(
                  label: 'Send License',
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
