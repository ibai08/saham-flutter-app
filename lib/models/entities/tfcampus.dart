class TFCampusClass {
  final int id;
  final String name;
  final DateTime from;
  final DateTime end;
  final double price;
  final double discount;

  TFCampusClass({this.id, this.name, this.from, this.end, this.price, this.discount});

  factory TFCampusClass.fromMap(Map map) {
    return TFCampusClass(
      id: map["id"],
      name: map["name"],
      from: DateTime.parse(map["from"]),
      end: DateTime.parse(map["end"]),
      price: double.parse(map["price"].toString()),
      discount: double.parse(map["discount"].toString())
    );
  }
}

class TFCampusConfig {
  final List<String> experience;
  final List<String> source;
  final List<String> reason;

  TFCampusConfig({this.experience, this.source, this.reason});

  factory TFCampusConfig.fromMap(Map map) => TFCampusConfig(
    experience: List<String>.from(map["experience"]),
    source: List<String>.from(map["source"]),
    reason: List<String>.from(map["reason"])
  );
}