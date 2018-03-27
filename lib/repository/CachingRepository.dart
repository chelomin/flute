import 'dart:async';

import 'package:flute/api/Api.dart';
import 'package:flute/cache/Cache.dart';
import 'package:flute/model/Product.dart';
import 'package:flute/model/Products.dart';
import 'Repository.dart';

class CachingRepository extends Repository {
  final int pageSize;
  final Cache<Product> cache;
  final Api api = Api();

  final pagesInProgress = Set<int>();
  final pagesCompleted = Set<int>();

  int totalProducts;

  CachingRepository({this.pageSize, this.cache});

  @override
  Future<Product> getProduct(int index) {
    final pageIndex = pageIndexFromProductIndex(index);

    if (pagesCompleted.contains(pageIndex)) {
      return cache.get(index);
    } else {
      if (pagesInProgress.contains(pageIndex)) {
        // TODO Check if we can return meaningful Future
        return null;
      } else {
        pagesInProgress.add(pageIndex);
        var future = api.getProducts(pageIndex, pageSize);
        future.asStream().listen(onData);
        return null;
      }
    }
  }

  void onData(Products products) {
    if (products != null) {
      totalProducts = products.totalProducts;
      pagesInProgress.remove(products.pageNumber);
      pagesCompleted.add(products.pageNumber);

      for (int i = 0; i < pageSize; i++) {
        cache.put(
            products.pageSize * products.pageNumber + i, products.products[i]);
      }
    } else {
      print("CachingRepository.onData(null)!!!");
    }
  }

  int pageIndexFromProductIndex(int productIndex) {
    return productIndex ~/ pageSize;
  }

}