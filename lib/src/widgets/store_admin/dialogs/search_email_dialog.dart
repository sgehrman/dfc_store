import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/shared/result_card.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/shared/store_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/store_prefs.dart';
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
      child: SizedBox(height: 500, child: _AdminWidget(isMobile: false)),
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
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.text = StorePrefs.email;
  }

  Future<void> _onSubmit(String email) async {
    StorePrefs.email = email;

    // final result = await ServerRestApi.searchEmail(
    final result = await ServerRestApi.lookupEmail(
      restUrl: StorePrefs.webStoreDomain.restUrl,
      email: email,
      password: StorePrefs.apiPassword(StorePrefs.webStoreDomain),
    );

    if (result.isNotEmpty) {
      // _output = StrUtils.toPrettyString(result);

      final licenses = List<Map<String, dynamic>>.from(
        result['licenses'] as List<dynamic>? ?? [],
      );

      if (licenses.isNotEmpty) {
        _output = StrUtils.toPrettyString(licenses.first);
      } else {
        _output = 'nothing found';
      }

      if (mounted) {
        setState(() {});
      }

      Utils.successSnackbar(title: 'Success', message: 'Search complete');
    } else {
      Utils.successSnackbar(
        title: 'Error',
        message: 'Something went wrong',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.text,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: _onSubmit,
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => _onSubmit(_emailController.text),
              mini: true,
              child: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: ResultCard(child: SelectableText(_output))),
      ],
    );
  }
}
