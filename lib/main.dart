import 'package:flutter/material.dart';
import 'package:hello_dapp/contract_linking.dart';
import 'package:hello_dapp/helloUI.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Inserting provider as a parent of Hello UI
    return ChangeNotifierProvider<ContractLinking>(
        create: (_) => ContractLinking(),
        child: MaterialApp(
          title: "Hello World",
          theme: ThemeData(
            primaryColor: Colors.cyan[400],
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan, accentColor: Colors.deepOrange[200], brightness: Brightness.dark)
                  .copyWith(primary: Colors.cyan[400])),
          home: HelloUI(),
        ));
  }
}
