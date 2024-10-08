class NotaModel {
  String? noDok;
  String? noHp;
  String? userInput;
  String? tanggal;
  String? kodeBayar;
  String? nominal;
  String? noRek;
  String? discount;
  String? customerName;
  String? userName;
  List<Barang>? barang;

  NotaModel({
    this.noDok,
    this.noHp,
    this.userInput,
    this.tanggal,
    this.kodeBayar,
    this.nominal,
    this.noRek,
    this.discount,
    this.customerName,
    this.userName,
    this.barang,
  });

  NotaModel.fromJson(Map<String, dynamic> json) {
    noDok = json['NO_DOK'];
    noHp = json['NO_HP'];
    userInput = json['USER_INPUT'];
    tanggal = json['TANGGAL'];
    kodeBayar = json['KODE_BAYAR'];
    nominal = json['NOMINAL'];
    noRek = json['NO_REK'];
    discount = json['DISCOUNT'];
    customerName = json['CUSTOMER_NAME'];
    userName = json['USER_NAME'];
    if (json['barang'] != null) {
      barang = <Barang>[];
      json['barang'].forEach((v) {
        barang!.add(Barang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NO_DOK'] = this.noDok;
    data['NO_HP'] = this.noHp;
    data['USER_INPUT'] = this.userInput;
    data['TANGGAL'] = this.tanggal;
    data['KODE_BAYAR'] = this.kodeBayar;
    data['NOMINAL'] = this.nominal;
    data['NO_REK'] = this.noRek;
    data['DISCOUNT'] = this.discount;
    data['CUSTOMER_NAME'] = this.customerName;
    data['USER_NAME'] = this.userName;
    if (this.barang != null) {
      data['barang'] = this.barang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Barang {
  String? nama;
  String? barcode;
  String? count;
  String? kurs;
  String? harga;

  Barang({this.nama, this.barcode, this.count, this.kurs, this.harga});

  Barang.fromJson(Map<String, dynamic> json) {
    nama = json['NAMA'];
    barcode = json['BARCODE'];
    count = json['COUNT'];
    kurs = json['KURS'];
    harga = json['HARGA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NAMA'] = this.nama;
    data['BARCODE'] = this.barcode;
    data['COUNT'] = this.count;
    data['KURS'] = this.kurs;
    data['HARGA'] = this.harga;
    return data;
  }
}
