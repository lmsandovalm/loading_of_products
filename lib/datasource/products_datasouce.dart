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
    // var url = Uri.parse('https://dummyjson.com/products');
    final url =
        Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');
        
    final response = await client.get(url).timeout(const Duration(seconds: 5),
        onTimeout: () {
      throw ResponseServerException(
          'Timeout al obtener productos', ExcResponse.errorGeneral);
    });
    if (response.statusCode == 200) {
      try {
        final dataJson = json.decode(response.body) as Map<String, dynamic>;
        

        final responseObject = Home.fromJson(dataJson);

        if (responseObject != null) {
          return responseObject;
        } else {
          throw ResponseServerException(
              'Estado false en la respuesta del servidor',
              ExcResponse.errorGeneral);
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
}
