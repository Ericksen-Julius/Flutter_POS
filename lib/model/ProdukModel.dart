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
}
