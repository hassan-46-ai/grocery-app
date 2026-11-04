import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  // ---- session / settings ----
  bool onboardingSeen = false;
  bool loggedIn = false;
  UserProfile user = const UserProfile();
  ThemeMode themeMode = ThemeMode.system;
  int tab = 0;
  int payment = 0;

  // ---- shop ----
  final Set<int> _favorites = {};
  final Map<int, int> _cart = {};
  final List<Order> _orders = [];
  String query = '';
  ProductFilter filter = const ProductFilter();

  void _load() {
    onboardingSeen = _prefs.getBool('onboarding') ?? false;
    loggedIn = _prefs.getBool('loggedIn') ?? false;
    payment = _prefs.getInt('payment') ?? 0;
    final u = _prefs.getString('user');
    if (u != null) user = UserProfile.fromJson(jsonDecode(u));
    final t = _prefs.getString('theme');
    themeMode = ThemeMode.values.firstWhere((m) => m.name == t, orElse: () => ThemeMode.system);
    _favorites.addAll((_prefs.getStringList('favs') ?? []).map(int.parse));
  }

  void _saveUser() => _prefs.setString('user', jsonEncode(user.toJson()));

  // ---- navigation / settings ----
  void setTab(int i) {
    tab = i;
    notifyListeners();
  }

  void setThemeMode(ThemeMode m) {
    themeMode = m;
    _prefs.setString('theme', m.name);
    notifyListeners();
  }

  void setPayment(int i) {
    payment = i;
    _prefs.setInt('payment', i);
    notifyListeners();
  }

  // ---- auth ----
  void completeOnboarding() {
    onboardingSeen = true;
    _prefs.setBool('onboarding', true);
    notifyListeners();
  }

  void login(String phone) {
    if (user.phone != phone) {
      user = UserProfile(name: 'Grocery Lover', phone: phone);
      _saveUser();
    }
    loggedIn = true;
    tab = 0;
    _prefs.setBool('loggedIn', true);
    notifyListeners();
  }

  void signUp(UserProfile profile) {
    user = profile;
    _saveUser();
    loggedIn = true;
    tab = 0;
    _prefs.setBool('loggedIn', true);
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    _cart.clear();
    tab = 0;
    _prefs.setBool('loggedIn', false);
    notifyListeners();
  }

  void updateProfile(UserProfile p) {
    user = p;
    _saveUser();
    notifyListeners();
  }

  // ---- catalog ----
  Product productById(int id) => allProducts.firstWhere((p) => p.id == id);

  List<Product> productsIn(String category, String sub) =>
      allProducts.where((p) => p.category == category && p.sub == sub).toList();

  List<Product> get bestDeals {
    final list = [...allProducts]..sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    return list.take(8).toList();
  }

  // ---- search & filters ----
  bool get isSearching => query.trim().isNotEmpty || filter.isActive;

  List<Product> get filteredProducts {
    final q = query.trim().toLowerCase();
    final list = allProducts.where((p) {
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q);
      final matchesCategory = filter.categories.isEmpty || filter.categories.contains(p.category);
      return matchesQuery && matchesCategory && p.price <= filter.maxPrice && p.rating >= filter.minRating;
    }).toList();

    switch (filter.sort) {
      case SortBy.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortBy.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortBy.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortBy.none:
        break;
    }
    return list;
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setFilter(ProductFilter f) {
    filter = f;
    notifyListeners();
  }

  void clearSearch() {
    query = '';
    filter = const ProductFilter();
    notifyListeners();
  }

  // ---- favourites ----
  bool isFavorite(int id) => _favorites.contains(id);

  List<Product> get favoriteProducts => allProducts.where((p) => _favorites.contains(p.id)).toList();

  void toggleFavorite(int id) {
    _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    _prefs.setStringList('favs', _favorites.map((e) => '$e').toList());
    notifyListeners();
  }

  void addAllFavoritesToCart() {
    for (final p in favoriteProducts) {
      _cart[p.id] = (_cart[p.id] ?? 0) + 1;
    }
    notifyListeners();
  }

  // ---- cart ----
  List<CartItem> get cartItems => _cart.entries.map((e) => CartItem(productById(e.key), e.value)).toList();

  int get cartCount => _cart.values.fold(0, (a, b) => a + b);

  double get cartTotal => cartItems.fold(0.0, (sum, i) => sum + i.total);

  int qtyOf(int id) => _cart[id] ?? 0;

  void addToCart(Product p, {int qty = 1}) {
    _cart[p.id] = (_cart[p.id] ?? 0) + qty;
    notifyListeners();
  }

  void setQty(int id, int qty) {
    qty <= 0 ? _cart.remove(id) : _cart[id] = qty;
    notifyListeners();
  }

  void removeFromCart(int id) {
    _cart.remove(id);
    notifyListeners();
  }

  // ---- orders ----
  List<Order> get orders => List.unmodifiable(_orders);

  Order placeOrder({required String address, required String payment, required double total}) {
    final order = Order(
      id: 'GR${DateTime.now().millisecondsSinceEpoch % 100000}',
      items: cartItems,
      total: total,
      date: DateTime.now(),
      address: address,
      payment: payment,
    );
    _orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    return order;
  }
}
