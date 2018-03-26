import 'package:flute/model/Product.dart';

class Products {
  final List<Product> products;
  final int totalProducts;
  final int pageNumber;
  final int pageSize;

  Products({this.products, this.totalProducts, this.pageNumber, this.pageSize});

  Products.fromMap(Map<String, dynamic> map)
      : products = map['products'].map((product) => new Product.fromMap(product)).toList(),
        totalProducts = map['totalProducts'],
        pageNumber = map['pageNumber'],
        pageSize = map['pageSize'];
}
