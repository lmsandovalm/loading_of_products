// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DetailsPage> _$detailsPageSerializer = new _$DetailsPageSerializer();

class _$DetailsPageSerializer implements StructuredSerializer<DetailsPage> {
  @override
  final Iterable<Type> types = const [DetailsPage, _$DetailsPage];
  @override
  final String wireName = 'DetailsPage';

  @override
  Iterable<Object?> serialize(Serializers serializers, DetailsPage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(double)),
      'stock',
      serializers.serialize(object.stock, specifiedType: const FullType(int)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'brand',
      serializers.serialize(object.brand,
          specifiedType: const FullType(String)),
      'category',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
      'thumbnail',
      serializers.serialize(object.thumbnail,
          specifiedType: const FullType(String)),
      'images',
      serializers.serialize(object.images,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  DetailsPage deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DetailsPageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'stock':
          result.stock = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'brand':
          result.brand = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'thumbnail':
          result.thumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'images':
          result.images.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$DetailsPage extends DetailsPage {
  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  final double rating;
  @override
  final int stock;
  @override
  final BuiltList<String> tags;
  @override
  final String brand;
  @override
  final String category;
  @override
  final String thumbnail;
  @override
  final BuiltList<String> images;

  factory _$DetailsPage([void Function(DetailsPageBuilder)? updates]) =>
      (new DetailsPageBuilder()..update(updates))._build();

  _$DetailsPage._(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.rating,
      required this.stock,
      required this.tags,
      required this.brand,
      required this.category,
      required this.thumbnail,
      required this.images})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'DetailsPage', 'id');
    BuiltValueNullFieldError.checkNotNull(title, r'DetailsPage', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'DetailsPage', 'description');
    BuiltValueNullFieldError.checkNotNull(price, r'DetailsPage', 'price');
    BuiltValueNullFieldError.checkNotNull(rating, r'DetailsPage', 'rating');
    BuiltValueNullFieldError.checkNotNull(stock, r'DetailsPage', 'stock');
    BuiltValueNullFieldError.checkNotNull(tags, r'DetailsPage', 'tags');
    BuiltValueNullFieldError.checkNotNull(brand, r'DetailsPage', 'brand');
    BuiltValueNullFieldError.checkNotNull(category, r'DetailsPage', 'category');
    BuiltValueNullFieldError.checkNotNull(
        thumbnail, r'DetailsPage', 'thumbnail');
    BuiltValueNullFieldError.checkNotNull(images, r'DetailsPage', 'images');
  }

  @override
  DetailsPage rebuild(void Function(DetailsPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailsPageBuilder toBuilder() => new DetailsPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetailsPage &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        price == other.price &&
        rating == other.rating &&
        stock == other.stock &&
        tags == other.tags &&
        brand == other.brand &&
        category == other.category &&
        thumbnail == other.thumbnail &&
        images == other.images;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, thumbnail.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DetailsPage')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('price', price)
          ..add('rating', rating)
          ..add('stock', stock)
          ..add('tags', tags)
          ..add('brand', brand)
          ..add('category', category)
          ..add('thumbnail', thumbnail)
          ..add('images', images))
        .toString();
  }
}

class DetailsPageBuilder implements Builder<DetailsPage, DetailsPageBuilder> {
  _$DetailsPage? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  double? _price;
  double? get price => _$this._price;
  set price(double? price) => _$this._price = price;

  double? _rating;
  double? get rating => _$this._rating;
  set rating(double? rating) => _$this._rating = rating;

  int? _stock;
  int? get stock => _$this._stock;
  set stock(int? stock) => _$this._stock = stock;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _thumbnail;
  String? get thumbnail => _$this._thumbnail;
  set thumbnail(String? thumbnail) => _$this._thumbnail = thumbnail;

  ListBuilder<String>? _images;
  ListBuilder<String> get images =>
      _$this._images ??= new ListBuilder<String>();
  set images(ListBuilder<String>? images) => _$this._images = images;

  DetailsPageBuilder();

  DetailsPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _price = $v.price;
      _rating = $v.rating;
      _stock = $v.stock;
      _tags = $v.tags.toBuilder();
      _brand = $v.brand;
      _category = $v.category;
      _thumbnail = $v.thumbnail;
      _images = $v.images.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailsPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DetailsPage;
  }

  @override
  void update(void Function(DetailsPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DetailsPage build() => _build();

  _$DetailsPage _build() {
    _$DetailsPage _$result;
    try {
      _$result = _$v ??
          new _$DetailsPage._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'DetailsPage', 'id'),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'DetailsPage', 'title'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'DetailsPage', 'description'),
              price: BuiltValueNullFieldError.checkNotNull(
                  price, r'DetailsPage', 'price'),
              rating: BuiltValueNullFieldError.checkNotNull(
                  rating, r'DetailsPage', 'rating'),
              stock: BuiltValueNullFieldError.checkNotNull(
                  stock, r'DetailsPage', 'stock'),
              tags: tags.build(),
              brand: BuiltValueNullFieldError.checkNotNull(
                  brand, r'DetailsPage', 'brand'),
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'DetailsPage', 'category'),
              thumbnail: BuiltValueNullFieldError.checkNotNull(
                  thumbnail, r'DetailsPage', 'thumbnail'),
              images: images.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();

        _$failedField = 'images';
        images.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DetailsPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
