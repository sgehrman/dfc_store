import 'package:admin_app/store_admin_widget.dart';
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
    return const Scaffold(
      body: SharedScaffoldContext(child: StoreAdminWidget()),
    );
  }
}
