// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Home> _$homeSerializer = new _$HomeSerializer();

class _$HomeSerializer implements StructuredSerializer<Home> {
  @override
  final Iterable<Type> types = const [Home, _$Home];
  @override
  final String wireName = 'Home';

  @override
  Iterable<Object?> serialize(Serializers serializers, Home object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'products',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(DetailsPage)])),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
      'skip',
      serializers.serialize(object.skip, specifiedType: const FullType(int)),
      'limit',
      serializers.serialize(object.limit, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Home deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HomeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'products':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DetailsPage)]))!
              as BuiltList<Object?>);
          break;
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'skip':
          result.skip = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'limit':
          result.limit = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Home extends Home {
  @override
  final BuiltList<DetailsPage> data;
  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;

  factory _$Home([void Function(HomeBuilder)? updates]) =>
      (new HomeBuilder()..update(updates))._build();

  _$Home._(
      {required this.data,
      required this.total,
      required this.skip,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'Home', 'data');
    BuiltValueNullFieldError.checkNotNull(total, r'Home', 'total');
    BuiltValueNullFieldError.checkNotNull(skip, r'Home', 'skip');
    BuiltValueNullFieldError.checkNotNull(limit, r'Home', 'limit');
  }

  @override
  Home rebuild(void Function(HomeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeBuilder toBuilder() => new HomeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Home &&
        data == other.data &&
        total == other.total &&
        skip == other.skip &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, skip.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Home')
          ..add('data', data)
          ..add('total', total)
          ..add('skip', skip)
          ..add('limit', limit))
        .toString();
  }
}

class HomeBuilder implements Builder<Home, HomeBuilder> {
  _$Home? _$v;

  ListBuilder<DetailsPage>? _data;
  ListBuilder<DetailsPage> get data =>
      _$this._data ??= new ListBuilder<DetailsPage>();
  set data(ListBuilder<DetailsPage>? data) => _$this._data = data;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _skip;
  int? get skip => _$this._skip;
  set skip(int? skip) => _$this._skip = skip;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  HomeBuilder();

  HomeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _total = $v.total;
      _skip = $v.skip;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Home other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Home;
  }

  @override
  void update(void Function(HomeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Home build() => _build();

  _$Home _build() {
    _$Home _$result;
    try {
      _$result = _$v ??
          new _$Home._(
              data: data.build(),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, r'Home', 'total'),
              skip:
                  BuiltValueNullFieldError.checkNotNull(skip, r'Home', 'skip'),
              limit: BuiltValueNullFieldError.checkNotNull(
                  limit, r'Home', 'limit'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Home', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
