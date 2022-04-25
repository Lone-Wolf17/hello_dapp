import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_dapp/secrets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";
  final String _privateKey = Secrets.privateKey;

  Web3Client? _client;
  bool isLoading = true;

  String? _abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;
  ContractFunction? _yourName;
  ContractFunction? _setName;

  String? deployedName;

  ContractLinking() {
    _initialSetup();
  }

  _initialSetup() async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }
  
  Future<void> getAbi() async {
    
    // Reading the contract abi
    String abiStringFile = await rootBundle.loadString("src/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }
  
  Future<void> getCredentials() async {
    _credentials = await _client!.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    // telling Web3Dart where our contract is declared
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode!, "HelloWorld"), _contractAddress!);

    // Extracting the functions, declared in contract
    _yourName = _contract!.function("yourName");
    _setName = _contract!.function("setName");
    getName();
  }

  getName() async {
    // Getting the current name declared in the smart contract
    var currentName = await _client!.call(contract: _contract!, function: _yourName!, params: []);
    deployedName = currentName[0];
    isLoading = false;
    notifyListeners();
  }
  
  setName(String nameToSet) async {
    // Setting the name to nameToSet (name defined by user)
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(_credentials!, Transaction.callContract(contract: _contract!, function: _setName!, parameters: [nameToSet]));
    getName();
  }
}

