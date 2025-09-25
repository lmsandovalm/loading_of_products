import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:prueba_tecnica_flutter/models/serialization/serializers.dart';

part 'details_page.g.dart';

abstract class DetailsPage implements Built<DetailsPage, DetailsPageBuilder> {
  factory DetailsPage([void Function(DetailsPageBuilder) updates]) =
      _$DetailsPage;
  DetailsPage._();

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'title')
  String get title;

  @BuiltValueField(wireName: 'description')
  String get description;

  @BuiltValueField(wireName: 'price')
  double get price;

  @BuiltValueField(wireName: 'rating')
  double get rating;

  @BuiltValueField(wireName: 'stock')
  int get stock;

  @BuiltValueField(wireName: 'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: 'brand')
  String? get brand;

  @BuiltValueField(wireName: 'category')
  String? get category;

  @BuiltValueField(wireName: 'thumbnail')
  String get thumbnail;

  @BuiltValueField(wireName: 'images')
  BuiltList<String> get images;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(DetailsPage.serializer, this)
        as Map<String, dynamic>;
  }

  static DetailsPage? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DetailsPage.serializer, json);
  }

  static Serializer<DetailsPage> get serializer => _$detailsPageSerializer;
}
