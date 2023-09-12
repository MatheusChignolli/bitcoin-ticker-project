import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  final String apiKey;

  NetworkHelper({required this.url, required this.apiKey});

  dynamic getData() async {
    http.Response response =
        await http.get(Uri.parse(url), headers: {'X-CoinAPI-Key': apiKey});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('getData error: ' + response.statusCode.toString());
      return {};
    }
  }
}
