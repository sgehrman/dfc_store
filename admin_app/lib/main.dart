import 'package:admin_app/dialogs/dialogs.dart';
import 'package:admin_app/misc/enums.dart';
import 'package:admin_app/misc/store_prefs.dart';
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
      keys: const [StorePrefs.kWebStoreDomainPrefKey],
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(StorePrefs.webStoreDomain.name.fromCamelCase()),
            actions: [
              const WebStoreDomainMenu(),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
