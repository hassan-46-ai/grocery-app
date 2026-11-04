import 'models.dart';

const paymentMethods = ['Cash on Delivery', 'Credit / Debit Card', 'Wallet'];

// (name, nameAr, emoji, weight, price in EGP, old price in EGP)
typedef _Item = (String, String, String, String, double, double);

class _Sub {
  const _Sub(this.name, this.nameAr, this.emoji, this.items);
  final String name, nameAr, emoji;
  final List<_Item> items;
}

const _data = <(String, String, String, List<_Sub>)>[
  ('Vegetables & Fruits', 'خضروات وفاكهة', '🍎', [
    _Sub('Fruits', 'فواكه', '🍌', [
      ('Banana', 'موز', '🍌', '1 kg', 45, 52),
      ('Mango', 'مانجو', '🥭', '1 kg', 90, 105),
      ('Lemon', 'ليمون', '🍋', '1 kg', 40, 48),
      ('Mandarin', 'يوسفي', '🍊', '1 kg', 35, 42),
      ('Peach', 'خوخ', '🍑', '1 kg', 70, 85),
      ('Kiwi', 'كيوي', '🥝', '500 g', 80, 95),
    ]),
    _Sub('Vegetables', 'خضروات', '🥦', [
      ('Packed Carrots', 'جزر معبأ', '🥕', '500 g', 22, 26),
      ('Green Pepper', 'فلفل أخضر', '🫑', '1 kg', 40, 48),
      ('Chinese Cabbage', 'كرنب صيني', '🥬', '1 kg', 20, 25),
    ]),
  ]),
  ('Dairy & Bakery', 'ألبان ومخبوزات', '🥛', [
    _Sub('Milk', 'ألبان', '🥛', [
      ('Juhayna Full Cream Milk', 'حليب جهينة كامل الدسم', '🥛', '1 L', 52, 58),
      ('Juhayna Skimmed Milk', 'حليب جهينة خالي الدسم', '🥛', '1 L', 52, 58),
      ('Nido Milk Powder', 'لبن بودرة نيدو', '🥛', '900 g', 340, 380),
    ]),
    _Sub('Eggs', 'بيض', '🥚', [
      ('Eggs', 'بيض', '🥚', '10 pcs', 65, 75),
    ]),
    _Sub('Bakery', 'مخبوزات', '🍞', [
      ('Fino Bread', 'عيش فينو', '🥖', '6 pcs', 20, 24),
      ('Croissant', 'كرواسون', '🥐', '1 pc', 20, 25),
    ]),
  ]),
  ('Cold Drinks & Juices', 'مشروبات وعصائر', '🥤', [
    _Sub('Juices', 'عصائر', '🧃', [
      ('Juhayna Tangerine Juice', 'عصير جهينة يوسفي', '🧃', '1 L', 40, 46),
    ]),
    _Sub('Soft Drinks', 'مشروبات غازية', '🥤', [
      ('Schweppes Peach', 'شويبس خوخ', '🥤', '250 ml', 28, 32),
      ('Schweppes Gold', 'شويبس جولد', '🥤', '250 ml', 28, 32),
    ]),
    _Sub('Water', 'مياه', '💧', [
      ('Ogi Water', 'مياه أوجي', '💧', '1.5 L', 10, 12),
    ]),
  ]),
  ('Snacks & Instant Food', 'سناكس وأطعمة سريعة', '🍿', [
    _Sub('Snacks', 'سناكس', '🍿', [
      ('Chipsy Forno Cheese', 'شيبسي فورنو جبنة', '🥔', '60 g', 12, 15),
      ('Break Hot', 'بريك حار', '🍟', '40 g', 8, 10),
      ('Bake Rolz Chilli & Lemon', 'بيك رولز شطة وليمون', '🍘', '70 g', 18, 22),
    ]),
    _Sub('Noodles', 'نودلز', '🍜', [
      ('Chicken Noodles', 'نودلز بالدجاج', '🍜', '75 g', 8, 10),
    ]),
  ]),
  ('Tea & Coffee', 'شاي وقهوة', '☕', [
    _Sub('Tea', 'شاي', '🍵', [
      ('Lipton Yellow Label Tea', 'شاي ليبتون يلو ليبل', '🍵', '250 g', 95, 110),
      ('El Arosa Tea', 'شاي العروسة', '🫖', '100 g', 35, 40),
    ]),
    _Sub('Coffee', 'قهوة', '☕', [
      ('Al Yemeni Plain Coffee', 'بن اليمني سادة', '☕', '200 g', 150, 170),
      ('Al Yemeni Cardamom Coffee', 'بن اليمني محوج', '☕', '200 g', 165, 185),
      ('Nescafe Classic', 'نسكافيه كلاسيك', '☕', '1 pc', 8, 10),
    ]),
    _Sub('Cocoa & Sahlab', 'كاكاو وسحلب', '🍫', [
      ('Abu Auf Cocoa Powder', 'كاكاو أبو عوف', '🍫', '200 g', 75, 90),
      ('Abu Auf Sahlab', 'سحلب أبو عوف', '🥛', '250 g', 85, 100),
    ]),
  ]),
  ('Pasta, Rice & Sugar', 'مكرونة وأرز وسكر', '🍝', [
    _Sub('Pasta', 'مكرونة', '🍝', [
      ('Masreya Penne', 'مكرونة المصرية قلم', '🍝', '400 g', 17, 20),
      ('Hawa Small Rings', 'مكرونة حواء حلقات صغيرة', '🍝', '1 kg', 45, 52),
      ('El Malika Rings', 'مكرونة الملكة حلقات', '🍝', '400 g', 16, 19),
    ]),
    _Sub('Rice', 'أرز', '🍚', [
      ('Dobella Basmati Rice', 'أرز دوبيلا بسمتي', '🍚', '1 kg', 105, 120),
    ]),
    _Sub('Sugar & Salt', 'سكر وملح', '🧂', [
      ('Haboba Powdered Sugar', 'سكر ناعم حبوبة', '🧂', '1 kg', 42, 48),
      ('Cooks Salt', 'ملح كوكس', '🧂', '700 g', 10, 12),
    ]),
  ]),
  ('Spices, Oil & Sauces', 'بهارات وزيوت وصلصات', '🌶️', [
    _Sub('Spices', 'بهارات', '🌶️', [
      ('Abu Auf Chili Powder', 'شطة أبو عوف', '🌶️', '90 g', 40, 48),
      ('Abu Auf Turmeric', 'كركم أبو عوف', '🟡', '90 g', 40, 48),
    ]),
    _Sub('Oil', 'زيوت', '🫒', [
      ('Crystal Corn Oil', 'زيت كريستال ذرة', '🌽', '1 L', 95, 110),
      ('Extra Virgin Olive Oil', 'زيت زيتون بكر ممتاز', '🫒', '250 ml', 150, 175),
    ]),
    _Sub('Sauces & Stock', 'صلصات ومرقة', '🍅', [
      ('Heinz Tomato Ketchup', 'كاتشب هاينز', '🍅', '500 g', 55, 65),
      ('Heinz Tomato Paste', 'صلصة طماطم هاينز', '🍅', '190 g', 45, 52),
      ('Knorr Chicken Stock', 'مرقة كنور دجاج', '🍗', '24 pcs', 65, 75),
      ('Koki Chicken Bouillon', 'مرقة كوكي دجاج', '🍗', '12 pcs', 14, 16),
    ]),
  ]),
  ('Nuts & Meat', 'مكسرات ولحوم', '🥜', [
    _Sub('Nuts', 'مكسرات', '🥜', [
      ('Almonds', 'لوز', '🥜', '250 g', 140, 165),
      ('Walnuts', 'عين جمل', '🌰', '250 g', 150, 175),
    ]),
    _Sub('Meat', 'لحوم', '🥩', [
      ('Beef Cubes', 'لحم بقري مقطع', '🥩', '500 g', 190, 215),
    ]),
  ]),
];

final _catalog = _build();
final List<Category> categories = _catalog.$1;
final List<Product> allProducts = _catalog.$2;

(List<Category>, List<Product>) _build() {
  var id = 0;
  final cats = <Category>[];
  final products = <Product>[];
  for (final (catName, catAr, catEmoji, subs) in _data) {
    cats.add(Category(catName, catAr, catEmoji, [for (final s in subs) SubCategory(s.name, s.nameAr, s.emoji)]));
    for (final s in subs) {
      for (final (name, nameAr, emoji, weight, price, old) in s.items) {
        id++;
        products.add(Product(
          id: id,
          name: name,
          nameAr: nameAr,
          emoji: emoji,
          weight: weight,
          category: catName,
          categoryAr: catAr,
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
