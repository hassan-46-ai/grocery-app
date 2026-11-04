/// "Fresh Milk" -> "fresh_milk" (used as image file name).
String slugify(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');

class SubCategory {
  final String name;
  final String nameAr;
  final String emoji;
  const SubCategory(this.name, this.nameAr, this.emoji);
}

class Category {
  final String name;
  final String nameAr;
  final String emoji;
  final List<SubCategory> subs;
  const Category(this.name, this.nameAr, this.emoji, this.subs);
}

class Product {
  final int id;
  final String name;
  final String nameAr;
  final String emoji;
  final String weight;
  final String category;
  final String categoryAr;
  final String sub;
  final double price;
  final double oldPrice;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.emoji,
    required this.weight,
    required this.category,
    required this.categoryAr,
    required this.sub,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  /// File name (without extension) of this product's photo in assets/products/.
  String get imageKey => slugify(name);

  int get discountPercent => oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;
}

class CartItem {
  final Product product;
  final int qty;
  const CartItem(this.product, this.qty);
  double get total => product.price * qty;
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String address;
  final String payment;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.address,
    required this.payment,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatar;
  final double? lat;
  final double? lng;

  const UserProfile({this.name = '', this.email = '', this.phone = '', this.address = '', this.avatar = '🙂', this.lat, this.lng});

  UserProfile copyWith({String? name, String? email, String? phone, String? address, String? avatar, double? lat, double? lng}) => UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        avatar: avatar ?? this.avatar,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'phone': phone, 'address': address, 'avatar': avatar, 'lat': lat, 'lng': lng};

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? '',
        address: j['address'] ?? '',
        avatar: j['avatar'] ?? '🙂',
        lat: (j['lat'] as num?)?.toDouble(),
        lng: (j['lng'] as num?)?.toDouble(),
      );
}

enum SortBy { none, priceLow, priceHigh, rating }

class ProductFilter {
  static const maxPriceLimit = 400.0;

  final Set<String> categories;
  final double maxPrice;
  final double minRating;
  final SortBy sort;

  const ProductFilter({
    this.categories = const {},
    this.maxPrice = maxPriceLimit,
    this.minRating = 0,
    this.sort = SortBy.none,
  });

  bool get isActive => categories.isNotEmpty || maxPrice < maxPriceLimit || minRating > 0 || sort != SortBy.none;

  ProductFilter copyWith({Set<String>? categories, double? maxPrice, double? minRating, SortBy? sort}) =>
      ProductFilter(
        categories: categories ?? this.categories,
        maxPrice: maxPrice ?? this.maxPrice,
        minRating: minRating ?? this.minRating,
        sort: sort ?? this.sort,
      );
}
