import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flute/model/Products.dart';
import 'package:flutter/services.dart';

class Api {
  final String API_KEY = "2972a910-7d80-44e6-a595-9cf3ef0cac02";
  final String BASE_URL = "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/";

  final JsonDecoder _decoder = new JsonDecoder();

  @override
  Future<Products> getProducts(int pageNumber, int pageSize) async {
//    final url = "${BASE_URL}walmartproducts/$API_KEY/$pageNumber/$pageSize";
//
//    var clientHttp = createHttpClient();
//    var response = await clientHttp.get(url);
//
//    final String jsonBody = response.body;
//    final statusCode = response.statusCode;
//
//    if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
//      throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:$response]");
//    }
//
//    print(jsonBody);
//    var json = _decoder.convert(jsonBody);
//    var products = Products.fromMap(json);
//
//    return products;

    final url = "${BASE_URL}walmartproducts/$API_KEY/$pageNumber/$pageSize";
    final httpClient = new HttpClient();

    print(url);

    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        // Decode the json response
        var data = JSON.decode(json);
        // Get the result list
        print(data);

        return Products.fromMap(data);
      } else {
        print("Failed http call.");
      }
    } catch (exception) {
      print(exception.toString());
    }
    return null;
  }

//  getData() async {
//    var url = 'https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=pubattlegrounds&count=20';
//    var httpClient = new HttpClient();
//    try {
//      // Make the call
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.OK) {
//        var json = await response.transform(UTF8.decoder).join();
//        // Decode the json response
//        var data = JSON.decode(json);
//        // Get the result list
//        List results = data["results"];
//        // Print the results.
//        print(results);
//      } else {
//        print("Failed http call.");
//      }
//    } catch (exception) {
//      print(exception.toString());
//    }
//  }
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}