import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/utils/network_helper.dart';

String apiKey = '403E5966-D5A6-44A1-A9E9-D66CFB371026';
String apiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CurrencyHelper {
  bool loading;
  String? currency;
  List<double> values = [0, 0, 0];

  CurrencyHelper({this.loading = false});

  Future<double> calculateCurrencyByCripto(String crypto) async {
    String url = apiUrl + '/$crypto/${this.currency}';

    dynamic response = await NetworkHelper(url: url, apiKey: apiKey).getData();

    return response['rate']?.toStringAsFixed(0) ?? 0;
  }

  void updateCurrency(String currency) {
    this.loading = true;
    this.currency = currency;
  }

  void updateValues(List<double> values) {
    this.values = values;
    this.loading = false;
  }

  Future<List<double>> calculateCryptosByCurrency() async {
    return Future.wait(cryptoList.map((String crypto) {
      return this.calculateCurrencyByCripto(crypto);
    }));
  }
}
