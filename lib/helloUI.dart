import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hello_dapp/contract_linking.dart';

class HelloUI extends StatelessWidget {
  HelloUI({Key? key}) : super(key: key);

  final TextEditingController yourNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Getting the value and object or contract linking
    var contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello DApp World!'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Hello ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 52)),
                            Text(contractLink.deployedName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 52,
                                    color: Colors.tealAccent)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 29),
                          child: TextFormField(
                            controller: yourNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Your Name",
                                hintText: "What is your name ?",
                                icon: Icon(Icons.drive_file_rename_outline)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            child: const Text("Set Name",
                                style: TextStyle(fontSize: 30)),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: () {
                              contractLink.setName(yourNameController.text);
                              yourNameController.clear();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
