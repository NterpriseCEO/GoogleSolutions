import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


Future<String> barcodeResult(String barcode) async {
  Response response = await get('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
  String data = jsonDecode(response.body)["product"]["product_name"];
  print(data);
  return data;
}
