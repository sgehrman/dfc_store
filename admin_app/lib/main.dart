import 'package:admin_app/dialogs/activate_dialog.dart';
import 'package:admin_app/dialogs/admin_dialog.dart';
import 'package:admin_app/dialogs/lost_license_form.dart';
import 'package:admin_app/dialogs/settings.dart';
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
      localizationsDelegates: const [
        ...dfcFlutterLocDelegates,
      ],
      supportedLocales: const [
        ...dfcFlutterLocales,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
            Text(Prefs.useCocoatechDotCom ? 'Cocoatech.com' : 'Cocoatech.io'),
        actions: [
          Switch(
            value: Prefs.useCocoatechDotCom,
            onChanged: (value) {
              Prefs.useCocoatechDotCom = value;

              setState(() {});
            },
          ),
          IconButton(
            onPressed: () {
              showSettingsDialog(
                context: context,
              );
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
              const SizedBox(height: 80),
              const Text('Lost License'),
              LostLicenseForm(
                restUrl: Prefs.restUrl,
                isMobile: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
