import 'package:proyek_pos/model/ProdukModel.dart';

class CartItem {
  Produk produk;
  int count;

  CartItem({required this.produk, required this.count});

  CartItem.fromJson(Map<String, dynamic> json)
      : produk = Produk.fromJson(json['produk']),
        count = json['count'];

  Map<String, dynamic> toJson() {
    return {
      'produk': produk.toJson(),
      'count': count,
    };
  }

  // Calculate price based on product's berat and kurs
  int calculatePrice(int kurs) {
    return produk.calculatePrice(kurs) * count;
  }

  // Static method to calculate total price for a list of CartItems
  static int calculateTotalPrice(List<CartItem> cartItems, int kurs) {
    int totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.calculatePrice(kurs);
    }
    return totalPrice;
  }
}
