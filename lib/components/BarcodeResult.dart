import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


void barcodeResult(String barcode) async {
  Response response = await get('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
  Map data = jsonDecode(response.body);
  print(data);
}
