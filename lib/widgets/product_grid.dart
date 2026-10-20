import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  // variabel yang menampung data produk dari API
  List products = [];


  //request API

  // pakai future karna data di dapatkan nanti
  // menggunakan async await untuk menunggu data dari API
  Future<void> fetchProducts() async {
    Uri url = Uri.parse('https://fakestoreapi.com/products');

    // response dari API dimasukan ek variabel response
    final response = await http.get(url);

    // parsing json dan masukan ke variabel data
    final data = jsonDecode(response.body);

    // masukan data ke variabel products
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}