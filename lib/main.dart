import 'dart:async';
import 'package:flute/cache/Cache.dart';
import 'package:flute/cache/MemCache.dart';
import 'package:flute/model/Product.dart';
import 'package:flute/repository/CachingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Walmart coding challenge',
      theme: new ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: new Flute(),
    );
  }
}

class Flute extends StatefulWidget {
  @override
  createState() => new FluteState();
}

class FluteState extends State<Flute> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  static final Cache _cache = MemCache<Product>();

  static final _repo = CachingRepository(pageSize: 10, cache: _cache);

  void onProduct(Product product) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Need to pull something to know at least how many products do we have
    _repo.getProduct(0).asStream().listen(onProduct);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Wallaby'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        return _buildProductRow(_repo.getProduct(index));
      },
    );
  }

  Widget _buildProductRow(Future<Product> productFuture) {
    if (productFuture == null) {
      return new Text("loading");
    } else {
//      print("FutureBuilder created");
      return new FutureBuilder<Product>(
        future: productFuture,
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
//          print("FutureBuilder hit");
          if (snapshot.hasData) {
            return _buildProductCard(snapshot.data);
          } else {
            return new LinearProgressIndicator();
          }
        },
      );
    }
  }

  void showProductDetails(BuildContext context, Product product) {
    Navigator.push(
        context,
        new MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/flute/product'),
          builder: (BuildContext context) {
            return new Theme(
              data: _kTheme.copyWith(platform: Theme.of(context).platform),
              child: _buildProductDetailsPage2(product),
            );
          },
        ));
  }

  Widget _buildProductDetailsPage(Product product) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Suggestions'),
      ),
      body: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(children: <Widget>[
          new Image.network(product.productImage),
          new Flexible(
            child: new Text(
              product.productName,
              maxLines: 3,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 24.0),
            ),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: new Text(
              product.longDescription,
              style: new TextStyle(color: Colors.black87, fontSize: 14.0),
              maxLines: 1000,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildProductDetailsPage2(Product product) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(product.productName),
      ),
      body: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Image.network(product.productImage),
              new Flexible(
                child: new Text(
                  product.price,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      fontSize: 24.0),
                ),
              ),
              new Expanded(
//                fit: FlexFit.tight,
                child: new SingleChildScrollView(
                  child: new Text(
                    product.longDescription,
                    style: new TextStyle(color: Colors.black87, fontSize: 14.0),
                    maxLines: 1000,
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        showProductDetails(context, product);
      },
      child: new Row(children: [
        new Container(
          height: 64.0,
          width: 64.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: new Image.network(product.productImage),
        ),
        new Expanded(
          child:
              new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            new Flexible(
              child: new Text(
                product.productName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: new Text(
            product.price,
            textAlign: TextAlign.end,
          ),
        ),
      ]),
    );
  }

  var _saved = new Set<Product>();

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (product) {
              return new ListTile(
                title: new Text(
                  product.productName,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
