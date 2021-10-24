import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lazy_loading_list_demo/model/shop_item.dart';
import 'package:lazy_loading_list_demo/service/shop_item_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _pairList = <ShopItem>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _itemFetcher = _ItemFetcher();

  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore();
  }

  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetch().then((List<ShopItem> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _pairList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _hasMore ? _pairList.length + 1 : _pairList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= _pairList.length) {
          if (!_isLoading) {
            _loadMore();
          }
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
          );
        }
        return ListTile(
          leading: Text(index.toString(), style: _biggerFont),
          title: Text(_pairList[index].title!, style: _biggerFont),
        );
      },
    );
  }
}

class _ItemFetcher {
  final _maxCount = 103;
  final _itemsPerPage = 10;
  int _currentCount = 0;

  Future<List<ShopItem>> fetch() async {
    final list = <ShopItem>[];
    if (_currentCount < _maxCount) {
      List<ShopItem>? fetched = await ShopItemService.instance.fetchItems(
          _currentCount, min(_currentCount + _itemsPerPage, _maxCount));
      if (fetched != null) {
        list.addAll(fetched);
        _currentCount += fetched.length;
      }
    }
    return list;
  }
}
