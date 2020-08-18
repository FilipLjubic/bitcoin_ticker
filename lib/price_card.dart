import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final String cryptoCurrency;
  final String price;
  final String fiat;

  PriceCard({this.cryptoCurrency, this.price, this.fiat});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $cryptoCurrency = $price $fiat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
