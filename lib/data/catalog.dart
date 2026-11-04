import 'models.dart';

const paymentMethods = ['Cash on Delivery', 'Credit / Debit Card', 'Wallet'];

// (name, emoji, weight, price, oldPrice)
typedef _Item = (String, String, String, double, double);

class _Sub {
  const _Sub(this.name, this.emoji, this.items);
  final String name, emoji;
  final List<_Item> items;
}

const _data = <(String, String, List<_Sub>)>[
  ('Vegetables & Fruits', '🍎', [
    _Sub('Fruits', '🍌', [('Banana', '🍌', '1 dozen', 4, 5), ('Red Apple', '🍎', '1 kg', 5, 7), ('Strawberry', '🍓', '250 g', 4, 6)]),
    _Sub('Vegetables', '🥦', [('Tomato', '🍅', '1 kg', 3, 4), ('Broccoli', '🥦', '500 g', 3, 4), ('Carrot', '🥕', '1 kg', 2, 3)]),
    _Sub('Leafy Greens', '🥬', [('Spinach', '🥬', '250 g', 2, 3), ('Lettuce', '🥗', '1 pc', 2, 3)]),
  ]),
  ('Dairy & Breakfast', '🥛', [
    _Sub('Milk', '🥛', [('Fresh Milk', '🥛', '1 L', 2, 3), ('Almond Milk', '🥛', '1 L', 4, 5)]),
    _Sub('Eggs', '🥚', [('Farm Eggs', '🥚', '12 pcs', 3, 4), ('Brown Eggs', '🥚', '6 pcs', 2, 3)]),
    _Sub('Bread', '🍞', [('Toast Bread', '🍞', '400 g', 2, 3), ('Croissant', '🥐', '4 pcs', 4, 5)]),
  ]),
  ('Cold Drinks & Juices', '🥤', [
    _Sub('Soft Drinks', '🥤', [('Coca-Cola', '🥤', '2 L', 3, 4), ('Sparkling Soda', '🥤', '1 L', 2, 3)]),
    _Sub('Juices', '🧃', [('Orange Juice', '🧃', '1 L', 3, 4), ('Apple Juice', '🧃', '1 L', 3, 4)]),
    _Sub('Water', '💧', [('Mineral Water', '💧', '6 x 1 L', 4, 5), ('Coconut Water', '🥥', '500 ml', 2, 3)]),
  ]),
  ('Instant & Frozen Food', '🍜', [
    _Sub('Noodles', '🍜', [('Instant Noodles', '🍜', '5 pack', 3, 4), ('Cup Noodles', '🍜', '70 g', 2, 3)]),
    _Sub('Frozen', '🍕', [('Frozen Pizza', '🍕', '400 g', 7, 9), ('French Fries', '🍟', '1 kg', 5, 6)]),
    _Sub('Snacks', '🍿', [('Popcorn', '🍿', '100 g', 2, 3), ('Potato Chips', '🥔', '150 g', 2, 3)]),
  ]),
  ('Tea & Coffee', '☕', [
    _Sub('Tea', '🍵', [('Green Tea', '🍵', '25 bags', 4, 5), ('Black Tea', '🫖', '100 g', 3, 4)]),
    _Sub('Coffee', '☕', [('Ground Coffee', '☕', '250 g', 7, 9), ('Instant Coffee', '☕', '100 g', 5, 6)]),
  ]),
  ('Atta, Rice & Dal', '🌾', [
    _Sub('Atta', '🌾', [
      ('Aashirvaad Shudh Atta', '🌾', '10 kg', 12, 14),
      ('Fresh Ultimate Atta', '🌾', '5 kg', 7, 10),
      ('Fortune Fresh Atta', '🌾', '5 kg', 5, 8),
      ('Aashirwad Select Atta', '🌾', '10 kg', 12, 14),
      ('Mother Chakki Atta', '🌾', '5 kg', 8, 10),
      ('Dhruvam Wheat Atta', '🌾', '5 kg', 7, 10),
    ]),
    _Sub('Besan & Maida', '🥣', [('Besan', '🥣', '1 kg', 3, 4), ('Maida', '🥣', '1 kg', 2, 3)]),
    _Sub('Sooji', '🫓', [('Sooji Rava', '🫓', '500 g', 2, 3), ('Fine Sooji', '🫓', '1 kg', 3, 4)]),
    _Sub('Rice', '🍚', [('Basmati Rice', '🍚', '5 kg', 10, 12), ('Sona Masoori Rice', '🍚', '10 kg', 14, 16)]),
    _Sub('Poha & Daliya', '🥘', [('Thick Poha', '🥘', '500 g', 2, 3), ('Wheat Daliya', '🥘', '1 kg', 3, 4)]),
    _Sub('Toor, Urad & Chana', '🫘', [
      ('Fortune Arhar Dal', '🫘', '1 kg', 10, 12),
      ('Urad Dal', '🫘', '1 kg', 8, 9),
      ('Kabuli Chana', '🫘', '1 kg', 6, 8),
    ]),
  ]),
  ('Masala, Oil & Dry Fruits', '🌶️', [
    _Sub('Masala', '🌶️', [('Red Chilli Powder', '🌶️', '200 g', 3, 4), ('Garam Masala', '🌶️', '100 g', 3, 4)]),
    _Sub('Oil', '🫒', [('Olive Oil', '🫒', '500 ml', 9, 11), ('Sunflower Oil', '🌻', '1 L', 6, 8)]),
    _Sub('Dry Fruits', '🥜', [('Almonds', '🥜', '250 g', 8, 10), ('Cashews', '🥜', '250 g', 9, 11)]),
  ]),
  ('Chicken, Meat & Fish', '🍗', [
    _Sub('Chicken', '🍗', [('Chicken Breast', '🍗', '1 kg', 8, 10), ('Chicken Wings', '🍗', '500 g', 5, 6)]),
    _Sub('Meat', '🥩', [('Beef Steak', '🥩', '500 g', 12, 15), ('Lamb Chops', '🥩', '500 g', 14, 17)]),
    _Sub('Fish', '🐟', [('Salmon Fillet', '🐟', '300 g', 11, 13), ('Fresh Shrimp', '🦐', '500 g', 10, 12)]),
  ]),
];

final _catalog = _build();
final List<Category> categories = _catalog.$1;
final List<Product> allProducts = _catalog.$2;

(List<Category>, List<Product>) _build() {
  var id = 0;
  final cats = <Category>[];
  final products = <Product>[];
  for (final (catName, catEmoji, subs) in _data) {
    cats.add(Category(catName, catEmoji, [for (final s in subs) SubCategory(s.name, s.emoji)]));
    for (final s in subs) {
      for (final (name, emoji, weight, price, old) in s.items) {
        id++;
        products.add(Product(
          id: id,
          name: name,
          emoji: emoji,
          weight: weight,
          category: catName,
          sub: s.name,
          price: price,
          oldPrice: old,
          rating: 4.0 + (id * 7 % 10) / 10,
        ));
      }
    }
  }
  return (cats, products);
}
