class Phone {
  final int id;
  final String name;
  final String brand;
  final int price;
  final String img_url;
  final String specification;

  Phone({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.img_url,
    required this.specification,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      img_url: json['img_url'] ?? '',
      specification: json['specification'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'specification': specification,
    };
  }
}