import 'dart:convert';
import 'package:http/http.dart' as http;
//This the barcode function
Future<String> barcodeResult(String barcode) async {
  //Getting barcode data
  http.Response response = await http.get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));
  try {
    String data = jsonDecode(response.body)["product"]["product_name"];
    return data;
  }catch(e) {
    //Return "noData" if no barcode found in the database
    return "noData";
  }
}
