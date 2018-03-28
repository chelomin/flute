import 'dart:async';
import 'package:flute/cache/Cache.dart';
import 'package:flute/cache/MemCache.dart';
import 'package:flute/model/Product.dart';
import 'package:flute/repository/CachingRepository.dart';
import 'package:flutter/material.dart';

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
          new IconButton(icon: new Icon(Icons.favorite_border), onPressed: _pushSaved)
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

  Widget _buildProductCard(Product product) {
    final alreadySaved = _saved.contains(product);

    return new ListTile(
      title: new Text(
        product.productName,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              _saved.remove(product);
            } else {
              _saved.add(product);
            }
          },
        );
      },
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
