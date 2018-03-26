import 'dart:async';
import 'dart:convert';

import 'package:flute/model/Products.dart';
import 'package:flutter/services.dart';

class Api {
  final String API_KEY = "2972a910-7d80-44e6-a595-9cf3ef0cac02";
  final String BASE_URL = "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/";

  final JsonDecoder _decoder = new JsonDecoder();

  @override
  Future<Products> getProducts(int pageNumber, int pageSize) async {
    final url = "${BASE_URL}walmartproducts/$API_KEY/$pageNumber/$pageSize";

    var clientHttp = createHttpClient();
    var response = await clientHttp.get(url);

    final String jsonBody = response.body;
    final statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:$response]");
    }

    return Products.fromMap(_decoder.convert(jsonBody));
  }
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}