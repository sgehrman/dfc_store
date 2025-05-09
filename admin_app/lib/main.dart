import 'package:admin_app/dialogs/activate_dialog.dart';
import 'package:admin_app/dialogs/admin_dialog.dart';
import 'package:admin_app/dialogs/lost_license_dialog.dart';
import 'package:admin_app/dialogs/search_email_dialog.dart';
import 'package:admin_app/dialogs/search_license_dialog.dart';
import 'package:admin_app/dialogs/settings.dart';
import 'package:admin_app/misc/enums.dart';
import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

void main() async {
  await HiveUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: <String, Widget Function(BuildContext)>{
        '/': (context) {
          // SharedContext is for snackbars
          SharedContext().mainContext = context;

          return const MyHomePage();
        },
      },
      localizationsDelegates: const [...dfcFlutterLocDelegates],
      supportedLocales: const [...dfcFlutterLocales],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PreferencesListener(
      keys: const [Prefs.kWebStoreDomainPrefKey],
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(Prefs.webStoreDomain.name.fromCamelCase()),
            actions: [
              const _DomainMenu(),
              IconButton(
                onPressed: () {
                  showSettingsDialog(context: context);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: SharedScaffoldContext(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DFButton(
                    label: 'Create License',
                    onPressed: () {
                      showAdminDialog(context: context);
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
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================

class _DomainMenu extends StatefulWidget {
  const _DomainMenu();

  @override
  State<_DomainMenu> createState() => _DomainMenuState();
}

class _DomainMenuState extends State<_DomainMenu> {
  List<MenuButtonBarItemData> menuItems() {
    final result = <MenuButtonBarItemData>[];

    for (final domain in WebStoreDomain.values) {
      result.add(
        MenuButtonBarItemData(
          title: domain.name,
          leading: Icon(
            Icons.check,
            color: Prefs.webStoreDomain == domain ? null : Colors.transparent,
          ),
          action: () {
            Prefs.webStoreDomain = domain;

            // refresh menu, could also just do a prefs watch on this
            setState(() {});
          },
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchorButton(
      title: Prefs.webStoreDomain.name.fromCamelCase(),
      menuData: menuItems(),
    );
  }
}
