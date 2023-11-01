class SahamGrowth {
  int? id;
  String? label;
  String? closeTime;
  String? createdAt;
  double? profit;

  SahamGrowth._privateConstructor({this.id, this.label, this.closeTime, this.createdAt, this.profit});

  factory SahamGrowth.createObject({id = 0, label, closeTime, profit, createdAt}) {
    return SahamGrowth._privateConstructor(
      id: id,
      label: label,
      closeTime: closeTime,
      profit: profit,
      createdAt: createdAt
    );
  }

  factory SahamGrowth.fromMap(Map data) {
    try {
      return SahamGrowth._privateConstructor(
        id: data["id"] ?? 0,
        label: data["label"] ?? "",
        closeTime: data["closeTime"] ?? "", 
        profit: data["profit"] ?? 0.0
      );
    } catch(_) {}

    return SahamGrowth._privateConstructor();
  }

  factory SahamGrowth.fromMapApiv2(Map data) {
    try {
      return SahamGrowth._privateConstructor(
        id: int.tryParse(data["id"].toString()) ?? 0,
        label: data["label"] ?? "",
        closeTime: data["close_time"] ?? "",
        createdAt: data["CREATED_AT"] ?? "",
        profit: double.tryParse(data["pips"].toString()) ?? 0.0
      );
    } catch(_) {

    }

    return SahamGrowth._privateConstructor();
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "label": label, "closeTime": closeTime, "profit": profit};
  }
}