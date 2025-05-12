import 'package:admin_app/dialogs/store_dialogs.dart';
import 'package:admin_app/misc/store_prefs.dart';
import 'package:admin_app/misc/web_store_domain.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class StoreAdminWidget extends StatelessWidget {
  const StoreAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferencesListener(
      keys: const [StorePrefs.kWebStoreDomainPrefKey],
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const WebStoreDomainMenu(),
                IconButton(
                  onPressed: () {
                    showSettingsDialog(context: context);
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            DFButton(
              label: 'Create License',
              onPressed: () {
                showCreateDialog(context: context);
              },
            ),
            const SizedBox(height: 10),
            DFButton(
              label: 'Activate License',
              onPressed: () {
                showActivateDialog(context: context);
              },
            ),
            const SizedBox(height: 10),
            DFButton(
              label: 'Lost License',
              onPressed: () {
                showLostLicenseDialog(context: context);
              },
            ),
            const SizedBox(height: 10),
            DFButton(
              label: 'Search Email',
              onPressed: () {
                showSearchEmailDialog(context: context);
              },
            ),
            const SizedBox(height: 10),
            DFButton(
              label: 'Search License',
              onPressed: () {
                showSearchLicenseDialog(context: context);
              },
            ),
          ],
        );
      },
    );
  }
}
