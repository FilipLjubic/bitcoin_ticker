import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'price_card.dart';
import 'package:loading_animations/loading_animations.dart';

var header = {"X-CoinAPI-Key": DotEnv().env["API_KEY"]};

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCurrency = 'USD';
  String cryptoPrice = '?';

  Future<dynamic> getCurrentPrice() async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$selectedCurrency?invert=true&filter_asset_id=${cryptoList.join(',')}',
        headers: header);

    var prices = jsonDecode(response.body)['rates'];
    return prices;
  }

  List<PriceCard> buildCards(rates) {
    List<PriceCard> cardList = [];

    for (int i = 0; i < cryptoList.length; i++) {
      cryptoPrice =
          rates != null ? (rates[i]['rate'] as double).toStringAsFixed(2) : '?';

      cardList.add(
        PriceCard(
          cryptoCurrency:
              rates != null ? rates[i]['asset_id_quote'] : cryptoList[i],
          fiat: selectedCurrency,
          price: cryptoPrice,
        ),
      );
    }
    return cardList;
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
          FutureBuilder(
            future: getCurrentPrice(),
            builder: (context, snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = buildCards(snapshot.data);
              } else if (snapshot.hasError) {
                children = buildCards(null);
              } else {
                children = [
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: LoadingBouncingGrid.square(
                      backgroundColor: Colors.lightBlueAccent,
                      size: 150.0,
                    ),
                  ),
                ];
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              );
            },
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
        cryptoPrice = '?';
      }),
    );
  }
}
