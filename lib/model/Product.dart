class Product {
  final String productId;
  final String productName;
  final String shortDescription;
  final String longDescription;
  final String price;
  final String productImage;
  final double reviewRating;
  final int reviewCount;
  final bool inStock;

  const Product({
    this.productId,
    this.productName,
    this.shortDescription,
    this.longDescription,
    this.price,
    this.productImage,
    this.reviewRating,
    this.reviewCount,
    this.inStock
  });

  Product.fromMap(Map<String, dynamic>  map) :
    productId = map['productId'],
    productName = map['productName'],
    shortDescription = map['shortDescription'],
    longDescription = map['longDescription'],
    price = map['price'],
    productImage = map['productImage'],
    reviewRating = map['reviewRating'],
    reviewCount = map['reviewCount'],
    inStock = map['inStock'];
}