import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'price_card.dart';

var header = {"X-CoinAPI-Key": DotEnv().env["API_KEY"]};

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCurrency = 'USD';
  List<String> rates = [];
  List<String> crypto = [];
  dynamic prices;

  Future<dynamic> getCurrentPrice() async {
    rates.clear();
    crypto.clear();

    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$selectedCurrency?invert=true&filter_asset_id=${cryptoList.join(',')}',
        headers: header);

    prices = jsonDecode(response.body)['rates'];
    return prices;
  }

  void updateUI() {
    setState(() {
      if (prices == null) {
        rates = ["?", "?", "?"];
        crypto = cryptoList;
      } else {
        for (Map<String, dynamic> price in prices) {
          rates.add(price['rate']);
          crypto.add(price['asset_id_quote']);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("🤑 Coin Ticker"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PriceCard(
            cryptoCurrency: crypto.isEmpty ? cryptoList[0] : crypto[0],
            fiat: selectedCurrency,
            price: '?',
          ),
          Container(
            alignment: Alignment.center,
            height: mediaQuery.size.height / 7,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSpicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker iOSpicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: currenciesList.map((e) => Text(e)).toList(),
      itemExtent: 32.0,
      onSelectedItemChanged: (index) =>
          selectedCurrency = currenciesList[index],
    );
  }

  DropdownButton androidDropdown() {
    return DropdownButton(
      value: selectedCurrency,
      items: currenciesList
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (value) => setState(() {
        selectedCurrency = value;
      }),
    );
  }
}
