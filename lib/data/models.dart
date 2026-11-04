class SubCategory {
  final String name;
  final String emoji;
  const SubCategory(this.name, this.emoji);
}

class Category {
  final String name;
  final String emoji;
  final List<SubCategory> subs;
  const Category(this.name, this.emoji, this.subs);
}

class Product {
  final int id;
  final String name;
  final String emoji;
  final String weight;
  final String category;
  final String sub;
  final double price;
  final double oldPrice;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.emoji,
    required this.weight,
    required this.category,
    required this.sub,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  int get discountPercent => oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;

  String get description =>
      'Fresh, high quality $name carefully selected and packed for you. Stored with care and delivered straight to your door.';
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

  const UserProfile({this.name = '', this.email = '', this.phone = '', this.address = '', this.avatar = '🙂'});

  UserProfile copyWith({String? name, String? email, String? phone, String? address, String? avatar}) => UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        avatar: avatar ?? this.avatar,
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'phone': phone, 'address': address, 'avatar': avatar};

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? '',
        address: j['address'] ?? '',
        avatar: j['avatar'] ?? '🙂',
      );
}

enum SortBy { none, priceLow, priceHigh, rating }

class ProductFilter {
  static const maxPriceLimit = 20.0;

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
