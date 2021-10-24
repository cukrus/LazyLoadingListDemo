import 'package:flutter_test/flutter_test.dart';
import 'package:lazy_loading_list_demo/model/shop_item.dart';

void main() {
  group('ShopItem', () {
    test('generate constructor should fill all fields', () {
      //given
      int id = 0;
      //when
      ShopItem shopItem = ShopItem.generate(id);
      //then
      expect(shopItem.id, id);
      expect(shopItem.price, isNotNull);
      expect(shopItem.title, "ShopItem$id Title");
      expect(shopItem.description, "ShopItem$id Description");
      expect(shopItem.photoUrl, "https://picsum.photos/200?random=$id");
      expect(shopItem.manufacturer, "ShopItem$id Manufacturer");
      expect(shopItem.storageInfo, "ShopItem$id StorageInfo");
    });

    test('toJson should return a map representation of ShopItem', () {
      //given
      ShopItem shopItem = ShopItem.generate(0);
      //when
      Map<String, dynamic> jsonMap = shopItem.toJson();
      //then
      expect(jsonMap['id'], shopItem.id);
      expect(jsonMap['price'], shopItem.price);
      expect(jsonMap['title'], shopItem.title);
      expect(jsonMap['description'], shopItem.description);
      expect(jsonMap['photoUrl'], shopItem.photoUrl);
      expect(jsonMap['manufacturer'], shopItem.manufacturer);
      expect(jsonMap['storageInfo'], shopItem.storageInfo);
    });

    test('fromJson constructor should fill all fields', () {
      //given
      Map<String, dynamic> jsonMap = <String, dynamic>{};
      jsonMap['id'] = 0;
      jsonMap['price'] = 0.99;
      jsonMap['title'] = "someTitle";
      jsonMap['description'] = "someDescription";
      jsonMap['photoUrl'] = "someUrl";
      jsonMap['manufacturer'] = "someManufacturer";
      jsonMap['storageInfo'] = "someStorageInfo";
      //when
      ShopItem shopItem = ShopItem.fromJson(jsonMap);
      //then
      expect(shopItem.id, jsonMap['id']);
      expect(shopItem.price, jsonMap['price']);
      expect(shopItem.title, jsonMap['title']);
      expect(shopItem.description, jsonMap['description']);
      expect(shopItem.photoUrl, jsonMap['photoUrl']);
      expect(shopItem.manufacturer, jsonMap['manufacturer']);
      expect(shopItem.storageInfo, jsonMap['storageInfo']);
    });
  });
}