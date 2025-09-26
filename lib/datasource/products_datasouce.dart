import 'dart:convert';
import 'package:prueba_tecnica_flutter/models/exception/general_exception.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_flutter/pages/home/models/home_page.dart';

class ProductsDataSource {
  final http.Client client;
  ProductsDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<Home> getProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    final url =
        Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');

    final response = await client.get(url).timeout(const Duration(seconds: 10),
        onTimeout: () {
      throw ResponseServerException(
          'Timeout al obtener productos', ExcResponse.errorGeneral);
    });

    if (response.statusCode == 200) {
      try {
        final dataJson = json.decode(response.body) as Map<String, dynamic>;

        final cleanedData = _cleanNullFields(dataJson);

        final responseObject = Home.fromJson(cleanedData);

        if (responseObject != null) {
          return responseObject;
        } else {
          throw ResponseServerException(
              'Error al deserializar los productos', ExcResponse.errorGeneral);
        }
      } catch (e) {
        print('Error al obtener productos: $e');
        throw ResponseServerException(
            'Error al procesar los productos: $e', ExcResponse.errorGeneral);
      }
    } else {
      throw ResponseServerException(
          'Falla en la solicitud de productos: ${response.statusCode}',
          ExcResponse.errorGeneral);
    }
  }

  Map<String, dynamic> _cleanNullFields(Map<String, dynamic> data) {
    final cleaned = Map<String, dynamic>.from(data);

    if (cleaned.containsKey('products') && cleaned['products'] is List) {
      final products = (cleaned['products'] as List).map((product) {
        if (product is Map<String, dynamic>) {
          return _cleanProductNullFields(product);
        }
        return product;
      }).toList();

      cleaned['products'] = products;
    }

    return cleaned;
  }

  Map<String, dynamic> _cleanProductNullFields(Map<String, dynamic> product) {
    final cleanedProduct = Map<String, dynamic>.from(product);

    cleanedProduct['brand'] ??= 'Unknown Brand';
    cleanedProduct['category'] ??= 'Uncategorized';
    cleanedProduct['tags'] ??= [];
    cleanedProduct['images'] ??= [];

    return cleanedProduct;
  }
}
