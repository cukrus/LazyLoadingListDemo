import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
  final _itemList = <ShopItem>[];
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
          _itemList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _hasMore ? _itemList.length + 1 : _itemList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= _itemList.length) {
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
          leading: CachedNetworkImage(
            imageUrl: _itemList[index].photoUrl!,
            placeholder: (context, url) => const SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 24),
          ),
          title: Text(_itemList[index].title!, style: _biggerFont),
          onTap: () => showDialog(
              context: context,
              builder: (cntxt) =>
                  Dialog(child: _ShopItemDetails(_itemList[index]))),
        );
      },
    );
  }
}

class _ShopItemDetails extends StatefulWidget {
  final ShopItem shopItem;

  const _ShopItemDetails(this.shopItem, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopItemDetailsState();
}

class _ShopItemDetailsState extends State<_ShopItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: widget.shopItem.photoUrl!,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Text(widget.shopItem.title!),
        ListTile(leading: const Text("Kaina:"), title: Text("${widget.shopItem.price!}")),
        ListTile(leading: const Text("Aprašymas:"), title: Text(widget.shopItem.description!)),
        ListTile(leading: const Text("Gamintojas:"), title: Text(widget.shopItem.manufacturer!)),
        ListTile(leading: const Text("Laikymo Sąlygos:"), title: Text(widget.shopItem.storageInfo!)),
      ],
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
