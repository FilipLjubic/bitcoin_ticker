import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCurrency = 'HRK';

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
      onChanged: (value) => setState(() => selectedCurrency = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    print(mediaQuery.size.height);
    print(mediaQuery.size.width);

    return Scaffold(
      appBar: AppBar(
        title: Text("🤑 Coin Ticker"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
            child: Card(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 15.0,
                ),
                child: Text(
                  '1 BTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
}
