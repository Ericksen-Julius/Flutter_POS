class Produk {
  String? barcodeID;
  String? nama;
  String? berat;
  String? kategori;
  String? foto;

  Produk({this.barcodeID, this.nama, this.berat, this.kategori, this.foto});

  Produk.fromJson(Map<String, dynamic> json) {
    barcodeID = json['BARCODE_ID'];
    nama = json['NAMA'];
    berat = json['BERAT'];
    kategori = json['KATEGORI'];
    foto = json['FOTO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BARCODE_ID'] = barcodeID;
    data['NAMA'] = nama;
    data['BERAT'] = berat;
    data['KATEGORI'] = kategori;
    data['FOTO'] = foto;
    return data;
  }

  int calculatePrice(int kurs) {
    return (int.parse(berat!)) * kurs;
  }

  static int calculateTotalPrice(List<Produk> products, int kurs) {
    int totalPrice = 0;

    for (var product in products) {
      totalPrice += product.calculatePrice(kurs);
    }

    return totalPrice;
  }
}
