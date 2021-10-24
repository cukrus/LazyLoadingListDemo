import 'dart:math';

final Random random = Random();

class ShopItem {
  int? id;
  double? price;
  String? title;
  String? description;
  String? photoUrl;
  String? manufacturer;
  String? storageInfo;

  ShopItem();

  ShopItem.generate(this.id) {
    price = random.nextDouble() + (random.nextInt(14) + 1);
    title = "ShopItem$id Title";
    description = "ShopItem$id Description";
    photoUrl = "https://picsum.photos/200?random=$id";
    manufacturer = "ShopItem$id Manufacturer";
    storageInfo = "ShopItem$id StorageInfo";
  }

  ShopItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    title = json['title'];
    description = json['description'];
    photoUrl = json['photoUrl'];
    manufacturer = json['manufacturer'];
    storageInfo = json['storageInfo'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'price': price,
    'title': title,
    'description': description,
    'photoUrl': photoUrl,
    'manufacturer': manufacturer,
    'storageInfo': storageInfo,
  };
}