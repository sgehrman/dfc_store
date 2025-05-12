import 'package:admin_app/dialogs/shared/store_dialog.dart';
import 'package:admin_app/misc/store_prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';

Future<void> showSearchEmailDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    title: 'Search Email',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const _SearchEmailDialogContent()],
    ),
  );
}

// =================================================================

class _SearchEmailDialogContent extends StatelessWidget {
  const _SearchEmailDialogContent();

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SizedBox(height: 700, child: _AdminWidget(isMobile: false)),
    );
  }
}
// =================================================================

class _AdminWidget extends StatefulWidget {
  const _AdminWidget({required this.isMobile});

  final bool isMobile;

  @override
  State<_AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<_AdminWidget> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(isDense: true, hintText: 'Email'),
          keyboardType: TextInputType.text,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (email) async {
            // final result = await ServerRestApi.searchEmail(
            final result = await ServerRestApi.lookupEmail(
              restUrl: StorePrefs.webStoreDomain.restUrl,
              email: email,
              password: StorePrefs.apiPassword(StorePrefs.webStoreDomain),
            );

            if (result.isNotEmpty) {
              _output = StrUtils.toPrettyString(result);

              if (mounted) {
                setState(() {});
              }

              Utils.successSnackbar(
                title: 'Success',
                message: 'Search complete',
              );
            } else {
              Utils.successSnackbar(
                title: 'Error',
                message: 'Something went wrong',
                error: true,
              );
            }
          },
        ),
        Expanded(child: SelectableText(_output)),
      ],
    );
  }
}
