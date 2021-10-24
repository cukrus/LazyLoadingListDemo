import 'dart:convert';

import 'package:lazy_loading_list_demo/model/shop_item.dart';
import 'package:http/http.dart' as http;

class ShopItemService {
  static ShopItemService? _instance;

  ShopItemService._();

  static ShopItemService get instance {
    _instance ??= ShopItemService._();
    return _instance!;
  }

  /// method for fetching ShopItems in paged like manner;
  /// the length of fetched list is <i>to - from</i> or less if no more items found;
  /// for example fetchItems(0, 10) would return list.length == 10 or less if no more items found;
  ///
  /// <i>from</i> - inclusive, > 0; <i>to</i> - exclusive, > <i>from</i>; returns <b>null</b> otherwise
  Future<List<ShopItem>?> fetchItems(int from, int to) async {
    if (from < 0 || to <= from) {
      return null;
    }
    List<ShopItem> generated = List.generate(to - from, (index) => ShopItem.generate(from++));
    var url = Uri.parse('http://postman-echo.com/post');
    var response = await http.post(url, body: jsonEncode(generated));
    if (response.statusCode != 200) return null;
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> decodedData = jsonDecode(responseBody['data']);
    List<ShopItem> fetched = <ShopItem>[];
    for (var element in decodedData) {
      fetched.add(ShopItem.fromJson(element));
    }
    return fetched;
  }
}