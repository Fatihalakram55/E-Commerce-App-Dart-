
import 'package:flutter/foundation.dart';

import '../models/model_cart.dart';
import '../models/model_produk.dart';
import 'dummy_produk.dart';

// Naik setiap isi keranjang berubah -> dipakai untuk memperbarui badge
final ValueNotifier<int> cartVersion = ValueNotifier<int>(0);

// Keranjang awal dibuat dari data produk (id & jumlah berbeda tiap item)
List<CartItem> cartItems = [
  CartItem(
    id: 1,
    nama: products[0].name, // Wireless Headphone
    harga: products[0].price.toInt(),
    gambar: products[0].image,
    jumlah: 2,
  ),
  CartItem(
    id: 2,
    nama: products[1].name, // Smart Watch
    harga: products[1].price.toInt(),
    gambar: products[1].image,
    jumlah: 1,
  ),
  CartItem(
    id: 3,
    nama: products[4].name, // Mechanical Keyboard
    harga: products[4].price.toInt(),
    gambar: products[4].image,
    jumlah: 3,
  ),
  CartItem(
    id: 4,
    nama: products[5].name, // Gaming Mouse
    harga: products[5].price.toInt(),
    gambar: products[5].image,
    jumlah: 1,
  ),
];

// Tambah produk ke keranjang; jika sudah ada, jumlahnya +1
void tambahKeKeranjang(Product product) {
  final index = cartItems.indexWhere((item) => item.nama == product.name);

  if (index >= 0) {
    cartItems[index].jumlah++;
  } else {
    final idBaru = cartItems.isEmpty
        ? 1
        : cartItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    cartItems.add(CartItem(
      id: idBaru,
      nama: product.name,
      harga: product.price.toInt(),
      gambar: product.image,
      jumlah: 1,
    ));
  }
  cartVersion.value++;
}