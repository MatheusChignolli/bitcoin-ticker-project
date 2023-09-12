import 'dart:io';
import 'package:bitcoin_ticker/utils/currency_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

List<Widget> getIosDropdownItems(List<String> items) {
  return items.map((String value) {
    return Text(value);
  }).toList();
}

List<DropdownMenuItem> getAndroidDropdownItems(List<String> items) {
  return items.map((String value) {
    return DropdownMenuItem(
      child: Text(value),
      value: value,
    );
  }).toList();
}

class _PriceScreenState extends State<PriceScreen> {
  CurrencyHelper currencyHelper = CurrencyHelper(loading: false);

  void update(String value) async {
    setState(() {
      currencyHelper.updateCurrency(value);
    });

    dynamic values = await currencyHelper.calculateCryptosByCurrency();

    setState(() {
      currencyHelper.updateValues(values);
    });
  }

  Widget getCurrencyDropdown() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        itemExtent: 26,
        onSelectedItemChanged: (value) => update(currenciesList[value]),
        children: getIosDropdownItems(currenciesList),
        squeeze: 1,
      );
    }

    return Center(
      child: DropdownButton(
        value: currencyHelper.currency,
        items: getAndroidDropdownItems(currenciesList),
        onChanged: (value) => update(value),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    update(currenciesList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList
                .map(
                  (crypto) => Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                    child: Card(
                      color: Colors.lightBlueAccent,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                        child: Text(
                          currencyHelper.loading
                              ? 'Carregando...'
                              : '1 $crypto = ${currencyHelper.values[cryptoList.indexOf(crypto)]} ${currencyHelper.currency}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: getCurrencyDropdown()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
