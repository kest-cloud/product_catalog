import 'dart:developer' as developer;

/// Domain entity for a product from the catalog API.
///
/// Handles missing or invalid fields with safe defaults.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.description,
    this.category,
    this.brand,
    this.thumbnail,
    this.images = const [],
    this.rating,
    this.stock,
    this.discountPercentage,
  });

  /// Stable product identifier.
  final String id;

  /// Display name.
  final String title;

  /// Optional long description.
  final String? description;

  /// Category slug or name.
  final String? category;

  /// Price as stored (e.g. 9.99).
  final double price;

  /// Optional brand name.
  final String? brand;

  /// Primary image URL.
  final String? thumbnail;

  /// Additional image URLs.
  final List<String> images;

  /// Average rating (e.g. 0–5).
  final double? rating;

  /// Stock quantity.
  final int? stock;

  /// Discount percentage (e.g. 10.5).
  final double? discountPercentage;

  /// True when price is present and positive (displayable).
  bool get hasValidPrice => price > 0;

  /// Price formatted for display, or "Price unavailable" when missing/negative.
  String get priceLabel =>
      hasValidPrice ? '\$${price.toStringAsFixed(2)}' : 'Price unavailable';

  /// Best available image URL: thumbnail or first image or empty.
  String get imageUrl => thumbnail ?? (images.isNotEmpty ? images.first : '');

  /// Brand for display; "Unknown brand" when missing.
  String get brandLabel =>
      (brand ?? '').trim().isEmpty ? 'Unknown brand' : (brand ?? '').trim();

  /// Creates [Product] from API JSON with validation and safe defaults.
  factory Product.fromJson(final Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    final String id = idValue is int
        ? idValue.toString()
        : idValue is String
            ? idValue
            : '';

    final String title = _stringOrEmpty(json['title']);
    final dynamic priceValue = json['price'];
    final double price = priceValue is num
        ? priceValue.toDouble()
        : (double.tryParse(priceValue?.toString() ?? '') ?? 0.0);

    final String? description = _stringOrNull(json['description']);
    final String? category = _stringOrNull(json['category']);
    final String? brand = _stringOrNull(json['brand']);
    final String? thumbnail = _stringOrNull(json['thumbnail']);

    List<String> images = const [];
    final dynamic imagesRaw = json['images'];
    if (imagesRaw is List) {
      images = imagesRaw
          .map((e) => e is String ? e : e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final double? rating = _doubleOrNull(json['rating']);
    final int? stock = _intOrNull(json['stock']);
    final double? discountPercentage = _doubleOrNull(json['discountPercentage']);

    final double safePrice = price < 0 ? 0 : price;
    if (safePrice <= 0) {
      developer.log(
        'Missing or invalid price for product id=$id (value: $priceValue)',
        name: 'Product',
        level: 1000,
      );
    }

    final bool noValidImage = (thumbnail ?? '').trim().isEmpty && images.isEmpty;
    if (noValidImage && id.isNotEmpty) {
      developer.log(
        'Missing or invalid image URL for product id=$id',
        name: 'Product',
        level: 900,
      );
    }

    return Product(
      id: id,
      title: title.isEmpty ? 'Unknown' : title,
      price: safePrice,
      description: description,
      category: category,
      brand: brand,
      thumbnail: thumbnail,
      images: images,
      rating: rating,
      stock: stock,
      discountPercentage: discountPercentage,
    );
  }

  static double? _doubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final d = double.tryParse(v.toString());
    return d;
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String _stringOrEmpty(dynamic v) =>
      v is String ? v : (v?.toString() ?? '');

  static String? _stringOrNull(dynamic v) {
    if (v == null) return null;
    if (v is String) return v.isEmpty ? null : v;
    if (v is Map) {
      final Object? name = v['name'];
      if (name is String && name.isNotEmpty) return name;
      final Object? slug = v['slug'];
      if (slug is String && slug.isNotEmpty) return slug;
    }
    final String s = v.toString();
    return s.isEmpty ? null : s;
  }
}
