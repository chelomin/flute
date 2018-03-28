import 'dart:async';
import 'dart:collection';

import 'package:flute/api/Api.dart';
import 'package:flute/cache/Cache.dart';
import 'package:flute/model/Product.dart';
import 'package:flute/model/Products.dart';
import 'package:flute/logger/logger.dart';
import 'Repository.dart';

class CachingRepository extends Repository {
  final int pageSize;
  final Cache<Product> cache;
  final Api api = Api();

  final pagesInProgress = Set<int>();
  final pagesCompleted = Set<int>();
  final completers = HashMap<int, Set<Completer>>();

  int totalProducts;

  CachingRepository({this.pageSize, this.cache});

  @override
  Future<Product> getProduct(int index) {
    final pageIndex = pageIndexFromProductIndex(index);

    if (pagesCompleted.contains(pageIndex)) {
      return cache.get(index);
    } else {
      if (!pagesInProgress.contains(pageIndex)) {
        pagesInProgress.add(pageIndex);
        var future = api.getProducts(pageIndex, pageSize);
        future.asStream().listen(onData);
      }
      return buildFuture(index);
    }
  }

  Future<Product> buildFuture(int index) {
    var completer = Completer<Product>();

    if (completers[index] == null) {
      completers[index] = Set<Completer>();
    }
    completers[index].add(completer);

    log("*** Created future for ${index}");

    return completer.future;
  }

  void onData(Products products) {
    if (products != null) {
      totalProducts = products.totalProducts;
      pagesInProgress.remove(products.pageNumber);
      pagesCompleted.add(products.pageNumber);

      for (int i = 0; i < pageSize; i++) {
        int index = products.pageSize * products.pageNumber + i;
        Product product = products.products[i];

        cache.put(index, product);
        Set<Completer> comps = completers[index];

        if (comps != null) {
          for (var completer in comps) {
            log("*** Completed future for ${index}");
            completer.complete(product);
          }
          comps.clear();
        }
      }
    } else {
      log("CachingRepository.onData(null)!!!");
    }
  }

  int pageIndexFromProductIndex(int productIndex) {
    return productIndex ~/ pageSize;
  }
}
