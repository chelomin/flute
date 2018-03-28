import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flute/logger/logger.dart';

import 'package:flute/model/Products.dart';

class Api {
  final String API_KEY = "2972a910-7d80-44e6-a595-9cf3ef0cac02";
  final String BASE_URL =
      "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/";

  @override
  Future<Products> getProducts(int pageNumber, int pageSize) async {
    final url = "${BASE_URL}walmartproducts/$API_KEY/$pageNumber/$pageSize";
    final httpClient = new HttpClient();

    log(url);

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);

        log(data);

        return Products.fromMap(data);
      } else {
        log("Failed http call.");
      }
    } catch (exception) {
      print(exception.toString());
    }
    return null;
  }
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}
