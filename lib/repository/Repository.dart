import 'dart:async';
import 'package:flute/model/Product.dart';

abstract class Repository {
  Future<Product> getProduct(int index);
}