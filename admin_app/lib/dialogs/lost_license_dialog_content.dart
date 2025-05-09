import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';

class LostLicenseDialogContent extends StatelessWidget {
  const LostLicenseDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Lost License'),
        LostLicenseForm(restUrl: Prefs.webStoreDomain.restUrl, isMobile: false),
      ],
    );
  }
}
