class Customer {
  String? noHp;
  String? nama;
  String? alamat;
  String? kota;

  Customer({this.noHp, this.nama, this.alamat, this.kota});

  Customer.fromJson(Map<String, dynamic> json) {
    noHp = json['NO_HP'];
    nama = json['NAMA'];
    alamat = json['ALAMAT'];
    kota = json['KOTA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NO_HP'] = noHp;
    data['NAMA'] = nama;
    data['ALAMAT'] = alamat;
    data['KOTA'] = kota;
    return data;
  }
}
