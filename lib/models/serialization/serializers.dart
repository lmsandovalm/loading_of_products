import 'package:built_collection/built_collection.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';
import 'package:prueba_tecnica_flutter/pages/home/models/home_page.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'serializers.g.dart';

@SerializersFor(
  [
    Home,
    DetailsPage,
  ],
)
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
