import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:prueba_tecnica_flutter/models/serialization/serializers.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';

part 'home_page.g.dart';

abstract class Home implements Built<Home, HomeBuilder> {
  factory Home([void Function(HomeBuilder) updates]) = _$Home;
  Home._();

  @BuiltValueField(wireName: 'products')
  BuiltList<DetailsPage> get data;

  @BuiltValueField(wireName: 'total')
  int get total;

  @BuiltValueField(wireName: 'skip')
  int get skip;

  @BuiltValueField(wireName: 'limit')
  int get limit;


  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Home.serializer, this) as Map<String, dynamic>;
  }

  static Home? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Home.serializer, json);
  }

  static Serializer<Home> get serializer => _$homeSerializer;
}
