class Kurs {
  String? tanggal;
  String? kurs;

  Kurs({this.tanggal, this.kurs});

  Kurs.fromJson(Map<String, dynamic> json) {
    tanggal = json['TANGGAL'];
    kurs = json['KURS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TANGGAL'] = tanggal;
    data['KURS'] = kurs;
    return data;
  }
}
