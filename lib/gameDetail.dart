
class GameDetail {
  final String name;
  final int appid;
  final String image;
  final bool isFree;
  final List publishers;
  final String shortDescription;
  final String longDescription;
  final String price;

  GameDetail({required this.name,
    required this.appid,
    required this.image,
    required this.isFree,
    required this.publishers,
    required this.price,
    required this.shortDescription,
    required this.longDescription});

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      name: json['name'],
      appid: int.parse(json['steam_appid']),
      image: json['header_image'],
      isFree: json['is_free'],
      price: json['price_overview']['initial'],
      publishers: json['publishers'],
      shortDescription: json['short_description'],
      longDescription: json['detailed_description'],
    );
  }

}

