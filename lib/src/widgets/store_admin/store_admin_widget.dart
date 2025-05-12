import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/activate_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/creaste_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/lost_license_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/search_email_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/search_license_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/store_settings_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/store_prefs.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/web_store_domain.dart';
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
                    showStoreSettingsDialog(context: context);
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
