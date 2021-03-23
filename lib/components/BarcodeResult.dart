import 'dart:convert';
import 'package:http/http.dart';

Future<String> barcodeResult(String barcode) async {
  //Getting barcode data
  Response response = await get('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
  try {
    String data = jsonDecode(response.body)["product"]["product_name"];
    return data;
  }catch(e) {
    return "noData";
  }
}
