import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:dfc_store/src/models/slm_license_model.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/shared/result_card.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/shared/store_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/store_json_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/store_prefs.dart';
import 'package:flutter/material.dart';

Future<void> showSearchEmailDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    title: 'Search Email',
    scrollable: false,
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
  List<SlmLicenseModel> _licenses = [];
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
        _licenses =
            licenses.map((e) {
              return SlmLicenseModel.fromJson(e);
            }).toList();

        _output = 'Found: ${licenses.length}';
      } else {
        _licenses = [];
        _output = 'Nothing found, error: ${result['error']}';
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
        Expanded(
          child: ResultCard(
            child: Column(
              children: [
                Expanded(child: _LicenseList(_licenses)),
                const SizedBox(height: 10),
                Text(_output),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =================================================================

class _LicenseList extends StatelessWidget {
  const _LicenseList(this.licenses);

  final List<SlmLicenseModel> licenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final license = licenses[index];

        return ListTile(
          title: SelectableText('${license.firstName}  ${license.lastName}'),
          subtitle: SelectableText(
            '${license.licenseKey}, ${license.email}, ${license.licStatus}',
          ),
          trailing: DFIconButton(
            tooltip: 'License Info',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showStoreJsonDialog(
                context: context,
                data: license.toJson(),
                title: 'License Info',
              );
            },
          ),
          onTap: () {},
        );
      },
    );
  }
}
